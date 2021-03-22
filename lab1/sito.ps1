$num = Read-Host
Write-Host $num

$arr =@($true) * $num

write-host("array values: ")

for($i = 2; $i -lt $num;$i++)
{
    for ($j = $i + $i; $j -lt $num; $j = $j + $j)
    {
    $arr[$j] = @($false);
    }
}

for ($i =2; $i -lt $num; $i++)
{
    if ($arr[$i] -eq $true)
    {
    write-host($i)
    }
}