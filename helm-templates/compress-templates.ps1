Remove-Item ".\templates\*.*"

$exclude = ("templates",".git", "shared");
$Directory = Get-ChildItem -Directory -Exclude $exclude
$current = Get-Location
$release = Join-Path -Path $current -ChildPath "release"

Write-Host "Creating output directory $release.."
New-Item -Path $release -ItemType Directory

foreach ( $d in $Directory) {
    $name = $($d.Name)
    Write-Host "Copying files from $name to directory release\$name..."
    New-Item -Path "$release\$name" -ItemType Directory
    Copy-Item -Path "$($d.FullName)\*" -Destination "$release\$name" -Recurse 
    Write-Host "Copying shared files to directory $release\$name..."
    Copy-Item -Path (Join-Path -Path $current -ChildPath "shared\*") -Destination (Join-Path -Path $release -ChildPath $name) -Recurse -Force
}

foreach ( $d in (Get-ChildItem -Directory -Path $release)) {
    $name = $($d.Name)
    Write-Host "Compressing directory $name..."
    Compress-Archive -Path "$($d.FullName)\*" -DestinationPath ".\templates\$name.zip" -Update
    Write-Host "file .\templates\$name.zip created."
}