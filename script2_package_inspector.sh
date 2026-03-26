PACKAGE="git"


echo "           FOSS PACKAGE INSPECTOR — OSS AUDIT TOOL              "
echo ""


if command -v rpm &>/dev/null; then
    PKG_MANAGER="rpm"
elif command -v dpkg &>/dev/null; then
    PKG_MANAGER="dpkg"
else
    PKG_MANAGER="unknown"
    echo "Warning: Could not detect package manager (rpm or dpkg)."
fi

echo "  Package Manager Detected : $PKG_MANAGER"
echo "  Package Being Inspected  : $PACKAGE"
echo ""
print_divider

if [ "$PKG_MANAGER" = "rpm" ] && rpm -q "$PACKAGE" &>/dev/null; then
    echo "  STATUS: $PACKAGE is INSTALLED on this system."
    echo ""
    echo "  Package Details:"
    print_divider
    rpm -qi "$PACKAGE" | grep -E "^Version|^License|^Summary|^URL"

elif [ "$PKG_MANAGER" = "dpkg" ] && dpkg -l "$PACKAGE" 2>/dev/null | grep -q "^ii"; then
    echo "  STATUS: $PACKAGE is INSTALLED on this system."
    echo ""
    echo "  Package Details:"
    print_divider
    dpkg -l "$PACKAGE" | awk 'NR>4 {print "  Version : "$3}'
    dpkg-query -W -f='  Architecture : ${Architecture}\n  Description  : ${binary:Summary}\n' "$PACKAGE" 2>/dev/null

else
    echo "  STATUS: $PACKAGE is NOT installed on this system."
    echo ""
    echo "  To install Git, run one of the following commands:"
    echo "    Fedora/RHEL : sudo dnf install git"
    echo "    Ubuntu/Debian: sudo apt install git"
    echo "    Arch Linux  : sudo pacman -S git"
fi

echo ""
print_divider
echo "  OPEN SOURCE PHILOSOPHY — PACKAGE NOTES"
print_divider
echo ""


case "$PACKAGE" in
    git)
        echo "  Git: Born from frustration with proprietary version control."
        echo "  Linus Torvalds built Git in 2005 after BitKeeper revoked"
        echo "  free access to the Linux kernel team. Git embodies the open"
        echo "  source ideal — a tool so good that it became universal, and"
        echo "  it remains free for everyone, forever, under GPL v2."
        ;;
    httpd|apache2)
        echo "  Apache: The web server that built the open internet."
        echo "  Released under the permissive Apache 2.0 license, it powers"
        echo "  roughly 30% of all websites and has done so since 1995."
        ;;
    mysql|mysql-server)
        echo "  MySQL: Open source at the heart of millions of web apps."
        echo "  Its dual GPL/commercial license tells a unique story about"
        echo "  how companies can build businesses around open source code."
        ;;
    vlc|vlc-nox)
        echo "  VLC: Built by students at a Paris university who just wanted"
        echo "  to stream video on their campus network. Now it plays every"
        echo "  format known to humanity — freely, under LGPL/GPL."
        ;;
    firefox|firefox-esr)
        echo "  Firefox: A nonprofit browser fighting for an open web."
        echo "  Mozilla releases Firefox under MPL 2.0, proving that a"
        echo "  community-driven project can compete with corporate browsers."
        ;;
    python3|python)
        echo "  Python: Shaped entirely by community consensus under PSF License."
        echo "  It's the closest thing software has to a true gift to humanity —"
        echo "  free to use, teach, modify, and redistribute without restriction."
        ;;
    *)
        echo "  $PACKAGE: A free and open source tool distributed to the"
        echo "  community. Check its LICENSE file to understand your freedoms."
        ;;
esac

echo ""
echo "  Inspection complete. Knowledge is open source too."
