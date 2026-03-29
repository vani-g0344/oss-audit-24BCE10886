#!/bin/bash
# =============================================================================
# Script 3: Disk and Permission Auditor
# Author  : Vani Gupta | 24BCE10886
# =============================================================================

# --- Array of important system directories to audit ---
# Arrays in bash use parentheses; elements are space-separated strings.
DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/usr/share" "/var/cache")

# --- Git-specific paths to inspect in Section 3 ---
GIT_CONFIG_DIR="/etc/gitconfig"      # System-wide Git configuration file
GIT_SYSTEM_DIR="/usr/share/git-core" # Git's shared template/hook directory
GIT_BIN="/usr/bin/git"               # Git executable binary path

echo "================================================================"
echo "         DISK AND PERMISSION AUDITOR — OSS AUDIT TOOL          "
echo "================================================================"
echo ""
echo "  Auditing system directories for permissions, owners, and size."
echo "  Understanding file ownership is critical to Linux security."
echo ""
echo "  FORMAT: [Directory] => [Permissions] [Owner] [Group] | [Size]"
echo ""

# =============================================================================
# SECTION 1: System Directory Audit
# Loop through each directory in the DIRS array.
# =============================================================================
echo "  SECTION 1: SYSTEM DIRECTORY AUDIT"
echo "  ----------------------------------------------------------------"

for DIR in "${DIRS[@]}"; do
    # [ -d "$DIR" ] checks if the path exists and is a directory
    if [ -d "$DIR" ]; then

        # ls -ld lists the directory itself (not its contents)
        # awk '{print $N}' extracts the Nth whitespace-delimited field:
        #   $1 = permissions string, $3 = owner user, $4 = owner group
        PERMS=$(ls -ld "$DIR" | awk '{print $1}')
        OWNER=$(ls -ld "$DIR" | awk '{print $3}')
        GROUP=$(ls -ld "$DIR" | awk '{print $4}')

        # du -sh gives a human-readable summary size; cut -f1 takes the size only
        # 2>/dev/null suppresses "Permission denied" errors for restricted dirs
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)

        # printf with %-Ns left-pads fields to N characters for aligned columns
        printf "  %-20s => Perms: %-12s Owner: %-10s Group: %-10s Size: %s\n" \
               "$DIR" "$PERMS" "$OWNER" "$GROUP" "$SIZE"
    else
        printf "  %-20s => [does not exist on this system]\n" "$DIR"
    fi
done

# =============================================================================
# SECTION 2: Permission Security Analysis
# Check each directory for world-writable bit — a potential security risk.
# =============================================================================
echo ""
echo "  SECTION 2: PERMISSION SECURITY ANALYSIS"
echo "  ----------------------------------------------------------------"
echo "  Checking for world-writable directories (security concern)..."
echo ""

for DIR in "${DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        PERMS=$(ls -ld "$DIR" | awk '{print $1}')

        # String slicing: ${PERMS:8:1} extracts the character at index 8 (0-based).
        # In a 10-char permission string like "drwxrwxrwx", index 8 is the
        # "other write" bit. If it equals 'w', the directory is world-writable.
        if [ "${PERMS:8:1}" = "w" ]; then
            echo "  [!] WARNING: $DIR is world-writable ($PERMS)"
        fi
    fi
done
echo "  World-writable check complete."

# =============================================================================
# SECTION 3: Git Configuration Directory Audit
# Inspect Git's binary, system config file, and shared resources directory.
# =============================================================================
echo ""
echo "  SECTION 3: GIT CONFIGURATION DIRECTORY AUDIT"
echo "  ----------------------------------------------------------------"

# --- Check and display the Git binary ---
# [ -f "$GIT_BIN" ] checks if the path exists and is a regular file
if [ -f "$GIT_BIN" ]; then
    # awk prints permissions ($1), owner ($3), and group ($4) in one line
    GIT_BIN_PERMS=$(ls -l "$GIT_BIN" | awk '{print $1, $3, $4}')
    # git --version prints the installed Git version string
    GIT_VERSION=$(git --version 2>/dev/null)
    echo "  Git Binary     : $GIT_BIN"
    echo "  Permissions    : $GIT_BIN_PERMS"
    echo "  Version        : $GIT_VERSION"
else
    echo "  Git binary not found at $GIT_BIN"
    echo "  Git may not be installed. Run: sudo apt install git"
fi

echo ""

# --- Check and display the system-wide Git config file ---
if [ -f "$GIT_CONFIG_DIR" ]; then
    GIT_CONF_PERMS=$(ls -l "$GIT_CONFIG_DIR" | awk '{print $1, $3, $4}')
    echo "  Git System Config: $GIT_CONFIG_DIR"
    echo "  Permissions      : $GIT_CONF_PERMS"
    echo "  Contents:"
    # cat reads the file; sed prepends 4 spaces to each line for indentation
    cat "$GIT_CONFIG_DIR" | sed 's/^/    /'
else
    echo "  System-wide Git config ($GIT_CONFIG_DIR) not found."
    echo "  This is normal if Git has not been configured system-wide."
fi

echo ""

# --- Check and display the Git shared resources directory ---
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
echo "================================================================"
