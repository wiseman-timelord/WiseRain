# Script: network.ps1

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
        return "Unavailable Or Disconnected"
    }

    $connections = @{}

    foreach ($line in $netstatOutput) {
        # Parse the IP address and port
        $parts = $line -split '\s+'
        $ipPort = $parts[2] -split ':'
        $ip = $ipPort[0]

        # Adjust for IPv6 addresses
        if ($ip -like "*:*") {
            $ip = $ipPort[0..($ipPort.Length - 2)] -join ":"
        }

        # Determine the direction of the connection
        $direction = if ($ip -eq "127.0.0.1" -or $ip -eq "::1") { "Inbound" } else { "Outbound" }
        $connectionString = "$direction - $ip"

        # Truncate to 24 characters
        if ($connectionString.Length -gt 24) {
            $connectionString = $connectionString.Substring(0, 24)
        }

        # Generate a unique key for each direction and IP
        $connectionKey = "$direction,$ip"

        # Record each unique connection direction and IP
        if (-not $connections.ContainsKey($connectionKey)) {
            $connections[$connectionKey] = $connectionString
        }
    }

    # Return the unique connections
    return $connections.Values -join "`n"
}

# Function Get Downloadsinfo
function Get-DownloadsInfo {
    $downloads = Get-ChildItem $global:DownloadsFolderPath | Sort-Object LastWriteTime -Descending | Select-Object -First 3
    $downloadInfo = $downloads | ForEach-Object {
        $fileName = $_.BaseName
        if ($fileName.Length -gt 24) {
            $fileName = $fileName.Substring(0, 24) + "..."
        }
        $fileName
    }
    return $downloadInfo -join "`n"
}

# Function Update: Constructing the final output
function Update {
    $connectionInfo = Get-ConnectionInfo
    $downloadsInfo = Get-DownloadsInfo

    $output = @(
        "====== Network Panel ======",
        "`nCurrent Connections:",
        $connectionInfo,
        "`nRecent Downloads:",
        $downloadsInfo
    ) -join "`n"

    $output
}

# Output the final result
Update
