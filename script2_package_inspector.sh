#!/bin/bash
# =============================================================
# Script 2: FOSS Package Inspector
# Author: Sparsh Agarwal | Roll: 24BSA10342
# Course: Open Source Software | VITyarthi
# Description: Checks if Python is installed, displays version
#              and license info, and prints a philosophy note
#              about the package using a case statement.
# =============================================================

# --- Define the package to inspect ---
PACKAGE="python3"   

echo "============================================================"
echo "         FOSS PACKAGE INSPECTOR — $PACKAGE                 "
echo "============================================================"
echo ""

# --- Check if the package is installed using if-then-else ---
if command -v dpkg &>/dev/null; then
    # Debian/Ubuntu-based: use dpkg to check
    if dpkg -l "$PACKAGE" &>/dev/null; then
        echo "  [✔] $PACKAGE is INSTALLED on this system."
        echo ""
        echo "  --- Package Details ---"
        dpkg -s "$PACKAGE" | grep -E 'Version|Status|Maintainer|Homepage'
    else
        echo "  [✘] $PACKAGE is NOT installed."
        echo "  To install, run: sudo apt install python3"
        exit 1
    fi

elif command -v rpm &>/dev/null; then
    # RPM-based (Fedora/CentOS/RHEL): use rpm -qi
    if rpm -q "$PACKAGE" &>/dev/null; then
        echo "  [✔] $PACKAGE is INSTALLED on this system."
        echo ""
        echo "  --- Package Details ---"
        rpm -qi "$PACKAGE" | grep -E 'Version|License|Summary|URL'
    else
        echo "  [✘] $PACKAGE is NOT installed."
        echo "  To install, run: sudo dnf install python3"
        exit 1
    fi

else
    # Fallback: check the python3 binary directly
    if command -v python3 &>/dev/null; then
        echo "  [✔] Python is INSTALLED (detected via binary)."
    else
        echo "  Python not found. Install it from python.org"
        exit 1
    fi
fi

echo ""
echo "  --- Installed Version ---"
python3 --version   

echo ""
echo "  --- Python Executable Location ---"
which python3       

echo ""
echo "  --- Open Source Philosophy Note ---"

case $PACKAGE in
    python3 | python)
        echo "  Python: Guido van Rossum started Python in 1989 as a"
        echo "  hobby project over Christmas. He believed programming"
        echo "  should be accessible and readable for everyone — and"
        echo "  the PSF license ensures it stays free forever."
        ;;
    git)
        echo "  Git: Born in 2005 when Linus could no longer use"
        echo "  BitKeeper. Built in 10 days — open source at its best."
        ;;
    httpd | apache2)
        echo "  Apache: The open web server that powers ~30% of sites."
        ;;
    vlc)
        echo "  VLC: Built by French students — plays anything, freely."
        ;;
    firefox)
        echo "  Firefox: A nonprofit browser defending the open web."
        ;;
    *)
        echo "  $PACKAGE: An open-source tool that the world depends on."
        ;;
esac

echo ""
echo "============================================================"
