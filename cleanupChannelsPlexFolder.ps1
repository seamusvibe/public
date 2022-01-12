$RootFolder = "W:\"

$SRTFiles = Get-ChildItem -Path $RootFolder -File -Recurse -Include "*.srt"
$VideoFiles = Get-ChildItem -Path $RootFolder -File -Recurse -Include "*.mkv"

if(-not $SRTFiles)
{
    Write-Host "No SRT files."
}

if(-not $VideoFiles)
{
    Write-Host "No video files. Deleteing all SRT files."
    $SRTFiles | foreach { Remove-Item -Path $_.FullName }
}

:outer ForEach($SRTFile in $SRTFiles)
{
    if ($VideoFiles)  
    {
        $matched = $false
        :inner ForEach($VideoFile in $VideoFiles)
        {        
            if($SRTFile.BaseName -eq $VideoFile.BaseName)
            {
                Write-Host "Matched $($SRTFile.FullName), skipping"
                $matched = $true
                break inner
            }
        }
        if(-not $matched)
        {
            Write-Host "Removing $($SRTFile.FullName)" 
            Remove-Item -Path $SRTFile.FullName
        }
    }
}

while (Get-ChildItem $StartingPoint -Path $RootFolder -recurse | 
        where {!@(Get-ChildItem -force $_.fullname)} | 
        Test-Path) 
            {
                Get-ChildItem $StartingPoint -Path $RootFolder -recurse | 
                    where {!@(Get-ChildItem -force $_.fullname)} |
                    Remove-Item
            }
