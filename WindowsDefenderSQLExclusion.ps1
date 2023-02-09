# Windows Defender SQL Exclusion list

Invoke-Command -ComputerName SERVER1 -ScriptBlock { 
    Add-MpPreference -ExclusionExtension ".mdf"
    Add-MpPreference -ExclusionExtension ".ldf"
    Add-MpPreference -ExclusionExtension ".ndf"
    Add-MpPreference -ExclusionExtension ".bak"
    Add-MpPreference -ExclusionExtension ".trn"
    Add-MpPreference -ExclusionExtension ".xel" }