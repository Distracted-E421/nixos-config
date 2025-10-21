# ⚠️ MIGRATION NOTICE - THIS DIRECTORY IS DEPRECATED

**Date:** 2025-10-20  
**Status:** 🔴 **DEPRECATED - DO NOT USE**

---

## 📦 This Configuration Has Been Centralized

All NixOS configuration has been moved to the **centralized** `/nixos/` directory at the repository root.

### New Location:
```
/home/e421/homelab/nixos/
```

### What Was Moved:

#### Documentation → `nixos/docs/`
- All NIXOS_*.md files
- Deployment guides
- Troubleshooting guides
- Setup scripts

#### Configuration Files → `nixos/configs/`
- Hyprland configuration files
- Additional configuration templates

#### Modules → `nixos/modules/`
- The main `nixos/` directory has **MORE MODULES** than this deprecated directory:
  - ✅ `streaming.nix` (missing here)
  - ✅ `vivaldi.nix` (missing here)
  - ✅ `greetd-enhanced.nix` (missing here)
  - ✅ `hyprland-ly.nix` (missing here)

---

## 🚀 What You Should Do

### If You're Looking for NixOS Configuration:
```bash
cd ~/homelab/nixos/
```

### If You're Deploying to a Machine:
```bash
cd ~/homelab/nixos/
sudo nixos-rebuild switch --flake .#<hostname>
```

### If You're Looking for Documentation:
```bash
cd ~/homelab/nixos/docs/
cat INDEX.md  # Full documentation index
```

---

## 🗑️ Cleanup Plan

This directory contains **duplicate/outdated** files that should NOT be used:

- `machines/` - Duplicates of `nixos/hosts/` (outdated)
- `modules/` - Duplicates of `nixos/modules/` (missing newer modules)
- `flake.nix` - Duplicate of `nixos/flake.nix` (outdated)
- `hyprland/` - Now empty (moved to `nixos/configs/hyprland/`)

### Safe to Delete:
- [x] `hyprland/` directory (empty)
- [ ] `machines/` directory (duplicate)
- [ ] `modules/` directory (duplicate)
- [ ] `flake.nix` (duplicate)
- [ ] `flake.lock` (duplicate)
- [ ] `README.md` (outdated)
- [ ] `pterodactyl.php` (unrelated file?)

**Recommendation:** Archive or delete this entire `config/` directory after verifying everything works from `nixos/`.

---

## ✅ Migration Completed

- **Date:** October 20, 2025
- **Files Moved:** 30+ files
- **Documentation Organized:** 3 categories (deployment, guides, troubleshooting)
- **Configuration Centralized:** All in `/nixos/`
- **Status:** ✅ Complete

---

**For more information, see:**
- [NixOS Documentation Index](/home/e421/homelab/nixos/docs/INDEX.md)
- [Main NixOS README](/home/e421/homelab/nixos/README.md)
