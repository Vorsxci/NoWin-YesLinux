# Requires Administrator Privileges
Write-Host "Starting Windows 11 Latency & Resource Optimization..." -ForegroundColor Cyan

# 1. Unlock High Performance & Ultimate Performance Power Schemes
Write-Host "Unlocking Performance Power Schemes..." -ForegroundColor Yellow
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c | Out-Null
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null

# Set active power plan to High Performance
$highPerfGuid = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
powercfg -setactive $highPerfGuid

# 2. Disable CPU Core Parking on Current Scheme
Write-Host "Disabling CPU Core Parking..." -ForegroundColor Yellow
# Sets minimum CPU state for both AC and Battery to 100% to prevent low-power latency spikes
powercfg -setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg -setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg -setactive SCHEME_CURRENT

# 3. Disable Non-Essential Telemetry & Diagnostic Services
Write-Host "Disabling Background Telemetry Services..." -ForegroundColor Yellow
$servicesToDisable = @(
    "DiagTrack",          # Connected User Experiences and Telemetry
    "dmwappushservice",   # Device Management Wireless Application Protocol Push
    "MapsBroker",         # Downloaded Maps Manager
    "remoteRegistry",     # Remote Registry
    "WSAIFabricSvc"       # Windows AI Fabric / Recall Service (if present)
)

foreach ($service in $servicesToDisable) {
    if (Get-Service -Name $service -ErrorAction SilentlyContinue) {
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
        Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Host "Disabled service: $service" -ForegroundColor Green
    }
}

# 4. Disable Windows Game Mode & Game Bar (Prevents dynamic background throttling)
Write-Host "Disabling Game Mode & Game Bar Throttling..." -ForegroundColor Yellow
Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 0 -ErrorAction SilentlyContinue
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -ErrorAction SilentlyContinue

Write-Host "`nOptimization complete! Please restart your computer for all changes to fully apply." -ForegroundColor Green