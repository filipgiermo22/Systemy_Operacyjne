# moja sieć lokalna: 192.168.33
# wymaga parametru jakim jest adres IPv4 bez ostatniego oktetu

param($ip)
[array]$ips = @()

Write-Host("Sprawdzam kolejne adresy...")
for ($i = 1; $i -lt 12; $i++) {
  $ipToCheck = $ip + $i
  if ((Test-Connection -count 1 $ipToCheck).status -eq "Success") {
    $ips += $ipToCheck
    }
  Write-Host $i
}

Write-Host("Adresy aktywne:")
$ips