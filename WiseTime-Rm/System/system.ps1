# Script: System.ps1

# Global Variables
$global:TempOsDriveLetter = "R" # Temp Drive Letter
$global:TempOsDriveName = "RamDriveOs" # Temp Drive Name
$global:TempSlDriveLetter = "S" # Temp Drive Letter
$global:TempSlDriveName = "RamDriveSl" # Temp Drive Name

# Function to get processor information
function Get-ProcessorInfo {
    # Getting CPU load and speed
    $cpuLoad = Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average
    $cpuSpeed = Get-WmiObject Win32_Processor | Select-Object -ExpandProperty CurrentClockSpeed

    # Getting number of cores and threads
    $cores = (Get-WmiObject Win32_Processor | Measure-Object -Property NumberOfCores -Sum).Sum
    $threads = (Get-WmiObject Win32_Processor | Measure-Object -Property NumberOfLogicalProcessors -Sum).Sum

    # Format the output
    if ($cores -and $threads) {
        return "C$cores/T$threads - $($cpuLoad.Average)% - ${cpuSpeed}MHz"
    } elseif ($threads) {
        return "T$threads - $($cpuLoad.Average)% - ${cpuSpeed}MHz"
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

# Function Get Ramdiskinfo for TempOs
function Get-TempOsDiskInfo {
    $OsRamDisk = Get-PSDrive $global:TempOsDriveLetter | Select-Object Used, Free
    $used = [math]::Round($OsRamDisk.Used / 1GB, 1)
    $free = [math]::Round($OsRamDisk.Free / 1GB, 1)
    $total = $used + $free
    return "$global:TempOsDriveName - $used GB / $total GB"
}

# Function Get Ramdiskinfo for TempSl
function Get-TempSlDiskInfo {
    $SlRamDisk = Get-PSDrive $global:TempSlDriveLetter | Select-Object Used, Free
    $used = [math]::Round($SlRamDisk.Used / 1GB, 1)
    $free = [math]::Round($SlRamDisk.Free / 1GB, 1)
    $total = $used + $free
    return "$global:TempSlDriveName - $used GB / $total GB"
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

# Constructing the final output with explicit new line separation
function Update {
    $processorInfo = Get-ProcessorInfo
    $memoryInfo = Get-MemoryInfo
    $tempOsDiskInfo = Get-TempOsDiskInfo
    $tempSlDiskInfo = Get-TempSlDiskInfo
    $processInfo = Get-ProcessInfo -join "`n"


    $output = @(
        "====== System Panel =======",
		"`nProcessor Info:",
        $processorInfo,
        "`nMemory Info:",
        $memoryInfo,
        $tempOsDiskInfo,
        $tempSlDiskInfo,
        "`nLarge Processes:",
        $processInfo
    ) -join "`n"

    # Output the final result
    $output
}

# Output the final result
Update