# Script: .\Monitor\monitor_hardware.ps1

# Global Variables
$data = @{
    LastInbound = 0
    LastOutbound = 0
    LastMemoryRead = 0
    LastMemoryWrite = 0
    LastDiskRead = 0
    LastDiskWrite = 0
}

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
    return @{
        InRate = [math]::Round($inRate, 1)
        OutRate = [math]::Round($outRate, 1)
    }
}

# Get memory statistics
function Get-MemoryStatistics {
    $memoryCounter = Get-Counter '\Memory\Pages/sec'
    $currentMemoryPages = $memoryCounter.CounterSamples[0].CookedValue
    $memoryReadRate = ($currentMemoryPages - $data.LastMemoryRead) / 5
    $memoryWriteRate = ($currentMemoryPages - $data.LastMemoryWrite) / 5
    $data.LastMemoryRead = $currentMemoryPages
    $data.LastMemoryWrite = $currentMemoryPages
    return @{
        ReadRate = [math]::Round($memoryReadRate, 1)
        WriteRate = [math]::Round($memoryWriteRate, 1)
    }
}

# Get disk statistics
function Get-DiskStatistics {
    $diskCounter = Get-Counter '\PhysicalDisk(_Total)\Disk Read Bytes/sec', '\PhysicalDisk(_Total)\Disk Write Bytes/sec'
    $currentDiskRead = $diskCounter.CounterSamples[0].CookedValue
    $currentDiskWrite = $diskCounter.CounterSamples[1].CookedValue
    $diskReadRate = ($currentDiskRead - $data.LastDiskRead) / 1KB / 5
    $diskWriteRate = ($currentDiskWrite - $data.LastDiskWrite) / 1KB / 5
    $data.LastDiskRead = $currentDiskRead
    $data.LastDiskWrite = $currentDiskWrite
    return @{
        ReadRate = [math]::Round($diskReadRate, 1)
        WriteRate = [math]::Round($diskWriteRate, 1)
    }
}

# Update Panel Display
function Update {
    $networkStats = Get-NetworkStatistics
    $memoryStats = Get-MemoryStatistics
    $diskStats = Get-DiskStatistics
    $output = @(
        "===== Hardware Monitor =====",
        "Network Transfer Rates:-",
        "Download - $($networkStats.InRate) KB/s",
        "Upload - $($networkStats.OutRate) KB/s",
        "Memory Access Rates:-",
        "Read - $($memoryStats.ReadRate) Pages/s",
        "Write - $($memoryStats.WriteRate) Pages/s",
        "Disk Transfer Rates:-",
        "Read - $($diskStats.ReadRate) KB/s",
        "Write - $($diskStats.WriteRate) KB/s"
    ) -join "`n"
    return $output
}

# Output final result
Update