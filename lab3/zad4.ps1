# moje lokalne ip: 192.168.33.11
# wymaga parametru jakim jest adres IP, który chcemu sprawdzić

$ip = 192.168.0.103

param($ip)
if ((Test-Connection -count 1 $ip).status -eq "Success") {
    Write-Host("Adres $($ip) jest aktywny")
}
else {
    Write-Host("Adres $($ip) jest nieaktywny")
}