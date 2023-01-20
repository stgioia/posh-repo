
Start-BitsTransfer "https://download.microsoft.com/download/7/f/8/7f8a9c43-8c8a-4f7c-9f92-83c18d96b681/SQL2019-SSEI-Expr.exe" -Destination C:\Temp\


Write-Host "Downloading SQL Server Management Studio..."
$Path = "C:\Temp\"
$Installer = "SSMS-Setup-ENU.exe"
$URL = "https://aka.ms/ssmsfullsetup"
Invoke-WebRequest $URL -OutFile $Path\$Installer

Write-Host "Installing SQL Server Management Studio..."
Start-Process -FilePath $Path\$Installer -Args "/install /quiet" -Verb RunAs -Wait
Remove-Item $Path\$Installer