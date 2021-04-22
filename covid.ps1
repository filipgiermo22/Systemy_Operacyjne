<# 
by: Filip Giermek

goal: arrange in table up-to-date covid-19 statistics form API: https://cutt.ly/ncBQO47

AGH 2021
#>

#import data from API 
$summary = Invoke-RestMethod 'https://api.covid19api.com/summary' -Method 'GET' -Headers $headers

#variables used to get data from summary
$start = [datetime] $summary.Date
$end = Get-Date
$diff = NEW-TIMESPAN –Start $start –End $end
$days = $diff.Days
$hours = $diff.Hours
$minutes = $diff.Minutes

#header
Write-Host "`n`t`t`t`t<<<Table of current Covid-19 statistics>>>"

#table with data
$summary.Countries | Format-Table @{Name="Country";Expression = { $_.'Country'}; Alignment="Center" },  
                                  @{Name="Confirmed";Expression = { $_.'TotalConfirmed'}; Alignment="Center" },
                                  @{Name="Recovered";Expression = { $_.'TotalRecovered'}; Alignment="Center" },
                                  @{Name="Deaths";Expression = { $_.'TotalDeaths'}; Alignment="Center"},
                                  @{Name="   Time   ";Expression = { '{0}d {1}h {2}m' -f($days, $hours, $minutes)}}
              
                 