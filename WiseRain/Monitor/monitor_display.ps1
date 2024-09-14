# Script: .\Monitor\monitor_display.ps1

# Global Variables
$Drive_Letter = "C:"  # Drive letter used for disk operations
$data = @{
    LastInbound = 0
    LastOutbound = 0
    LastDiskRead = 0
    LastDiskWrite = 0
}

# Function to format values in KB/s, MB/s, GB/s
function Convert-Rate {
    param (
        [double]$value
    )
    if ($value -ge 1GB) {
        return "{0:N1} GB/s" -f ($value / 1GB)
    }
    elseif ($value -ge 1MB) {
        return "{0:N1} MB/s" -f ($value / 1MB)
    }
    elseif ($value -ge 1KB) {
        return "{0:N1} KB/s" -f ($value / 1KB)
    }
    else {
        return "{0:N1} B/s" -f $value
    }
}

# Get network statistics
function Get-NetworkStatistics {
    $networkInterface = Get-NetAdapterStatistics | Select-Object -First 1
    if ($networkInterface -eq $null) {
        return $null
    }
    $currentInbound = $networkInterface.ReceivedBytes
    $currentOutbound = $networkInterface.SentBytes

    $inRate = ($currentInbound - $data.LastInbound) / 5
    $outRate = ($currentOutbound - $data.LastOutbound) / 5

    # If rates are negative, handle as zero (assuming counter reset)
    if ($inRate -lt 0) { $inRate = 0 }
    if ($outRate -lt 0) { $outRate = 0 }

    $data.LastInbound = $currentInbound
    $data.LastOutbound = $currentOutbound

    return @{
        InRate = Convert-Rate $inRate
        OutRate = Convert-Rate $outRate
    }
}

# Get disk statistics
function Get-DiskStatistics {
    $diskCounter = Get-Counter '\PhysicalDisk(_Total)\Disk Read Bytes/sec', '\PhysicalDisk(_Total)\Disk Write Bytes/sec'
    $currentDiskRead = $diskCounter.CounterSamples[0].CookedValue
    $currentDiskWrite = $diskCounter.CounterSamples[1].CookedValue

    # Use direct read/write rates (per second counters)
    $diskReadRate = $currentDiskRead
    $diskWriteRate = $currentDiskWrite

    # If rates are negative, handle as zero (assuming counter reset)
    if ($diskReadRate -lt 0) { $diskReadRate = 0 }
    if ($diskWriteRate -lt 0) { $diskWriteRate = 0 }

    $data.LastDiskRead = $currentDiskRead
    $data.LastDiskWrite = $currentDiskWrite

    return @{
        ReadRate = Convert-Rate $diskReadRate
        WriteRate = Convert-Rate $diskWriteRate
    }
}

# Update Panel Display
function Update {
    $networkStats = Get-NetworkStatistics
    $diskStats = Get-DiskStatistics

    $output = @(
        "===== Monitor Display =====",
        "Network Transfer Rates:-",
        "Download - $($networkStats.InRate)",
        "Upload - $($networkStats.OutRate)",
        "Disk Transfer Rates:-",
        "Read - $($diskStats.ReadRate)",
        "Write - $($diskStats.WriteRate)"
    ) -join "`n"
    return $output
}

# Output final result
Update