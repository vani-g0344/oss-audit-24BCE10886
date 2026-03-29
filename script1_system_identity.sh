#!/bin/bash
# =============================================================================
# Script 1: System Identity Reporter
# Author  : Vani Gupta | 24BCE10886
# Purpose : Displays system hardware/OS information along with open-source
#           license details for the chosen software (Git).
# Concepts: Variables, command substitution, conditional statements (if/elif),
#           string matching with grep -qi, and formatted output with echo.
# =============================================================================

# --- Static student and software metadata ---
STUDENT_NAME="Vani Gupta"
REG_NO="24BCE10886"
SOFTWARE_CHOICE="Git"
SOFTWARE_LICENSE="GNU General Public License v2 (GPL v2)"

# --- Dynamic system information gathered via command substitution ---
# uname -r  : prints the running kernel release version
KERNEL=$(uname -r)

# /etc/os-release is a standard file on all modern Linux distros;
# grep + cut + tr are used to extract the human-readable distro name
DISTRO=$(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')

# whoami    : prints the effective username of the current shell session
USER_NAME=$(whoami)

# $HOME     : built-in shell variable that holds the home directory path
HOME_DIR=$HOME

# uptime -p : prints uptime in a human-readable "up X hours, Y minutes" form
UPTIME=$(uptime -p)

# date      : formats the current timestamp into separate date and time strings
CURRENT_DATE=$(date '+%d %B %Y')
CURRENT_TIME=$(date '+%H:%M:%S')

# hostname  : prints the machine's network hostname
HOSTNAME=$(hostname)

# uname -m  : prints the CPU architecture (e.g., x86_64, aarch64)
ARCH=$(uname -m)

# --- Conditional block: detect distro family and set appropriate license note ---
# grep -qi performs a case-insensitive (-i) quiet (-q) search; returns 0 if matched
if echo "$DISTRO" | grep -qi "ubuntu\|debian"; then
    OS_LICENSE="Debian/Ubuntu systems include GPL v2 licensed Linux kernel"
elif echo "$DISTRO" | grep -qi "fedora\|centos\|rhel\|red hat"; then
    OS_LICENSE="Red Hat/Fedora systems include GPL v2 licensed Linux kernel"
elif echo "$DISTRO" | grep -qi "arch"; then
    OS_LICENSE="Arch Linux includes GPL v2 licensed Linux kernel"
else
    # Fallback for any other Linux distribution
    OS_LICENSE="This Linux OS includes a GPL v2 licensed kernel (linux.org)"
fi

# --- Output Section: formatted system identity report ---
echo "================================================================"
echo "         OPEN SOURCE SOFTWARE AUDIT — SYSTEM IDENTITY           "
echo "================================================================"
echo ""
echo "  Student   : $STUDENT_NAME"
echo "  Reg No    : $REG_NO"
echo "  Software  : $SOFTWARE_CHOICE"
echo ""
echo "  SYSTEM INFORMATION"
echo "  ----------------------------------------------------------------"
echo "  Hostname         : $HOSTNAME"
echo "  Distribution     : $DISTRO"
echo "  Kernel Version   : $KERNEL"
echo "  Architecture     : $ARCH"
echo "  Logged-in User   : $USER_NAME"
echo "  Home Directory   : $HOME_DIR"
echo "  System Uptime    : $UPTIME"
echo "  Current Date     : $CURRENT_DATE"
echo "  Current Time     : $CURRENT_TIME"
echo ""
echo "  OPEN SOURCE LICENSE INFO"
echo "  ----------------------------------------------------------------"
echo "  Chosen Software  : $SOFTWARE_CHOICE"
echo "  Software License : $SOFTWARE_LICENSE"
echo "  OS License Note  : $OS_LICENSE"
echo ""
echo "  Git was created by Linus Torvalds in 2005 and is distributed"
echo "  under the GNU GPL v2 — the same license as the Linux kernel."
echo "  This means you are free to use, study, modify, and share it."
echo ""
echo "  System report generated on $CURRENT_DATE at $CURRENT_TIME"
echo "================================================================"
