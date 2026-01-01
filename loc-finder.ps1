Add-Type -AssemblyName System.Device
$Watcher = New-Object System.Device.Location.GeoCoordinateWatcher
$Watcher.Start()

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
        $lat = $Location.Latitude.ToString().Replace(",", ".")
        $lng = $Location.Longitude.ToString().Replace(",", ".")
        
        $url = "https://gps-coordinates.org/my-location.php?lat=$lat&lng=$lng"
        
        Start-Process $url
        
        [PSCustomObject]@{
            Latitud   = $lat
            Longitud  = $lng
            Precision = "$($Location.HorizontalAccuracy) meter"
        } | Format-List
    }
}
$Watcher.Stop()

function print($text) {
    Write-Host $text
}
print("creator is fitzypopper")
