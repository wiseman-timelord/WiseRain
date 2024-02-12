# Global Variables for Monitor Panel
$DataFilePath_3v0 = ".\data.Psd1" # Path to the data file
$DefaultContent_7g2K = "@{
    LastInbound = 0
    LastOutbound = 0
}" # Default content for data file initialization

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
    $inRate = (($currentInbound - $data.LastInbound) * 8) / 1KB / 9
    $outRate = (($currentOutbound - $data.LastOutbound) * 8) / 1KB / 9
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

# Global Variables for Network Panel
$Global:DownloadsFolderPath_3d9K = "E:\Downloads" # Downloads Folder Path

# Function Get Connection Info
function Get-ConnectionInfo {
    try {
        $NetstatOutput_5x8L = netstat -ano | Where-Object { $_ -like "*ESTABLISHED*" }
        if (-not $NetstatOutput_5x8L) {
            throw "No netstat output"
        }
    } catch {
        Write-Host "Error fetching netstat data: $_"
        return "Unavailable Or Disconnected"
    }
    $ConnectionsHash_8y4P = @{}
    foreach ($Line in $NetstatOutput_5x8L) {
        $Parts = $Line -split '\s+'
        $IpPort = $Parts[2] -split ':'
        $Ip = $IpPort[0]
        if ($Ip -like "*:*") {
            $Ip = $IpPort[0..($IpPort.Length - 2)] -join ":"
        }
        $Direction = if ($Ip -eq "127.0.0.1" -or $Ip -eq "::1") { "IP In " } else { "IP Out" }
        $ConnectionString = "$Direction - $Ip"
        if ($ConnectionString.Length -gt 24) {
            $ConnectionString = $ConnectionString.Substring(0, 24)
        }
        $ConnectionKey = "$Direction,$Ip"
        if (-not $ConnectionsHash_8y4P.ContainsKey($ConnectionKey)) {
            $ConnectionsHash_8y4P[$ConnectionKey] = $ConnectionString
        }
    }
    return $ConnectionsHash_8y4P.Values -join "`n"
}

# Function Get Downloads Info
function Get-DownloadsInfo {
    $DownloadsList_7t5Q = Get-ChildItem $Global:DownloadsFolderPath_3d9K | Sort-Object LastWriteTime -Descending | Select-Object -First 3
    $DownloadInfo_2a4R = $DownloadsList_7t5Q | ForEach-Object {
        $FileName = $_.BaseName
        if ($FileName.Length -gt 24) {
            $FileName = $FileName.Substring(0, 24) + "..."
        }
        $FileName
    }
    return $DownloadInfo_2a4R -join "`n"
}

# Function Update: Constructing the final output
function Update {
    $networkStats = Get-NetworkStatistics
    $ConnectionInfo = Get-ConnectionInfo
    $DownloadsInfo = Get-DownloadsInfo
    $Output = @(
        "====== Network Panel ======",
        "`nTransfer Rates:",
        "Dnload - $($networkStats.InRate) KB/s",
        "Upload - $($networkStats.OutRate) KB/s",
        "`nCurrent Connections:",
        $ConnectionInfo,
        "`nRecent Downloads:",
        $DownloadsInfo
    ) -join "`n"

    return $Output
}

# Output the final result
Update
