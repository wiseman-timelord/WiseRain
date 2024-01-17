# Script: System.ps1

# Global Variables
$global:TempDriveLetter = "R" # Temp Drive Letter
$global:TempDriveName = "Ramdrive" # Temp Drive Name

# Function Get CPUInfo
function Get-CPUInfo {
    $cpuUsage = Get-Counter '\Processor(_Total)\% Processor Time' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue
    $cpuClockSpeed = Get-WmiObject Win32_Processor | Select-Object -ExpandProperty MaxClockSpeed
    $formattedCpuUsage = [math]::Round($cpuUsage, 0)
    return "$formattedCpuUsage% - ${cpuClockSpeed}MHz"
}

# Function Get Processinfo
function Get-ProcessInfo {
    $processes = Get-Process | Sort-Object WorkingSet64 -Descending | Select-Object -First 5
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

# Function Get MemoryInfo
function Get-MemoryInfo {
    $mem = Get-CimInstance -ClassName Win32_OperatingSystem
    $freeMemory = [math]::Round($mem.FreePhysicalMemory / 1MB, 1)
    $totalMemory = [math]::Round($mem.TotalVisibleMemorySize / 1MB, 1)
    $usedMemory = $totalMemory - $freeMemory
    return "Memory - $usedMemory GB / $totalMemory GB"
}

# Function Get Ramdiskinfo
function Get-TempDiskInfo {
    $ramDisk = Get-PSDrive $global:TempDriveLetter | Select-Object Used, Free
    $used = [math]::Round($ramDisk.Used / 1GB, 1)
    $free = [math]::Round($ramDisk.Free / 1GB, 1)
    $total = $used + $free
    return "$global:TempDriveName - $used GB / $total GB"
}

# Collecting output from each function
$processInfo = Get-ProcessInfo -join "`n"
$memoryInfo = Get-MemoryInfo
$ramDiskInfo = Get-TempDiskInfo

# Constructing the final output with explicit new line separation
function Update {
    $cpuInfo = Get-CPUInfo
    $processInfo = Get-ProcessInfo -join "`n"
    $memoryInfo = Get-MemoryInfo
    $tempDiskInfo = Get-TempDiskInfo

    $output = @(
        "             -= System Panel =-"
		"`nProcessor Info:"
		$cpuInfo,
        "`nLarge Processes:",
        $processInfo,
        "`nTemporary Spaces:",
        $memoryInfo,
        $tempDiskInfo
    ) -join "`n"

    # Output the final result
    $output
}


# Output the final result
Update