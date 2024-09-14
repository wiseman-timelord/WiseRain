# Script: network_display.ps1

# Global Variables
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
    $DownloadsList_7t5Q = Get-ChildItem $Global:DownloadsFolderPath_3d9K | Sort-Object LastWriteTime -Descending | Select-Object -First 5
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
    $ConnectionInfo = Get-ConnectionInfo
    $DownloadsInfo = Get-DownloadsInfo
    $Output = @(
        "====== Network Panel ======",
        "Current Connections:-",
        $ConnectionInfo,
        "Recent Downloads:-",
        $DownloadsInfo
    ) -join "`n"

    return $Output
}

# Output the final result
Update
