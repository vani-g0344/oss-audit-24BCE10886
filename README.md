# OSS Audit — Git
### The Open Source Audit | Capstone Project

| Field | Details |
|-------|---------|
| **Student Name** | Vani Gupta |
| **Registration Number** | 24BCE10886 |
| **Course** | Open Source Software (NGMC) |
| **Chosen Software** | Git — Version Control System |
| **License** | GNU General Public License v2 (GPL v2) |

---

## Project Overview

This repository contains all deliverables for the Open Source Software Capstone Project. The project conducts a structured audit of **Git**, examining its origin story, license, philosophical values, Linux footprint, FOSS ecosystem, and a comparison with its proprietary alternatives.

The repository includes five original Bash shell scripts that demonstrate practical Linux skills aligned with course units 1–5.

---

## Repository Structure

```
oss-audit-24BCE10886/
├── README.md                          # This file
├── script1_system_identity.sh         # Script 1: System Identity Report
├── script2_package_inspector.sh       # Script 2: FOSS Package Inspector
├── script3_disk_permission_auditor.sh # Script 3: Disk and Permission Auditor
├── script4_log_analyzer.sh            # Script 4: Log File Analyzer
└── script5_manifesto_generator.sh     # Script 5: Open Source Manifesto Generator
```

---

## Scripts Overview

| Script | File | Purpose |
|--------|------|---------|
| Script 1 | `script1_system_identity.sh` | Displays kernel version, distro, user, uptime, date, and OSS license info |
| Script 2 | `script2_package_inspector.sh` | Checks if Git is installed, prints version/license, case-based philosophy notes |
| Script 3 | `script3_disk_permission_auditor.sh` | Audits system directory permissions, sizes, owners; checks Git-specific paths |
| Script 4 | `script4_log_analyzer.sh` | Reads a log file line-by-line, counts keyword occurrences, shows last 5 matches |
| Script 5 | `script5_manifesto_generator.sh` | Interactive: asks 3 questions, generates personalised OSS philosophy manifesto |

---

## Environment Setup

### Requirements

- Linux system (Ubuntu 20.04+, Fedora 36+, or any modern distro)
- Bash shell (version 4.0 or higher)
- Git installed (for Script 2 to report package details)

### Check your Bash version

```bash
bash --version
```

### Install Git (if not already installed)

```bash
# Ubuntu / Debian
sudo apt update && sudo apt install git

# Fedora / RHEL / CentOS
sudo dnf install git

# Arch Linux
sudo pacman -S git
```

---

## How to Run Each Script

### Step 1 — Clone the repository

```bash
git clone https://github.com/<your-username>/oss-audit-24BCE10886.git
cd oss-audit-24BCE10886
```

### Step 2 — Make all scripts executable

```bash
chmod +x script1_system_identity.sh
chmod +x script2_package_inspector.sh
chmod +x script3_disk_permission_auditor.sh
chmod +x script4_log_analyzer.sh
chmod +x script5_manifesto_generator.sh
```

---

### Script 1 — System Identity Report

**Purpose:** Displays a formatted welcome screen with kernel version, distro name, current user, home directory, uptime, date/time, and the OSS license covering the OS and Git.

**Run:**
```bash
./script1_system_identity.sh
```

**Expected output:**
```

          OPEN SOURCE SOFTWARE AUDIT — SYSTEM IDENTITY


  Student   : Vani Gupta
  Reg No    : 24BCE10886
  Software  : Git
  ...
```

**Dependencies:** None. Uses built-in Linux commands (`uname`, `whoami`, `uptime`, `date`, `hostname`).

---

### Script 2 — FOSS Package Inspector

**Purpose:** Detects whether `git` is installed, which package manager is available (rpm or dpkg), prints version and license info, and uses a `case` statement to display philosophy notes.

**Run:**
```bash
./script2_package_inspector.sh
```

**Dependencies:** `rpm` (Fedora/RHEL) or `dpkg`/`dpkg-query` (Ubuntu/Debian). Git must be installed for full output.

---

### Script 3 — Disk and Permission Auditor

**Purpose:** Iterates over a list of system directories, prints permissions, owner, group, and size for each. Flags world-writable directories. Audits Git's binary and config paths specifically.

**Run:**
```bash
./script3_disk_permission_auditor.sh
```

**Dependencies:** Standard Linux tools: `ls`, `du`, `awk`, `cut`. No root required (some sizes may show permission errors for restricted directories — these are suppressed with `2>/dev/null`).

---

### Script 4 — Log File Analyzer

**Purpose:** Reads a log file line-by-line, counts lines containing a keyword (default: `error`), reports total lines, occurrence count, severity assessment, and displays the last 5 matching lines.

**Run:**
```bash
# Basic usage — search for 'error' in syslog
./script4_log_analyzer.sh /var/log/syslog

# Custom keyword
./script4_log_analyzer.sh /var/log/syslog warning

# Ubuntu alternative log path
./script4_log_analyzer.sh /var/log/auth.log failed

# Fedora/RHEL log path
./script4_log_analyzer.sh /var/log/messages error
```

**Note on log file access:**
Some log files (e.g., `/var/log/syslog`) may require `sudo` to read:
```bash
sudo ./script4_log_analyzer.sh /var/log/syslog error
```

**Dependencies:** `grep`, `wc`, `tail` — all standard Linux utilities.

---

### Script 5 — Open Source Manifesto Generator

**Purpose:** Interactively asks three questions and generates a personalised open source philosophy statement, saving it to `manifesto_<username>.txt` in the current directory.

**Run:**
```bash
./script5_manifesto_generator.sh
```

**Interactive prompts:**
```
1. Name one open-source tool you use every day:
2. In one word, what does 'freedom' mean to you in software?
3. Name one project you would build and share freely:
```

**Output file:** `manifesto_<your-linux-username>.txt` — created in the current directory.

**Dependencies:** None beyond Bash built-ins (`read`, `date`, `cat`, `echo`).

---

## Shell Concepts Covered

| Concept | Scripts |
|---------|---------|
| Variables and command substitution `$()` | 1, 2, 3, 4, 5 |
| `if-then-else` conditional logic | 1, 2, 3, 4, 5 |
| `case` statement | 2 |
| `for` loop with arrays | 3 |
| `while IFS= read -r` loop | 4 |
| Counter variables and arithmetic `$(())` | 4 |
| Command-line arguments `$1`, `$2` | 4 |
| `read -p` interactive input | 5 |
| File writing with `>` and `>>` | 5 |
| Pipe with `grep`, `awk`, `cut` | 1, 2, 3, 4 |
| `rpm -qi` and `dpkg -l` package inspection | 2 |

---

## Troubleshooting

**Permission denied when running scripts:**
```bash
chmod +x script_name.sh
```

**Log file not found (Script 4):**
Check available log files with:
```bash
ls /var/log/
```

**`rpm` command not found (Script 2 on Ubuntu):**
The script automatically falls back to `dpkg` on Debian/Ubuntu systems. No action needed.

**Script 5 manifesto file not saved:**
Ensure you have write permission in the current directory:
```bash
ls -la .
```

---

## Academic Integrity Statement

All shell scripts in this repository are original work written by Vani Gupta (24BCE10886). The project report is original writing. No AI tools were used to generate the written content of the report.

---

*Open Source Software — Capstone Project | VITyarthi*
