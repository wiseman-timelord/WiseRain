# Script: system_display.ps1

# Global Variables
# REMOVED ramdrive variables

# Function to get processor information
function Get-ProcessorInfo {
    $Processor_6x9L = Get-CimInstance Win32_Processor
    $CpuLoad_5t8U = ($Processor_6x9L | Measure-Object -Property LoadPercentage -Average).Average
    $CpuSpeed_7y4I = $Processor_6x9L.CurrentClockSpeed
    $Cores_3f8J = ($Processor_6x9L | Measure-Object -Property NumberOfCores -Sum).Sum
    $Threads_2g7K = ($Processor_6x9L | Measure-Object -Property NumberOfLogicalProcessors -Sum).Sum
    
    # Create CPU usage bar
    $UsageBar = ("#" * [math]::Round($CpuLoad_5t8U / 10)) + (" " * (10 - [math]::Round($CpuLoad_5t8U / 10)))
    
    # Calculate percentage
    $CpuLoadPercentage = [math]::Round($CpuLoad_5t8U)
    
    if ($Cores_3f8J -and $Threads_2g7K) {
        return "C$Cores_3f8J/T$Threads_2g7K - ${CpuSpeed_7y4I}MHz`nUsage - $CpuLoadPercentage% - $UsageBar "
    } elseif ($Threads_2g7K) {
        return "T$Threads_2g7K - ${CpuSpeed_7y4I}MHz`nUsage - $CpuLoadPercentage% - $UsageBar"
    }
}

# Function Get MemoryInfo
function Get-MemoryInfo {
    $Memory_4p6L = Get-CimInstance -ClassName Win32_OperatingSystem
    $FreeMemory_3q8N = [math]::Round($Memory_4p6L.FreePhysicalMemory / 1MB, 1)
    $TotalMemory_7r5M = [math]::Round($Memory_4p6L.TotalVisibleMemorySize / 1MB, 1)
    $UsedMemory_5s9P = $TotalMemory_7r5M - $FreeMemory_3q8N
    return "Memory - $UsedMemory_5s9P GB / $TotalMemory_7r5M GB"
}

# REMOVED Get-TempDiskInfo function

# Function Get ProcessInfo
function Get-ProcessInfo {
    $Processes_7l3D = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 3
    $ProcessInfo_4m5N = $Processes_7l3D | ForEach-Object {
        $ProcessName_9y2F = $_.ProcessName
        if ($ProcessName_9y2F.Length -gt 13) {
            $ProcessName_9y2F = $ProcessName_9y2F.Substring(0, 13) + "..."
        }
        $MemoryUsage_1t4G = '{0:N1}' -f ($_.WorkingSet64 / 1MB)
        "$ProcessName_9y2F - $MemoryUsage_1t4G MB"
    }
    return $ProcessInfo_4m5N -join "`n"
}

# Get page file usage statistics
function Get-PageFileStatistics {
    $pageFileCounters = Get-Counter '\Paging File(_Total)\% Usage', '\Paging File(_Total)\% Usage Peak'
    $currentPageUsage = $pageFileCounters.CounterSamples[0].CookedValue
    $currentPageUsagePeak = $pageFileCounters.CounterSamples[1].CookedValue
    $pageFileInfo = Get-WmiObject -Class Win32_PageFileUsage
    $totalSize = ($pageFileInfo | Measure-Object -Property AllocatedBaseSize -Sum).Sum
    $currentUsage = [math]::Round(($currentPageUsage / 100) * $totalSize, 2)
    
    return "PageFile - $currentUsage MB / $totalSize MB"
}

# Update panel display
function Update {
    $ProcessorInfo = Get-ProcessorInfo
    $MemoryInfo = Get-MemoryInfo
    $ProcessInfo = Get-ProcessInfo
    $PageFileInfo = Get-PageFileStatistics
    $Output = @(
        "====== System Panel =======",
        "Processor Info:-",
        $ProcessorInfo,
        "Memory Info:-",
        $MemoryInfo,
        $PageFileInfo,
        "Large Processes:-",
        $ProcessInfo
    ) -join "`n"
    return $Output
}

# Output final result
Update