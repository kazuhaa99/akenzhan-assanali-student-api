#!/bin/bash
# System report for Akenzhan Assanali.
# Usage: ./Akenzhan_Assanali_system_report.sh [log_file]

STUDENT_NAME="Akenzhan Assanali"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="${1:-$SCRIPT_DIR/../logs/Akenzhan_Assanali_system_report.log}"

{
    echo "=================================================="
    echo " System report — $STUDENT_NAME"
    echo "=================================================="
    echo "Student:        $STUDENT_NAME"
    echo "Date and time:  $(date '+%Y-%m-%d %H:%M:%S %Z')"
    echo "Username:       $(whoami)"
    echo
    echo "--- Operating system and kernel ---"
    grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"'
    echo "Kernel: $(uname -r) ($(uname -m))"
    echo
    echo "--- CPU ---"
    lscpu | grep -E 'Model name|^CPU\(s\)|Architecture'
    echo
    echo "--- Memory ---"
    free -h
    echo
    echo "--- Disk usage ---"
    df -h
    echo
    echo "--- Available disk space on / ---"
    df -h --output=avail / | tail -1
    echo
} | tee -a "$LOG_FILE"
