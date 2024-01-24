# Script: monitor.ps1

# Variables
$dataFilePath = ".\data.Psd1" # Path to the data file (leave as is)

# Import data file
$data = Import-PowerShellDataFile -Path $dataFilePath

# get network statistics
function Get-NetworkStatistics {
    $networkInterface = Get-NetAdapterStatistics | Select-Object -First 1
    $currentInbound = $networkInterface.ReceivedBytes
    $currentOutbound = $networkInterface.SentBytes
    $inRate = ($currentInbound - $data.LastInbound) / 1KB / 5
    $outRate = ($currentOutbound - $data.LastOutbound) / 1KB / 5
    $data.LastInbound = $currentInbound
    $data.LastOutbound = $currentOutbound
    $dataContent = @"
@{
    LastInbound = $($data.LastInbound)
    LastOutbound = $($data.LastOutbound)
}
"@
    Set-Content -Path $dataFilePath -Value $dataContent
    return @{
        InRate = [math]::Round($inRate, 1)
        OutRate = [math]::Round($outRate, 1)
    }
}

# Update Panel Display
function Update {
    $networkStats = Get-NetworkStatistics
    $output = @(
        "===== Monitoring Panel =====",
        "`nTransfer Rates:",
        "Total Inbound - $($networkStats.InRate) KB/s",
        "Total Outbound - $($networkStats.OutRate) KB/s"
    ) -join "`n"
    $output
}

# Output final result
Update
