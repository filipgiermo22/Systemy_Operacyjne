<# 
by: Filip Giermek

goal: monitor curent weather in chosen city based on API: https://rapidapi.com/community/api/open-weather-map/details
      and send email update when temperature is greater than set by user.
AGH 2021
#>

#header
Write-Host "`n`t`t`<<<tWeather Update>>>"

#headers used to import data from API
$headers=@{}
$headers.Add("x-rapidapi-key", "3784852eafmsh7615657fb98368ep116d60jsn8662ba12ee1f")
$headers.Add("x-rapidapi-host", "community-open-weather-map.p.rapidapi.com")

#setting variables
Write-Host "`nSet the city name and country code e.g. Cracow,pol"
$city = Read-Host "city"
$code = Read-Host "country code"
$ext_temp = Read-Host 'Set the desired (minimal) temperature'
$To = Read-Host 'Set an e-mail on which you want to receive update'

#link to import data from API
$URL = 'https://community-open-weather-map.p.rapidapi.com/weather?q={0}%2C{1}&units=metric&mode=HTML' -f $city, $code

#credentials to email (sender)
$password = ConvertTo-SecureString 'weatherupdate1234' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ('weatherupdatefg@gmail.com', $password)

#import data from API
$response = Invoke-RestMethod -Uri $URL -Method 'GET' -Headers $headers

while(1)
{
    if($($response.main.temp) -ge $exp_temp)
    {
        #variables used to send email
        $MyEmail = "weatherupdatefg@gmail.com"
        $SMTP= "smtp.gmail.com"

        $Subject = '{0} Weather Update' -f $city
        $Body = " <b>Finally! Weather is better than ever.</b>

                  <p>Weather in $city </p>

                  <table>
                      <tr>
                         <td>temp:</td>
                         <td>$($response.main.temp) <sup> 0</sup>C</td>
                      </tr>
                      <tr>
                        <td>sensed temp:</td>
                        <td>$($response.main.feels_like) <sup> 0</sup>C</td>
                      </tr>
                      <tr>
                         <td>description: </td>
                         <td>$($response.weather.description)</td>
                      </tr>
                      <tr>
                         <td>pressure: </td>
                         <td>$($response.main.pressure) hPa</td>
                      </tr>
                      <tr>
                         <td>humidity: </td>
                         <td>$($response.main.humidity) %</td>
                      </tr>
                      <tr>
                         <td>clouds: </td>
                         <td>$($response.clouds.all) %</td>
                      </tr>
                      <tr>
                         <td>wind speed:</td>
                         <td>$($response.wind.speed) m/s</td>
                      </tr>
                  </table>

                  <p> Source: Open Weather Map from RapidAPI https://rapidapi.com/community/api/open-weather-map/details </p>"

        #sending email
        Send-MailMessage -To $To -From $MyEmail -Subject $Subject -Body $Body -SmtpServer $SMTP -Credential $credential -UseSsl -Port 587 -BodyAsHtml
    }
    sleep(60)
}