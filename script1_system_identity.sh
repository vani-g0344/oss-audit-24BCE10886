STUDENT_NAME="Vani Gupta"
REG_NO="24BCE10886"
SOFTWARE_CHOICE="Git"
SOFTWARE_LICENSE="GNU General Public License v2 (GPL v2)"

KERNEL=$(uname -r)
DISTRO=$(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"')
USER_NAME=$(whoami)
HOME_DIR=$HOME
UPTIME=$(uptime -p)
CURRENT_DATE=$(date '+%d %B %Y')
CURRENT_TIME=$(date '+%H:%M:%S')
HOSTNAME=$(hostname)
ARCH=$(uname -m)


if echo "$DISTRO" | grep -qi "ubuntu\|debian"; then
    OS_LICENSE="Debian/Ubuntu systems include GPL v2 licensed Linux kernel"
elif echo "$DISTRO" | grep -qi "fedora\|centos\|rhel\|red hat"; then
    OS_LICENSE="Red Hat/Fedora systems include GPL v2 licensed Linux kernel"
elif echo "$DISTRO" | grep -qi "arch"; then
    OS_LICENSE="Arch Linux includes GPL v2 licensed Linux kernel"
else
    OS_LICENSE="This Linux OS includes a GPL v2 licensed kernel (linux.org)"
fi


echo "          OPEN SOURCE SOFTWARE AUDIT — SYSTEM IDENTITY          "
echo ""
echo "  Student   : $STUDENT_NAME"
echo "  Reg No    : $REG_NO"
echo "  Software  : $SOFTWARE_CHOICE"
echo ""
echo "  SYSTEM INFORMATION"

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
echo "  Chosen Software  : $SOFTWARE_CHOICE"
echo "  Software License : $SOFTWARE_LICENSE"
echo "  OS License Note  : $OS_LICENSE"
echo ""
echo "  Git was created by Linus Torvalds in 2005 and is distributed"
echo "  under the GNU GPL v2 — the same license as the Linux kernel."
echo "  This means you are free to use, study, modify, and share it."
echo ""
echo "  System report generated on $CURRENT_DATE at $CURRENT_TIME"

