Add-Type -Assembly "System.IO.Compression.FileSystem" ;

$today = ((Get-Date).ToString('yyyy-MM-dd'))
New-Item -ItemType Directory -Path "\\server\WinClusterArchiveLog\$today"

# Get
Get-Cluster | foreach {
get-clusterlog –destination \\server\WinClusterArchiveLog\$today

}

$today = ((Get-Date).ToString('yyyy-MM-dd'))
# Compress
$files = get-childitem  "\\server\WinClusterArchiveLog\$today\" -recurse
foreach ($file in $files)
{
$dirpath = "\\server\WinClusterArchiveLog\$today\"
$fullpath = "\\server\WinClusterArchiveLog\$today\" + $file
[System.IO.Compression.ZipFile]::CreateFromDirectory($dirpath, $fullpath + ".zip") ;
Remove-Item -Path $fullpath
}

# Delete old folders
get-childitem -recurse -directory "\\server\WinClusterArchiveLog\" | where { (get-date) - $_.lastwritetime -gt 120. } | remove-item -recurse

 