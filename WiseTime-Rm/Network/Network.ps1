# Script: Network.ps1

# Variables
$global:DownloadsFolderPath = "E:\Downloads" # Downloads Folder Path

# Function Get Connectioninfo
function Get-ConnectionInfo {
    try {
        $netstatOutput = netstat -ano | Where-Object { $_ -like "*ESTABLISHED*" }
        if (-not $netstatOutput) {
            throw "No netstat output"
        }
    } catch {
        Write-Host "Error fetching netstat data: $_"
        return "Unable to fetch connection data"
    }

    $connections = @{}

    foreach ($line in $netstatOutput) {
        # Parse the IP address and port
        $parts = $line -split '\s+'
        $ipPort = $parts[2] -split ':'
        $ip = $ipPort[0]

        # Determine the direction of the connection
        $direction = if ($ip -eq "127.0.0.1" -or $ip -eq "::1") { "In " } else { "Out" }

        # Generate a unique key for each direction and IP
        $connectionKey = "$direction,$ip"

        # Record each unique connection direction and IP
        if (-not $connections.ContainsKey($connectionKey)) {
            $connections[$connectionKey] = "$direction - $ip"
        }
    }

    # Return the unique connections
    return $connections.Values -join "`n"
}

# Function Get Downloadsinfo
function Get-DownloadsInfo {
    $downloads = Get-ChildItem $global:DownloadsFolderPath | Sort-Object LastWriteTime -Descending | Select-Object -First 5
    $downloadInfo = $downloads | ForEach-Object {
        $fileName = $_.BaseName
        if ($fileName.Length -gt 24) {
            $fileName = $fileName.Substring(0, 24) + "..."
        }
        $fileName
    }
    return $downloadInfo -join "`n"
}

# Collecting output from each function
$connectionInfo = Get-ConnectionInfo -join "`n"
$downloadsInfo = Get-DownloadsInfo -join "`n"

# Function Update: Constructing the final output with explicit new line separation
function Update {
    $connectionInfo = Get-ConnectionInfo -join "`n"
    $downloadsInfo = Get-DownloadsInfo -join "`n"

    $output = @(
        "            -= Network Panel =-"
        "`nCurrent Connections:",
        $connectionInfo,
        "`nRecent Downloads:",
        $downloadsInfo
    ) -join "`n"

    # Output the final result
    $output
}

# Output the final result
Update