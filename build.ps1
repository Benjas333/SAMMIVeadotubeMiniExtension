$currentVersion = Get-Content -Path .\version.txt

$numbers = $currentVersion.Split(".")

$major = [int]$numbers[0]
$minor = [int]$numbers[1]
$patch = [int]$numbers[2]
$build = [int]$numbers[3]

$build++

$newVersion = "{0}.{1}.{2}.{3}" -f $major, $minor, $patch, $build

Set-Content -Path.\version.txt -Value $newVersion

$newFile = "builds\SAMMIVeadotubeMiniExtension.v$newVersion.sef"

if (Test-Path -Path $newFile) {
        Write-Host "The copied file $newFile already exists. Exiting the script."
        exit
}

Copy-Item -Path .\SAMMIVeadotubeMiniExtension.sef -Destination $newFile -Force

$exampleDeckJson = Get-Content -Path .\example_deck.json

(Get-Content -Path $newFile) | ForEach-Object {$_ -replace '{"exampleDeckData":"\$!ExampleDeckData!\$"}', $exampleDeckJson} | Set-Content -Path $newFile

(Get-Content -Path $newFile) | ForEach-Object {$_ -replace '\$!VERSIONNUMBER!\$', "v$newVersion"} | Set-Content -Path $newFile
