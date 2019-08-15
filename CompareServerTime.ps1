<#
Pretty simple PRTG script to compare the time of all local Windows servers against a single server (i.e. Domain Controller)
#>

Import-Module ActiveDirectory

$ErrorActionPreference = "SilentlyContinue"

# Threshold for reporting in seconds
$DiffThreshold = 300

$ErrorMsg = ""

$Master = "dc1.domain.com"

$OutputTXT = "E:\PRTG\CompareServerTime-Result.txt"

# Getting all Windows Servers in the current domain
$ServerList = Get-ADComputer -Filter {OperatingSystem -Like "Windows *Server*"}  | Select -expandproperty dnshostname

foreach ($row in $ServerList)
{
 $time1 = ([WMI]'').ConvertToDateTime((gwmi win32_operatingsystem -computername $row).LocalDateTime)
 $time2 = ([WMI]'').ConvertToDateTime((gwmi win32_operatingsystem -computername $Master).LocalDateTime) 

 $timediff = New-TimeSpan $Time1 $Time2

 If ([System.Math]::Abs($timediff.TotalSeconds) -gt $DiffThreshold) 	{
	$ErrorMsg = $ErrorMsg + $row + " " + $timediff.TotalSeconds + " seconds" + " | "
					}
}


If ($ErrorMsg) {
$ErrorMsg | Out-File $OutputTXT
}