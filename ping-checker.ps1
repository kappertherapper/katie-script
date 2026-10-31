# Network Ping Checker
# Usage: .\ping-check.ps1 [all|home|factory|company]

$CheckMark = [char]0x2713   # ✓
$CrossMark = [char]0x2717   # ✗

function Show-Help {
    Write-Host "Usage: .\ping-check.ps1 [option]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  all       Ping all home, factory and company devices"
    Write-Host "  home      Ping home devices"
    Write-Host "  factory   Ping factory devices"
    Write-Host "  company   Ping company devices"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\ping-check.ps1 home"
    Write-Host "  .\ping-check.ps1 factory"
    Write-Host "  .\ping-check.ps1 company"
    Write-Host "  .\ping-check.ps1 all"
}

function Test-Device {
    param (
        [string]$Name,
        [string]$IP
    )

    $result = Test-Connection -ComputerName $IP -Count 1 -Quiet -ErrorAction SilentlyContinue

    if ($result) {
        Write-Host "$CheckMark " -ForegroundColor Green -NoNewline
    }
    else {
        Write-Host "$CrossMark " -ForegroundColor Red -NoNewline
    }
    Write-Host ("{0,-25} ({1})" -f $Name, $IP)
}

function Test-Home {
    Write-Host ""
    Write-Host "=== HOME ==="

    Test-Device "home-client"          "192.168.18.100"
    Test-Device "home router (lan)"    "192.168.18.1"
    Test-Device "home router (wan)"    "192.168.16.12"
}

function Test-Factory {
    Write-Host ""
    Write-Host "=== FACTORY ==="

    Test-Device "factory router (lan)" "192.168.17.1"
    Test-Device "factory router (wan)" "192.168.16.11"
    Test-Device "hmi"                  "192.168.17.10"
    Test-Device "openplc"              "192.168.17.11"
}

function Test-Company {
    Write-Host ""
    Write-Host "=== COMPANY ==="

    Test-Device "companyrouter (lan)"  "192.168.15.1"
    Test-Device "companyrouter (wan)"  "192.168.16.10"
    Test-Device "DC01"                 "192.168.15.4"
    Test-Device "Winclient01"          "192.168.15.50"
    Test-Device "Www"                  "192.168.15.5"
    Test-Device "Db-app-1"             "192.168.15.7"
    Test-Device "App-2"                "192.168.15.8"
}

# No arguments
if ($args.Count -eq 0) {
    Show-Help
    exit 1
}

switch ($args[0].ToLower()) {
    "all"      { Test-Home; Test-Factory; Test-Company }
    "home"     { Test-Home }
    "factory"  { Test-Factory }
    "company"  { Test-Company }
    { $_ -in "help", "-h", "--help" } { Show-Help }
    default {
        Write-Host "Unknown option: $($args[0])" -ForegroundColor Red
        Write-Host ""
        Show-Help
        exit 1
    }
}