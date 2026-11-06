#!/bin/sh

# Network Ping Checker
# Usage: ./ping-check.sh [all|home|factory|company]

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

show_help() {
    echo "Usage: $0 [option]"
    echo
    echo "Options:"
    echo "  all       Ping all home, factory and company devices"
    echo "  home      Ping home devices"
    echo "  factory   Ping factory devices"
    echo "  company   Ping company devices"
    echo
    echo "Examples:"
    echo "  $0 home"
    echo "  $0 factory"
    echo "  $0 company"
    echo "  $0 all"
}

ping_device() {
    name="$1"
    ip="$2"

    if ping -c 1 -W 1 "$ip" >/dev/null 2>&1; then
        printf "${GREEN}✓${NC} %-25s (%s)\n" "$name" "$ip"
    else
        printf "${RED}✗${NC} %-25s (%s)\n" "$name" "$ip"
    fi
}

check_home() {
    echo
    echo "=== HOME ==="

    ping_device "home-client"           "192.168.18.100"
    ping_device "home router (lan)"     "192.168.18.1"
    ping_device "home router (wan)"     "192.168.16.12"
}

check_factory() {
    echo
    echo "=== FACTORY ==="

    ping_device "factory router (lan)"  "192.168.17.1"
    ping_device "factory router (wan)"  "192.168.16.11"
    ping_device "hmi"                   "192.168.17.10"
    ping_device "openplc"               "192.168.17.11"
}

check_company() {
    echo
    echo "=== COMPANY ==="

    ping_device "companyrouter (dmz)"    "192.168.13.1"
    ping_device "www"                    "192.168.13.5"
    ping_device "companyrouter (cli)"    "192.168.14.1"
    ping_device "Winclient01"            "192.168.14.50"
    ping_device "companyrouter (lan)"     "192.168.15.1"
    ping_device "companyrouter (wan)"    "192.168.16.10"
    ping_device "DC01"                   "192.168.15.4"
    ping_device "Db-app-1"              "192.168.15.7"
    ping_device "App-2"                  "192.168.15.8"
}
# No arguments
if [ "$#" -eq 0 ]; then
    show_help
    exit 1
fi

case "$1" in
    all)
        check_home
        check_factory
        check_company
        ;;

    home)
        check_home
        ;;

    factory)
        check_factory
        ;;

    company)
        check_company
        ;;

    -h|--help|help)
        show_help
        ;;

    *)
        echo "Unknown option: $1"
        echo
        show_help
        exit 1
        ;;
esac