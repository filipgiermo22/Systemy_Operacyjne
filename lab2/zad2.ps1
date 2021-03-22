while($true) 
{
    get-date -format "HH:mm:ss" |
    
    out-file -filepath .\czas.txt -append -width 200

    get-content -path .\czas.txt -tail 1
    
    sleep 5
}


