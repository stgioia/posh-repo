$Logfile = "Z:\Backup\MaintenanceLog\SSRSBackup$(get-date -f yyyyMMddmmss).log"
$InstanceName="SSRS"
$Password="xxxxxxxxxxxxxxxxxx"
$BackupLocation="Z:\Backup\SSRS\binaries" 
$SourceSSRS = "I:\Program Files\Microsoft SQL Server\MSRS13.SSRS\Reporting Services\ReportServer"
$Rsreportserver = "${SourceSSRS}\rsreportserver.config" 
$Rssvrpolicy = "${SourceSSRS}\rssrvpolicy.config" 
$ReportingServicesService = "${SourceSSRS}\bin\ReportingServicesService.exe.config" 
$Webconfig = "${SourceSSRS}\web.config" 
$KeyFile="${BackupLocation}\KEY_$InstanceName.snk" 

Start-Transcript -Path $Logfile

# Encryption key backup
Out-String -InputObject( echo "Y" | RSKeyMgmt.exe -e -f"$KeyFile" -p"$Password" -i"$InstanceName")  

# Important .config files
Copy-Item -Path $Rsreportserver -Destination $BackupLocation -Force
Copy-Item -Path $Rssvrpolicy -Destination $BackupLocation -Force
Copy-Item -Path $ReportingServicesService -Destination $BackupLocation -Force
Copy-Item -Path $Webconfig -Destination $BackupLocation -Force

Stop-Transcript