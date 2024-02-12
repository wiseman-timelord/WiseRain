# Global Variables
$Global:TempDriveLetter_8d2M = "R" # Temporary Drive Letter
$Global:TempDriveName_9r4K = "RamDrive" # Temporary Drive Name

# Function to get processor information
function Get-ProcessorInfo {
    $Processor_6x9L = Get-CimInstance Win32_Processor
    $CpuLoad_5t8U = ($Processor_6x9L | Measure-Object -Property LoadPercentage -Average).Average
    $CpuSpeed_7y4I = $Processor_6x9L.CurrentClockSpeed
    $Cores_3f8J = ($Processor_6x9L | Measure-Object -Property NumberOfCores -Sum).Sum
    $Threads_2g7K = ($Processor_6x9L | Measure-Object -Property NumberOfLogicalProcessors -Sum).Sum
    
    # Updated to reflect your formatting preferences
    $ProcessorInfo = @(
        "Cores - $Cores_3f8J, Threads - $Threads_2g7K",
        "Usage - $CpuLoad_5t8U%, Frq. - ${CpuSpeed_7y4I}MHz"
    ) -join "`n"
    
    return $ProcessorInfo
}

# Function Get MemoryInfo
function Get-MemoryInfo {
    $Memory_4p6L = Get-CimInstance -ClassName Win32_OperatingSystem
    $FreeMemory_3q8N = [math]::Round($Memory_4p6L.FreePhysicalMemory / 1MB, 1)
    $TotalMemory_7r5M = [math]::Round($Memory_4p6L.TotalVisibleMemorySize / 1MB, 1)
    $UsedMemory_5s9P = $TotalMemory_7r5M - $FreeMemory_3q8N
    return "Memory - $UsedMemory_5s9P GB / $TotalMemory_7r5M GB"
}

# Get info for TempDrive
function Get-TempOsDiskInfo {
    $OsRamDisk_2h8L = Get-PSDrive $Global:TempDriveLetter_8d2M | Select-Object Used, Free
    $UsedSpace_9k4L = [math]::Round($OsRamDisk_2h8L.Used / 1GB, 1)
    $FreeSpace_8j3M = [math]::Round($OsRamDisk_2h8L.Free / 1GB, 1)
    $TotalSpace_6i2N = $UsedSpace_9k4L + $FreeSpace_8j3M
    return "$Global:TempDriveName_9r4K - $UsedSpace_9k4L GB / $TotalSpace_6i2N GB"
}

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

# Update panel display
function Update {
    $ProcessorInfo = Get-ProcessorInfo
    $MemoryInfo = Get-MemoryInfo
    $TempOsDiskInfo = Get-TempOsDiskInfo
    $ProcessInfo = Get-ProcessInfo
    $Output = @(
        "====== System Panel =======",
        "`nProcessor Info:",
        $ProcessorInfo,
        "`nMemory Info:",
        $MemoryInfo,
        $TempOsDiskInfo,
        "`nLarge Processes:",
        $ProcessInfo
    ) -join "`n"
    return $Output
}

# Output final result
Update
