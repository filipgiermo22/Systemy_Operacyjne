<# 
by: Filip Giermek

goal: find duplicated files in catalog by hash comparison in sql file

AGH 2021

IMPORTANT: Scipt uses PSSQLite PowerShell Module.
           Script will install and import this module.

    ---------------------------------------------------------------------------
#>

Write-Host "`n`t`t<<<Search for duplicated hashes>>>"

#set required info
$path = Read-Host "`nEnter path to catalog you want to search through"

#condition to create database
$i = Read-Host "Is it first time searching for hashes in this catalog? (1-yes, 0-no)"

#check if module is installed/imported
if (-not(Get-InstalledModule PSSQLite -ErrorAction silentlycontinue)) 
{
  Install-Module PSSQLite
  Import-Module PSSQLite
  Write-Host "`nModule PSSQLite is installed and imported.`n"

}
elseif (-not(Get-Module PSSQLite -ErrorAction silentlycontinue)) 
{
  Import-Module PSSQLite
  Write-Host "`nModule PSSQLite is imported.`n"
}
else 
{
  Write-Host "`nModule PSSQLite is already installed and imported.`n"
}

while ($i -eq 1)
{
    $db_path = Read-Host "Enter path where you want to locate the database e.g. C:\Users\XYZ\Desktop`nSet"

    $name = Read-Host "Enter the name for new database"

    $db_path += "\"+ $name + ".SQLite"

    #creating sqlite file
    if(-not(Test-Path -Path $db_path -PathType Leaf))
    {
        New-Item -Path $db_path -ItemType File
        Write-Host "`nNew database file has been created."

        #creating table in database
        $Query = "CREATE TABLE '$path' (Hash VARCHAR(255), Path VARCHAR(255))"
        Invoke-SqliteQuery -Query $Query -DataSource $db_path
    }
    else { Write-Host "`nFile already exists." }

    Write-Host "`nSearching for hashes..."

    #block of creating hash table for the first time
    $hashes = Get-ChildItem -path $path -Recurse -File |
              Get-FileHash | 
              Select-Object Hash, Path |
              Sort-Object -Property 'Path' |
              Out-DataTable

    #add hashes to table
    Invoke-SQLiteBulkCopy -DataTable $hashes -DataSource $db_path -Table $path
    
    $i = 3
}

#block of creating hash table only for new and edited files
while ($i -eq 0)
{
    $hashes = Get-ChildItem -Path $path -Recurse -File |
              Where-Object {$_.LastWriteTime -gt $recent_run_time} |
              Get-FileHash | 
              Select-Object Hash, Path |
              Sort-Object -Property 'Path' |
              Out-DataTable

    #not override database if nothing found (otherwise causes error)
    if($hashes.Row.Count -gt 0)
    {    
        #add hashes to table
        Invoke-SQLiteBulkCopy -DataTable $hashes -DataSource $db_path -Table $path
    }
    else 
    {
       #print if no new hashes found and exit script
       Write-Host "`nNew files or newly edited files not found." 
       sleep(5)
       exit
    }

    $i = 3 
}

#finding duplicated hashes
$Find_Duplicates = "SELECT Hash FROM '{0}' GROUP BY Hash HAVING COUNT(*)>1" -f $path
$duplicated_hash = Invoke-SqliteQuery -Query $Find_Duplicates -Database $db_path

#print duplicated hashes
Write-Host "`nDuplicated hashes:`n"
foreach($p in $duplicated_hash.Hash)
{
    Write-Host $p
}

#print paths to files of duplicated hash
Write-Host "`nPaths of duplicated files:`n"
foreach($a in $duplicated_hash.Hash)
{
    #finding paths to files
    $duplicated_paths = "SELECT Path FROM '{0}' WHERE Hash = '{1}'" -f $path, $a

    $duplicated_paths = Invoke-SqliteQuery -Query $duplicated_paths -Database $db_path

    foreach($p in $duplicated_paths.Path)
    {
        Write-Host "-" $p
    }
}

Write-Host "`nLists of duplicated hashes and paths to files have been printed.
            
If you want to:
- track duplicate hashes of new and edited files in this catalog
- check different catalog 

Run this script again."

#variable saving time of current run
$recent_run_time = Get-Date






	

