# sops-nix Secrets Management Setup Guide

## 🔐 **What is sops-nix?**

`sops-nix` allows you to encrypt secrets with age (or GPG) and commit them safely to your public repository. Secrets are automatically decrypted on your NixOS systems during activation.

---

## 🚀 **Initial Setup (One-Time)**

### **Step 1: Generate Age Keys for Each Machine**

Each machine needs its own age encryption key.

```bash
# On each machine (or generate all keys on one machine):
ssh nixos-test  # or ssh to any NixOS machine

# Create directory for keys
sudo mkdir -p /var/lib/sops-nix

# Generate age key
sudo nix-shell -p age --run "age-keygen -o /var/lib/sops-nix/key.txt"

# View the public key (you'll need this!)
sudo age-keygen -y /var/lib/sops-nix/key.txt

# Example output:
# age1hl6h4x9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9
```

**Save each machine's public key!**

---

### **Step 2: Create `.sops.yaml` Configuration**

Create `/home/e421/nixos-config/.sops.yaml` with all machine public keys:

```yaml
# .sops.yaml - sops configuration
keys:
  # Machine age keys (public keys only)
  - &nixos-test age1hl6h4x9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9  # Replace with actual key
  - &framework age1hl6h4x9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9   # Replace with actual key
  - &obsidian age1hl6h4x9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9   # Replace with actual key
  - &neon-laptop age1hl6h4x9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9  # Replace with actual key
  - &pi-server age1hl6h4x9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9  # Replace with actual key
  
  # Your admin key (for managing secrets from your workstation)
  - &admin age1hl6h4x9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9q9  # Your personal age key

creation_rules:
  # Default rule for secrets/secrets.yaml
  - path_regex: secrets/secrets\.yaml$
    key_groups:
      - age:
          - *nixos-test
          - *framework
          - *obsidian
          - *neon-laptop
          - *pi-server
          - *admin
  
  # Per-machine secrets (optional)
  - path_regex: secrets/nixos-test\.yaml$
    key_groups:
      - age:
          - *nixos-test
          - *admin
  
  - path_regex: secrets/framework\.yaml$
    key_groups:
      - age:
          - *framework
          - *admin
```

---

### **Step 3: Create Your First Secret File**

```bash
cd /home/e421/nixos-config/secrets

# Create unencrypted template
cat > secrets.yaml << 'EOF'
# Example secrets (UNENCRYPTED - for reference only)
users:
  e421:
    # Generate password hash with: mkpasswd -m sha-512
    password: $6$rounds=656000$...  # Replace with actual hash

wifi:
  home:
    password: your-wifi-password

tailscale:
  auth-key: tskey-auth-...

github:
  token: ghp_...
EOF

# Encrypt it with sops
nix-shell -p sops --run "sops -e -i secrets.yaml"

# The file is now encrypted!
# You can safely commit this to git
```

**Note:** After encrypting, `.yaml` files become `.yaml` but are encrypted in place.

---

### **Step 4: Edit Encrypted Secrets**

```bash
# Edit encrypted file (will decrypt in your editor)
nix-shell -p sops --run "sops secrets.yaml"

# sops will:
# 1. Decrypt the file
# 2. Open in $EDITOR
# 3. Re-encrypt when you save and exit
```

---

## 📦 **Using Secrets in NixOS Configuration**

### **Example: User Password from Secrets**

Update `modules/users/e421.nix`:

```nix
{ config, pkgs, lib, ... }:

{
  # Enable sops secret for user password
  sops.secrets."users/e421/password" = {
    neededForUsers = true;  # Available before user creation
  };

  users.users.e421 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    
    # Use password from sops secret
    hashedPasswordFile = config.sops.secrets."users/e421/password".path;
    
    # ... rest of user config
  };
}
```

### **Example: WiFi Password**

```nix
{ config, ... }:

{
  sops.secrets."wifi/home/password" = {};

  networking.wireless.networks."MyHomeWiFi" = {
    pskRaw = config.sops.secrets."wifi/home/password".path;
  };
}
```

### **Example: Tailscale Auth Key**

```nix
{ config, ... }:

{
  sops.secrets."tailscale/auth-key" = {
    owner = "tailscale";
    group = "tailscale";
  };

  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets."tailscale/auth-key".path;
  };
}
```

---

## 🔄 **Workflow**

### **Daily Use:**

1. **Add new secret:**

   ```bash
   cd /home/e421/nixos-config
   nix-shell -p sops --run "sops secrets/secrets.yaml"
   # Add your secret in YAML format
   ```

2. **Update configuration to use secret:**

   ```nix
   sops.secrets."my/new/secret" = {};
   # Use: config.sops.secrets."my/new/secret".path
   ```

3. **Rebuild:**

   ```bash
   sudo nixos-rebuild switch --flake .#hostname
   ```

### **Adding a New Machine:**

1. Generate age key on new machine (Step 1 above)
2. Add public key to `.sops.yaml`
3. Re-encrypt all secrets with new key:

   ```bash
   nix-shell -p sops --run "sops updatekeys secrets/secrets.yaml"
   ```

4. Commit and push
5. Pull on new machine and rebuild

---

## 🛡️ **Security Best Practices**

### **DO:**

✅ Commit encrypted `.yaml` files  
✅ Keep `.sops.yaml` in git (contains only public keys)  
✅ Use strong, unique passwords  
✅ Rotate secrets regularly  
✅ Use per-machine secrets for sensitive data  

### **DON'T:**

❌ Commit unencrypted `.yaml` files  
❌ Commit private age keys (`.key` files)  
❌ Share your private age key  
❌ Store secrets in plain text anywhere  

---

## 📖 **Example Secrets File Structure**

```yaml
# secrets/secrets.yaml (encrypted)
users:
  e421:
    password: $6$rounds=656000$...

wifi:
  home:
    ssid: MyHomeNetwork
    password: super-secret-wifi-password
  
  mobile:
    ssid: MobileHotspot
    password: another-secret

tailscale:
  auth-key: tskey-auth-xxxxxxxxxxxxxxxxxxxxxxxxxxxxx

github:
  token: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  deploy-key: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAA...
    -----END OPENSSH PRIVATE KEY-----

services:
  database:
    password: database-admin-password
  
  api:
    key: api-secret-key
```

---

## 🐛 **Troubleshooting**

### **"Failed to decrypt"**

- Check age key file exists: `sudo cat /var/lib/sops-nix/key.txt`
- Verify public key is in `.sops.yaml`
- Re-encrypt secrets: `sops updatekeys secrets.yaml`

### **"Permission denied"**

- Secrets are owned by `root` by default
- Set custom owner/group in secret definition:

  ```nix
  sops.secrets."myservice/password" = {
    owner = "myservice";
    group = "myservice";
    mode = "0400";
  };
  ```

### **"Secret not found"**

- Check secret path matches YAML structure
- Example: YAML `users.e421.password` → `sops.secrets."users/e421/password"`

---

## 🔗 **Resources**

- **sops-nix Documentation:** <https://github.com/Mic92/sops-nix>
- **sops Guide:** <https://github.com/mozilla/sops>
- **Age Encryption:** <https://github.com/FiloSottile/age>

---

**Date:** 2025-10-16  
**Status:** Ready for use  
**Security:** All secrets encrypted with age
