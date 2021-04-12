<# 
by: Filip Giermek

goal: 1. monitor drives free space ratio with notifications
      2. monitor

AGH 2021
#>

$MessageboxTitle = "CPU tracking pwsh script”
$Messageboxbody = “Warning! CPU usage: ”
$MessageIcon = [System.Windows.MessageBoxImage]::Warning
$ButtonType = [System.Windows.MessageBoxButton]::Ok


Add-Type -AssemblyName System.Windows.Forms 
$global:balloon = New-Object System.Windows.Forms.NotifyIcon
$path = (Get-Process -id $pid).Path
$balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 
$balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning 
$balloon.BalloonTipText = 'Drive ' + $id + ' is almost full'
$balloon.BalloonTipTitle = "Attention $Env:USERNAME" 
$balloon.Visible = $true 

Get-CimInstance -Class CIM_LogicalDisk | Format-Table DeviceID, 
                                                      @{Name="Size(GB)";Expression={"{0:N0}" -f($_.size/1gb)}; Alignment="Center"}, 
                                                      @{Name="Free Space(GB)";Expression={"{0:N0}" -f($_.freespace/1gb)}; Alignment="Center"}, 
                                                      @{Name="Free (%)";Expression={"{0:N0}" -f(100*($_.freespace/1gb) / ($_.size/1gb))}; Alignment="Center"}

$id = Read-Host  "Which drive/partiction would you like to track?`nRemember to add <:> after ID"
$limit1 = Read-Host "Set max. usage of CPU"
$limit2 = Read-Host "Set min. free space on drive"

$drive = Get-CimInstance -Class CIM_LogicalDisk | where-object -Property DeviceID -eq $id

while(1)
{
    $cpu = (Get-WmiObject Win32_Processor).LoadPercentage

    if($cpu -gt $limit1)
    {
        [console]::beep(500,300), [console]::beep(800,300), [console]::beep(600,600)
        [System.Windows.MessageBox]::Show($Messageboxbody + $limit1 + "%",$MessageboxTitle,$ButtonType,$messageicon)
    }

    
    $free = "{0:N0}" -f(100*($drive.freespace/1gb) / ($drive.size/1gb))

    if($free -lt $limit2)
    {
        $balloon.ShowBalloonTip(10000)
    }
    sleep(60)
}