
DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/usr/share" "/var/cache")

GIT_CONFIG_DIR="/etc/gitconfig"
GIT_SYSTEM_DIR="/usr/share/git-core"
GIT_BIN="/usr/bin/git"
echo "         DISK AND PERMISSION AUDITOR — OSS AUDIT TOOL          "
echo ""
echo "  Auditing system directories for permissions, owners, and size."
echo "  Understanding file ownership is critical to Linux security."
echo ""
echo "  FORMAT: [Directory] => [Permissions] [Owner] [Group] | [Size]"
echo ""
echo "  SECTION 1: SYSTEM DIRECTORY AUDIT"
echo ""


for DIR in "${DIRS[@]}"; do
    if [ -d "$DIR" ]; then

        PERMS=$(ls -ld "$DIR" | awk '{print $1}')
        OWNER=$(ls -ld "$DIR" | awk '{print $3}')
        GROUP=$(ls -ld "$DIR" | awk '{print $4}')
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)

        printf "  %-20s => Perms: %-12s Owner: %-10s Group: %-10s Size: %s\n" \
               "$DIR" "$PERMS" "$OWNER" "$GROUP" "$SIZE"
    else
        printf "  %-20s => [does not exist on this system]\n" "$DIR"
    fi
done

echo ""
echo "  SECTION 2: PERMISSION SECURITY ANALYSIS"
echo ""

echo "  Checking for world-writable directories (security concern)..."
echo ""
for DIR in "${DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        PERMS=$(ls -ld "$DIR" | awk '{print $1}')
        if [ "${PERMS:8:1}" = "w" ]; then
            echo "  [!] WARNING: $DIR is world-writable ($PERMS)"
        fi
    fi
done
echo "  World-writable check complete."

echo ""
echo "  SECTION 3: GIT CONFIGURATION DIRECTORY AUDIT"
echo ""

if [ -f "$GIT_BIN" ]; then
    GIT_BIN_PERMS=$(ls -l "$GIT_BIN" | awk '{print $1, $3, $4}')
    GIT_VERSION=$(git --version 2>/dev/null)
    echo "  Git Binary     : $GIT_BIN"
    echo "  Permissions    : $GIT_BIN_PERMS"
    echo "  Version        : $GIT_VERSION"
else
    echo "  Git binary not found at $GIT_BIN"
    echo "  Git may not be installed. Run: sudo apt install git"
fi

echo ""

if [ -f "$GIT_CONFIG_DIR" ]; then
    GIT_CONF_PERMS=$(ls -l "$GIT_CONFIG_DIR" | awk '{print $1, $3, $4}')
    echo "  Git System Config: $GIT_CONFIG_DIR"
    echo "  Permissions      : $GIT_CONF_PERMS"
    echo "  Contents:"
    cat "$GIT_CONFIG_DIR" | sed 's/^/    /'
else
    echo "  System-wide Git config ($GIT_CONFIG_DIR) not found."
    echo "  This is normal if Git has not been configured system-wide."
fi

echo ""

if [ -d "$GIT_SYSTEM_DIR" ]; then
    GIT_DIR_PERMS=$(ls -ld "$GIT_SYSTEM_DIR" | awk '{print $1, $3, $4}')
    GIT_DIR_SIZE=$(du -sh "$GIT_SYSTEM_DIR" 2>/dev/null | cut -f1)
    echo "  Git Shared Dir : $GIT_SYSTEM_DIR"
    echo "  Permissions    : $GIT_DIR_PERMS"
    echo "  Size           : $GIT_DIR_SIZE"
else
    echo "  Git shared directory ($GIT_SYSTEM_DIR) not found."
fi

echo ""
echo "  Audit complete. Review permissions to ensure system security."
