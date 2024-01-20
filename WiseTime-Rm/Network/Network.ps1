# Variables
$global:DownloadsFolderPath = "E:\Downloads" # Downloads Folder Path
$dataFilePath = ".\Data.Psd1" # Path to the data file

# Import data file
$data = Import-PowerShellDataFile -Path $dataFilePath

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
        $direction = if ($ip -eq "127.0.0.1" -or $ip -eq "::1") { "Inbound " } else { "Outbound" }

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

# Function to get current network statistics
function Get-NetworkStatistics {
    $networkInterface = Get-NetAdapterStatistics | Select-Object -First 1
    $currentInbound = $networkInterface.ReceivedBytes
    $currentOutbound = $networkInterface.SentBytes

    # Calculate the difference in KB (Kilobytes)
    $inRate = ($currentInbound - $data.LastInbound) / 1KB / 15  # Assuming the script runs every 15 seconds
    $outRate = ($currentOutbound - $data.LastOutbound) / 1KB / 15

    # Update the data file with current statistics
    $data.LastInbound = $currentInbound
    $data.LastOutbound = $currentOutbound
    $dataContent = @"
@{
    LastInbound = $($data.LastInbound)
    LastOutbound = $($data.LastOutbound)
}
"@
    Set-Content -Path $dataFilePath -Value $dataContent

    return @{
        InRate = [math]::Round($inRate, 2)
        OutRate = [math]::Round($outRate, 2)
    }
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
$networkStats = Get-NetworkStatistics
$connectionInfo = Get-ConnectionInfo -join "`n"
$downloadsInfo = Get-DownloadsInfo -join "`n"

# Function Update: Constructing the final output
function Update {
    $networkStats = Get-NetworkStatistics
    $connectionInfo = Get-ConnectionInfo -join "`n"
    $downloadsInfo = Get-DownloadsInfo -join "`n"

    $output = @(
        "            -= Network Panel =-",
        "`nCurrent Connections:",
        $connectionInfo,
        "`nTransfer Rates:",
        "Inbound - $($networkStats.InRate) KB/s",
        "Outbound - $($networkStats.OutRate) KB/s",
        "`nRecent Downloads:",
        $downloadsInfo
    ) -join "`n"

    # Output the final result
    $output
}

# Output the final result
Update
