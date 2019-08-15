# Add the Refresh button to the Quick Access Toolbar
# The Refresh action will be assigned to ALT+4
# Execute this Powershell script (it will send a ALT+4 keystroke every 60 seconds):

While($true)
    { 
[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[System.Windows.Forms.SendKeys]::SendWait("%{4}")
Start-Sleep -s 60
    }

