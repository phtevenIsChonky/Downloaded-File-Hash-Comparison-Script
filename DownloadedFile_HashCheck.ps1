Write-Host "    
This script grabs the SHA256, SHA1, or MD5 hash of the most recent file 
in the Downloads folder and compares it to the checksum input below.
"
$DownloadedFile = (Get-ChildItem $env:userprofile\Downloads\ | Sort-Object LastWriteTime | Select-Object -last 1 -Property Fullname).Fullname

$Checksum = Read-Host -Prompt "Please enter the known-good checksum from the download source"

Switch ($Checksum.Length){
    {$_ -eq 32}{$Hash = "MD5"}
    {$_ -eq 40}{$Hash = "SHA1"}
    {$_ -eq 64}{$Hash = "SHA256"}
    Default {throw Read-Host "
    Hash length does not match SHA256, SHA1 or MD5.  
    Press Enter to exit"}
    }

$DownloadedFileHash = (Get-FileHash -Path $DownloadedFile -Algorithm $Hash).Hash 

    if ($DownloadedFileHash -eq $Checksum) {
        Write-Host "
        Comparison Result: " -NoNewline
        Write-Host "The checksum and file hash match
        " -ForegroundColor Green
    }
    else {
        Write-Host "
        Comparison Result: " -NoNewline
        Write-Host "The checksum and file name DO NOT match
        " -ForegroundColor Red
    }
Write-Host "    File Path:   " $DownloadedFile
Write-Host "    File Hash:   " $DownloadedFileHash
Write-Host "    Checksum:    " $Checksum
Write-Host ""
Read-Host -Prompt "Press Enter to exit"