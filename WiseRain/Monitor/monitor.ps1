# Global Variables
$DataFilePath_3v0 = ".\data.Psd1" # Path to the data file
$DefaultContent_7g2K = "@{
    LastInbound = 0
    LastOutbound = 0
}" # Default content for the data file initialization

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
    Set-Content -Path $Global:DataFilePath_3v0 -Value $Global:DefaultContent_7g2K
}

if (-not (Test-DataFile -Path $DataFilePath_3v0)) {
    Initialize-DataFile
}

# Import data file
$data = Import-PowerShellDataFile -Path $DataFilePath_3v0

# Get network statistics
function Get-NetworkStatistics {
    $networkInterface = Get-NetAdapterStatistics | Select-Object -First 1
    if ($networkInterface -eq $null) {
        return $null
    }

    $currentInbound = $networkInterface.ReceivedBytes
    $currentOutbound = $networkInterface.SentBytes
    $inRate = (($currentInbound - $data.LastInbound) * 8) / 1KB / 5
    $outRate = (($currentOutbound - $data.LastOutbound) * 8) / 1KB / 5
    $data.LastInbound = $currentInbound
    $data.LastOutbound = $currentOutbound

    $TempFilePath_9x2L = "$DataFilePath_3v0.tmp"
    $DataContent_5t4M = "@{
LastInbound = $($data.LastInbound)
LastOutbound = $($data.LastOutbound)
}"
    Set-Content -Path $TempFilePath_9x2L -Value $DataContent_5t4M -Force
    Rename-Item -Path $TempFilePath_9x2L -NewName $DataFilePath_3v0 -Force

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
            "Download - $($networkStats.InRate) KB/s",
            "Upload - $($networkStats.OutRate) KB/s"
        ) -join "`n"
        return $output
    } else {
        return "Unable to update network statistics."
    }
}

# Output final result
Update
