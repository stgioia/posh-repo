
Start-BitsTransfer "https://download.microsoft.com/download/7/f/8/7f8a9c43-8c8a-4f7c-9f92-83c18d96b681/SQL2019-SSEI-Expr.exe" -Destination C:\Temp\
Start-BitsTransfer "https://download.microsoft.com/download/5/E/B/5EB40744-DC0A-47C0-8B0A-1830E74D3C23/ReportBuilder.msi" -Destination C:\Temp\

Write-Host "Downloading SQL Server Management Studio..."
$Path = "C:\Temp\"
$Installer = "SSMS-Setup-ENU.exe"
$URL = "https://aka.ms/ssmsfullsetup"
Invoke-WebRequest $URL -OutFile $Path\$Installer

Write-Host "Installing SQL Server Management Studio..."
Start-Process -FilePath $Path\$Installer -Args "/install /quiet" -Verb RunAs -Wait
Remove-Item $Path\$Installer

Start-BitsTransfer "https://aka.ms/ssmsfullsetup" -Destination C:\Temp\
