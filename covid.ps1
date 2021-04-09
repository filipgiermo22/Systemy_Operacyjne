<# 
by: Filip Giermek

goal: arrange in table up-to-date covid-19 statistics form API: https://cutt.ly/ncBQO47

AGH 2021
#>

$summary = Invoke-RestMethod 'https://api.covid19api.com/summary' -Method 'GET' -Headers $headers

Write-Host "`n`t`t`t`tTable of current Covid-19 statistics"

$summary.Countries | Format-Table @{Name="Country";Expression = { $_.'Country'}; Alignment="Center" },  
                                  @{Name="Confirmed";Expression = { $_.'TotalConfirmed'}; Alignment="Center" },
                                  @{Name="Recovered";Expression = { $_.'TotalRecovered'}; Alignment="Center" },
                                  @{Name="Deaths";Expression = { $_.'TotalDeaths'}; Alignment="Center" }
              
                 