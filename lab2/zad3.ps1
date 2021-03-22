while($true) 
{
    $process = get-process | sort cpu -descending | select name, cpu -first 1
    
    $time =  get-date -format "HH:mm:ss"

    $result = $time + " " + $process.Name + " " + $process.CPU
    
    $result | out-file -filepath .\CPU.txt -append -width 200
    
    get-content -path .\CPU.txt -tail 1
    
    sleep 5
}


