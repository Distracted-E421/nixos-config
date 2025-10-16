# Secrets Management

This directory contains sensitive configuration that should **NOT** be committed to the public repository.

## 🔒 **What Goes Here**

- GitHub tokens and credentials
- API keys
- Private SSH keys (if needed)
- Environment-specific secrets
- Personal access tokens

## 📁 **File Structure**

```
secrets/
├── .gitignore           # Excludes secrets from git
├── README.md            # This file
├── github.nix.template  # Template for GitHub config
├── github.nix           # Your actual GitHub config (gitignored)
└── [other secrets]      # Other secret files (gitignored)
```

## 🚀 **Setup Instructions**

### **1. Copy Templates**

```bash
cd /home/e421/homelab/devices/Obsidian/config/secrets
cp github.nix.template github.nix
```

### **2. Edit with Your Credentials**

```bash
vim github.nix  # Or your preferred editor
```

### **3. Import in Your Configuration**

In your machine's `configuration.nix`:

```nix
# Import secrets (if they exist)
imports = [
  # ... other imports ...
] ++ (if builtins.pathExists ./../../secrets/github.nix 
      then [ ./../../secrets/github.nix ] 
      else []);
```

## ⚠️ **Security Notes**

1. **Never commit actual secrets** - only templates
2. **Check git status** before pushing: `git status`
3. **Use separate secrets per machine** if needed
4. **Consider using `sops-nix`** for production environments
5. **Backup secrets securely** outside of git

## 🔄 **Syncing Across Machines**

Since secrets aren't in git, you need to copy them manually:

```bash
# From source machine
scp secrets/github.nix user@target-machine:/path/to/homelab/devices/Obsidian/config/secrets/

# Or use a secure method like:
# - Bitwarden/1Password/pass
# - Encrypted USB drive
# - Tailscale file transfer
```

## 📚 **Advanced: sops-nix**

For production, consider using [`sops-nix`](https://github.com/Mic92/sops-nix):

```nix
inputs.sops-nix.url = "github:Mic92/sops-nix";

# Encrypt secrets with age or GPG
# Commit encrypted files to git
# Decrypt at build/runtime
```

## 🎯 **Current Usage**

Currently used for:
- GitHub authentication tokens
- GitHub user configuration
- Git global config with credentials
