# Usefull commands

<!-- TOC -->

- [Usefull commands](#usefull-commands)
    - [Check your Machine or Secure Agent](#check-your-machine-or-secure-agent)
    - [Verify Health Check of the Server and access to IICS MDM API](#verify-health-check-of-the-server-and-access-to-iics-mdm-api)
    - [Check the Speed of the Internet connection](#check-the-speed-of-the-internet-connection)
        - [Windows - Powershell](#windows---powershell)
        - [Linux Ubuntu/Debian](#linux-ubuntudebian)
        - [One-liners for Admin Shell Guide](#one-liners-for-admin-shell-guide)
        - [Example Ookla Speedtest output](#example-ookla-speedtest-output)
    - [Inspect IICS Secure Agent logs via Admin Shell Guide](#inspect-iics-secure-agent-logs-via-admin-shell-guide)
        - [On Windows](#on-windows)
        - [On Linux](#on-linux)

<!-- /TOC -->

## Check your Machine or Secure Agent

```powersherll
powershell -command "Invoke-WebRequest -uri "https://checkip.amazonaws.com/""
```

```shell
curl http://ifconfig.me/ip
curl https://checkip.amazonaws.com/
```

## Verify Health Check of the Server and access to IICS MDM API

Use following url specific to your POD `https://<POD>-mdm.dmp-us.informaticacloud.com/healthz`

Example:

```shell
curl -H -k https://usw1-mdm.dmp-us.informaticacloud.com/healthz
```

## Check the Speed of the Internet connection

### Windows - Powershell

```Powershell
# Source URL
$url = "https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip"
# Destination file
$download_target = "$env:USERPROFILE\Downloads\ookla-speedtest-1.2.0-win64.zip"
# Tool Install Destination
$speedtest_target_location = "$env:USERPROFILE\tools\spedtest"

if (Test-Path $speedtest_target_location) {
   
    Write-Host "Folder Exists"
}
else
{
    #PowerShell Create target directory if not exists
    New-Item $speedtest_target_location -ItemType Directory
    Write-Host "Folder Created successfully"
}

# Download the file
try {
    $job = Start-Job -Name DownloadSpeedTest -ScriptBlock { 
            Invoke-WebRequest -Uri $url -OutFile $download_target 
            }
    Wait-Job -Name DownloadSpeedTest
    Receive-Job -Job $job
    Expand-Archive $download_target -DestinationPath $speedtest_target_location -Force
}
catch {
    Write-Host "Failed to Download File"
    Write-Host $_
}

Write-Host "Now you can Run $speedtest_target_location\speedtest.exe --accept-license -p -v"
```

### Linux Ubuntu/Debian

On ubuntu/Debian, the speedtest-cli is available in the system package manager

```shell
sudo apt install speedtest-cli
```

> On Mac you can use brew or Mac Ports

### One-liners for Admin Shell Guide

```cmd
REM Download Speed Test Client
powershell -command "Invoke-WebRequest -Uri https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-win64.zip -OutFile 
$env:USERPROFILE\Downloads\ookla-speedtest-1.2.0-win64.zip"
REM Verify Download
dir %USERPROFILE%\Downloads
REM Unzip Downloaded CLient
powershell -command "Expand-Archive $env:USERPROFILE\Downloads\ookla-speedtest-1.2.0-win64.zip -DestinationPath $env:USERPROFILE\Downloads -Force"
REM Verify Unzip
dir %USERPROFILE%\Downloads
REM Run Speed test
cmd -c "%USERPROFILE%\Downloads\speedtest.exe --accept-license -p -v"
```

### Example Ookla Speedtest output

```
PS C:\Users\jbrazda> C:\Users\jbrazda\tools\spedtest\speedtest.exe --accept-license -p -v

   Speedtest by Ookla

      Server: Starry, Inc. - Boston, MA (id: 13429)
         ISP: Verizon Fios
Idle Latency:     9.96 ms   (jitter: 0.31ms, low: 9.71ms, high: 10.19ms)
[warning] recvfrom failed: An invalid argument was supplied.

[warning] Loaded latency: cannot read response.: [10053] An established connection was aborted by the software in your host machine.

    Download:   110.75 Mbps (data used: 124.9 MB)
                 43.12 ms   (jitter: 3.94ms, low: 13.25ms, high: 64.38ms)
[warning] recvfrom failed: An invalid argument was supplied.

[warning] Loaded latency: cannot read response.: [10053] An established connection was aborted by the software in your host machine.

      Upload:   120.42 Mbps (data used: 147.7 MB)
                 23.31 ms   (jitter: 2.38ms, low: 13.53ms, high: 61.79ms)
[warning] No libz support available, not compressing data.
 Packet Loss:     0.0%
  Result URL: https://www.speedtest.net/result/c/7d56a03b-7413-4f52-96f3-6dfa20402dfc
  
```

## Inspect IICS Secure Agent logs via Admin Shell Guide

### On Windows

```cmd
REM Get last 100 lines of the current day Process Server log
powershell -command "Get-Content -Tail 100 $env:APP_DIR\logs\catalina.$(Get-Date -Format 'yyyy-mm-dd').log"
REM Get last 100 lines of the agentcore.log
powershell -command "Get-Content -Tail 100 $env:APP_DIR\..\agentcore\agentcore.log"
```

### On Linux

```shell
# Get last 100 lines of the current day Process Server log
tail -n 100 "$APP_DIR/logs/catalina.$(date '+%Y-%m-%d').log"
# Get last 100 lines of the yesterday's Process Server log
tail -n 100 "$APP_DIR/logs/catalina.$(date -d yesterday '+%Y-%m-%d').log"
# Get last 100 lines of the agentcore.log
tail -n 100 "$APP_DIR/logs/../agentcore/agentcore.log"
```
