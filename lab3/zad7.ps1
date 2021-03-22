$parent = Start-Process cmd -Argument "/c notepad" -PassThru

$child = Get-Process | Where-Object {$_.Parent.Id -eq $parent.Id}

Sleep 3

Stop-Process -Id $parent.Id -PassThru