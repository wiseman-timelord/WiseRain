# Variables
$dataFilePath = ".\data.Psd1" # Path to the data file

# Check and Initialize Data File if Necessary
function Test-DataFile {
    param (
        [string]$Path
    )
    try {
        $data = Import-PowerShellDataFile -Path $Path
        if (-not $data) { throw "Data file is empty or corrupted." }
        return $true
    } catch {
        return $false
    }
}

function Initialize-DataFile {
    $defaultContent = "@{
    LastInbound = 0
    LastOutbound = 0
}"
    Set-Content -Path $dataFilePath -Value $defaultContent
}

if (-not (Test-DataFile -Path $dataFilePath)) {
    Initialize-DataFile
}

# Import data file
$data = Import-PowerShellDataFile -Path $dataFilePath

# Get network statistics
function Get-NetworkStatistics {
    $networkInterface = Get-NetAdapterStatistics | Select-Object -First 1
    if ($networkInterface -eq $null) {
        return $null
    }

    $currentInbound = $networkInterface.ReceivedBytes
    $currentOutbound = $networkInterface.SentBytes
    # Calculate rates in kilobits per second (kbps) instead of kilobytes per second (KB/s)
    $inRate = (($currentInbound - $data.LastInbound) * 8) / 1KB / 5
    $outRate = (($currentOutbound - $data.LastOutbound) * 8) / 1KB / 5
    $data.LastInbound = $currentInbound
    $data.LastOutbound = $currentOutbound

    $tempFilePath = "$dataFilePath.tmp"
    $dataContent = "@{
LastInbound = $($data.LastInbound)
LastOutbound = $($data.LastOutbound)
}"
    Set-Content -Path $tempFilePath -Value $dataContent -Force
    Rename-Item -Path $tempFilePath -NewName $dataFilePath -Force

    return @{
        InRate = [math]::Round($inRate, 1)
        OutRate = [math]::Round($outRate, 1)
    }
}

# Update Panel Display
function Update {
    $networkStats = Get-NetworkStatistics
    if ($networkStats -ne $null) {
        $output = @(
            "===== Monitoring Panel =====",
            "`nTransfer Rates:",
            "Total Inbound - $($networkStats.InRate) KB/s",
            "Total Outbound - $($networkStats.OutRate) KB/s"
        ) -join "`n"
        return $output
    } else {
        return "Unable to update network statistics."
    }
}

# Output final result
Update
