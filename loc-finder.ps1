Add-Type -AssemblyName System.Device

$Watcher = New-Object System.Device.Location.GeoCoordinateWatcher

$Watcher.Start()

Write-Host "Searching..." -ForegroundColor Cyan
while (($Watcher.Status -ne 'Ready') -and ($Watcher.Permission -ne 'Denied')) {
    Start-Sleep -Milliseconds 100
}

if ($Watcher.Permission -eq 'Denied') {
    Write-Warning "Access denied, check windows settings."
} else {
    $Location = $Watcher.Position.Location

    if ($Location.IsUnknown) {
        Write-Warning "Could not determine location."
    } else {
        [PSCustomObject]@{
            Latitud   = $Location.Latitude
            Longitud  = $Location.Longitude
            Precision = "$($Location.HorizontalAccuracy) meter"
            Tidstämpel = $Watcher.Position.Timestamp
        } | Format-List
    }
}

$Watcher.Stop()
