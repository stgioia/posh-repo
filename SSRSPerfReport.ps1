<# 

This script reads from the ExecutionLog3 table to extract some useful SSRS info
and Brent Ozar's sp_BlitzRS. Then it sends an e-mail with the output.

https://www.brentozar.com/blitzrs/

To improve the readability of the HTML output, you can use a custom CSS file. This is a simple example of the default.css 
that I'm using in this script:

body {
font-family:Calibri;
 font-size:10pt;
}
th { 
background-color:black;
color:white;
}
td {
 background-color:white;
color:black;
}

#>

# Get rid of old reports.
$OldReports = (Get-Date).AddDays(-360)

# SSRS credentials
$SQLUser = "ssrsuser"
$SQLPass = "replacethis"
$SQLInstance = "SV-SSRS1"
$SQLDatabase = "ReportServer"
$Query = "
CREATE TABLE #tmRS (
		Priority int,
		FindingsGroup varchar (100),
		Finding		varchar (200),
		URL			varchar (200),
		Details		varchar (500),
		CheckID		int)

INSERT INTO #tmRS
EXEC sp_BlitzRS

SELECT TOP 5 convert (varchar, ROW_NUMBER() OVER (ORDER BY count (1) DESC)) + ' - Most Executed' AS Finding, NULL AS URL,
	  'Report ' + ItemPath + ' was executed ' +  convert (varchar, count (1)) + ' times' AS Details, 0 AS CheckID,
	   10 AS Priority, 'Custom' AS FindingsGroup
	FROM ExecutionLog3
	WITH (NOLOCK)
	GROUP BY ItemPath
	UNION ALL
SELECT TOP 5 convert (varchar, ROW_NUMBER() OVER (ORDER BY AVG (TimeDataRetrieval) DESC)) + ' - TimeDataRetrieval' AS Finding,  NULL AS URL,
	  'Report ' + ItemPath + ' is taking ' +  convert (varchar, AVG (TimeDataRetrieval)/1000) + ' seconds (average)' AS Details, 0 AS CheckID,
	   10 AS Priority, 'Custom' AS FindingsGroup
	FROM ExecutionLog3
	WITH (NOLOCK)
	GROUP BY ItemPath
	UNION ALL 
SELECT TOP 5 convert (varchar, ROW_NUMBER() OVER (ORDER BY AVG (TimeProcessing) DESC)) + ' - TimeProcessing' AS Finding,  NULL AS URL,
	  'Report ' + ItemPath + ' is taking ' +  convert (varchar, AVG (TimeProcessing)/1000) + ' seconds (average)' AS Details, 0 AS CheckID,
	   10 AS Priority, 'Custom' AS FindingsGroup
	FROM ExecutionLog3
	WITH (NOLOCK)
	GROUP BY ItemPath
	UNION ALL 
SELECT TOP 5 convert (varchar, ROW_NUMBER() OVER (ORDER BY AVG (TimeRendering) DESC)) + ' - TimeRendering' AS Finding,  NULL AS URL,
	  'Report ' + ItemPath + ' is taking ' +  convert (varchar, AVG (TimeRendering)/1000) + ' seconds  (average)' AS Details, 0 AS CheckID,
	   10 AS Priority, 'Custom' AS FindingsGroup
	FROM ExecutionLog3
	WITH (NOLOCK)
	GROUP BY ItemPath
	UNION ALL
SELECT	Finding, 
		URL, 
		Details, 
		CheckID, 
		Priority, 
		Finding
	FROM #tmRS
ORDER BY Priority ASC

DROP TABLE #tmRS"

$LogDate = get-date -f yyyyMMddhhmm
$LogDateFormat = get-date -f "dd-MM-yyyy"

Get-ChildItem C:\PSReports\*.* | `
Where-Object { $_.LastWriteTime -le $OldReports} | `
Remove-Item -Recurse -Force -ErrorAction SilentlyContinue  

if ( (Get-PSSnapin -Name SqlServerCmdletSnapin100 -ErrorAction SilentlyContinue) -eq $null )
{
    Add-PsSnapin SqlServerCmdletSnapin100
}

if ( (Get-PSSnapin -Name SqlServerProviderSnapin100 -ErrorAction SilentlyContinue) -eq $null )
{
    Add-PsSnapin SqlServerProviderSnapin100
}


$results += Invoke-Sqlcmd -Username $SQLUser -Password $SQLPass -Query $Query -ServerInstance $SQLInstance -Database $SQLDatabase

$results | Where-Object {$_} | Select Priority, FindingsGroup, Finding, URL, Details, CheckID | ConvertTo-HTML -As "TABLE" -CssUri C:\PSReports\default.css | Out-File "C:\PSReports\SSRSReport_$logDate.html"

$messageParameters = @{                        
                Subject = "Monthly Report - Reporting Services performance - " + $LogDateFormat                     
                Body = "Please check the attached report for more information."              
                From = "noreply@domain.com"                        
                To = "user1@domain.com"
                CC = "user2@domain.com"
                Attachments = (Get-ChildItem C:\PSReports\*.* | sort LastWriteTime | select -last 1)
                SmtpServer = "smtp.domain.com"                        
            }   
Send-MailMessage @messageParameters -Encoding ([System.Text.Encoding]::Unicode)  