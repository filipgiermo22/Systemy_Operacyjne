<# 
by: Filip Giermek

goal: monitor drives free space ratio with notifications

AGH 2021
#>

#header
Write-Host "`n`t`t`<<<Memory usage monitoring>>>"

#creating notification window
Add-Type -AssemblyName System.Windows.Forms 
$global:balloon = New-Object System.Windows.Forms.NotifyIcon
$path = (Get-Process -id $pid).Path
$balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path) 
$balloon.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::Warning 
$balloon.BalloonTipText = 'Drive ' + $id + ' is almost full'
$balloon.BalloonTipTitle = "Attention $Env:USERNAME" 
$balloon.Visible = $true 

#table of CPU usage
Get-CimInstance -Class CIM_LogicalDisk | Format-Table DeviceID, 
                                        @{Name="Size(GB)";Expression={"{0:N0}" -f($_.size/1gb)}; Alignment="Center"}, 
                                        @{Name="Free Space(GB)";Expression={"{0:N0}" -f($_.freespace/1gb)}; Alignment="Center"}, 
                                        @{Name="Free (%)";Expression={"{0:N0}" -f(100*($_.freespace/1gb) / ($_.size/1gb))}; Alignment="Center"}

#setting variables of drive usage
$id = Read-Host  "Which drive/partiction would you like to track?`nRemember to add <:> after ID"
$limit = Read-Host "Set min. free space on drive (%)"

#monitor of chosen drive
$drive = Get-CimInstance -Class CIM_LogicalDisk | where-object -Property DeviceID -eq $id

while(1)
{
    #counting free space
    try { $free = "{0:N0}" -f(100*($drive.freespace/1gb) / ($drive.size/1gb)) }
    catch 
    { 
        Write-Warning "`nThis drive doesn't exist."
        exit
    }

    if($free -lt $limit)
        {
            #notification trigger
            $balloon.ShowBalloonTip(10000)
        }
    sleep(60)
}

