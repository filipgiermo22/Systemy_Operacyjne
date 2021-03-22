$pid = read-host "Podaj numer id procesu do zatrzymania"
stop-process -id  $pid
write-host "Proces '$pid' zatrzymany"