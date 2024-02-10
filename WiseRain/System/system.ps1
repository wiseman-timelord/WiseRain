# Script: system.ps1

# Global Variables
$global:TempOsDriveLetter = "R" # Temp Drive Letter
$global:TempOsDriveName = "RamDrive" # Temp Drive Name

# Function to get processor information
function Get-ProcessorInfo {
    $processor = Get-CimInstance Win32_Processor
    $cpuLoad = ($processor | Measure-Object -Property LoadPercentage -Average).Average
    $cpuSpeed = $processor.CurrentClockSpeed
    $cores = ($processor | Measure-Object -Property NumberOfCores -Sum).Sum
    $threads = ($processor | Measure-Object -Property NumberOfLogicalProcessors -Sum).Sum
    if ($cores -and $threads) {
        return "C$cores/T$threads - $cpuLoad% - ${cpuSpeed}MHz"
    } elseif ($threads) {
        return "T$threads - $cpuLoad% - ${cpuSpeed}MHz"
    }
}

# Function Get MemoryInfo
function Get-MemoryInfo {
    $mem = Get-CimInstance -ClassName Win32_OperatingSystem
    $freeMemory = [math]::Round($mem.FreePhysicalMemory / 1MB, 1)
    $totalMemory = [math]::Round($mem.TotalVisibleMemorySize / 1MB, 1)
    $usedMemory = $totalMemory - $freeMemory
    return "Memory - $usedMemory GB / $totalMemory GB"
}

# Get info for TempDrive
function Get-TempOsDiskInfo {
    $OsRamDisk = Get-PSDrive $global:TempOsDriveLetter | Select-Object Used, Free
    $used = [math]::Round($OsRamDisk.Used / 1GB, 1)
    $free = [math]::Round($OsRamDisk.Free / 1GB, 1)
    $total = $used + $free
    return "$global:TempOsDriveName - $used GB / $total GB"
}

# Function Get Processinfo
function Get-ProcessInfo {
    $processes = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 3
    $processInfo = $processes | ForEach-Object {
        $processName = $_.ProcessName
        if ($processName.Length -gt 13) {
            $processName = $processName.Substring(0, 13) + "..."
        }
        $memoryUsage = '{0:N1}' -f ($_.WorkingSet64 / 1MB)
        "$processName - $memoryUsage MB"
    }
    return $processInfo -join "`n"
}

# update panel display
function Update {
    $processorInfo = Get-ProcessorInfo
    $memoryInfo = Get-MemoryInfo
    $tempOsDiskInfo = Get-TempOsDiskInfo
    $processInfo = Get-ProcessInfo -join "`n"
    $output = @(
        "====== System Panel =======",
		"`nProcessor Info:",
        $processorInfo,
        "`nMemory Info:",
        $memoryInfo,
        $tempOsDiskInfo,
        "`nLarge Processes:",
        $processInfo
    ) -join "`n"
    $output
}

# Output final result
Update
