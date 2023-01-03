
$script = {
    $UpdateSession = New-Object -ComObject Microsoft.Update.Session
    $UpdateSearcher = $UpdateSession.CreateupdateSearcher()
    $Updates = @($UpdateSearcher.Search("IsHidden=0 and IsInstalled=0").Updates)
    $Updates | Select-Object Title }
    
$files = Get-Content "c:\temp\serverlist.txt"
foreach ($f in $files){
invoke-command -ComputerName $f -ScriptBlock $script | Out-File 'c:\temp\result.txt' -Append
}
