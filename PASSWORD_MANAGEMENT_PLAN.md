# 🔐 Password & Security Management Roadmap

**Date:** 2025-10-16  
**Status:** Planning phase  
**Priority:** HIGH (security incident prevention)

---

## 🚨 **Current Situation Assessment**

### **Risks Identified:**

- ⚠️ **Password reuse** across multiple services
- ⚠️ **Real words** used in passwords (dictionary attack vulnerable)
- ⚠️ **No comprehensive password manager** in use
- ⚠️ **Single YubiKey** (no backup for 2FA)
- ⚠️ **Biometric concerns** (4th Amendment protection gap)

### **Assets at Risk:**

- Email accounts (password reset vector for everything)
- GitHub/development accounts
- Financial services
- Cloud infrastructure
- Social media/communications
- Personal data repositories

---

## 🎯 **Security Goals**

### **Short-Term (1-2 weeks):**

1. ✅ Set up sops-nix for NixOS secrets
2. [ ] Deploy password manager with strong master password
3. [ ] Change top 10 most critical passwords
4. [ ] Enable 2FA on critical accounts
5. [ ] Document password recovery procedures

### **Medium-Term (1-2 months):**

1. [ ] Migrate all passwords to password manager
2. [ ] Purchase backup YubiKey (minimum 2 total)
3. [ ] Set up backup codes for all 2FA services
4. [ ] Implement password rotation schedule
5. [ ] Set up secure password sharing for family

### **Long-Term (3-6 months):**

1. [ ] Full password audit and strength review
2. [ ] Implement hardware key for all compatible services
3. [ ] Set up encrypted backup system
4. [ ] Establish security incident response plan
5. [ ] Regular security review schedule

---

## 🔑 **Password Manager Selection**

### **Recommended: Bitwarden (Self-Hosted or Cloud)**

**Pros:**
- ✅ Open source
- ✅ Cross-platform (Linux, Windows, mobile, browser)
- ✅ Self-hosting option (Vaultwarden on NixOS)
- ✅ YubiKey support
- ✅ Family organization support
- ✅ CLI available
- ✅ Affordable ($10/year for premium)

**Cons:**
- ⚠️ Requires trust in cloud (if not self-hosted)
- ⚠️ Self-hosting requires maintenance

### **Alternative: KeePassXC (Local)**

**Pros:**
- ✅ Fully offline
- ✅ Encrypted database file
- ✅ No cloud dependency
- ✅ Free and open source
- ✅ YubiKey support

**Cons:**
- ⚠️ Manual syncing required
- ⚠️ No official mobile app
- ⚠️ More complex backup strategy

### **Decision:** Start with **Bitwarden cloud** → Migrate to self-hosted Vaultwarden later

**Why:**
- Quick to set up and start using
- Cross-platform out of the box
- Can migrate to self-hosted once NixOS homelab stable
- $10/year is negligible for critical security

---

## 📋 **Implementation Plan**

### **Phase 1: Emergency Triage (Week 1)**

#### **Day 1-2: Password Manager Setup**

```bash
# Install Bitwarden on NixOS
environment.systemPackages = with pkgs; [
  bitwarden
  bitwarden-cli
];

# Or for KeePassXC
environment.systemPackages = with pkgs; [
  keepassxc
];
```

**Steps:**
1. Create Bitwarden account with strong master password
2. Enable 2FA on Bitwarden itself (YubiKey + backup codes)
3. Install browser extension
4. Install mobile app
5. **Document master password recovery procedure** (sealed envelope in safe, trusted person, etc.)

#### **Day 3-7: Critical Account Migration**

**Priority 1 - Immediate (These can access everything):**
- [ ] Primary email (Gmail/Outlook/etc)
- [ ] Password manager's email
- [ ] GitHub account
- [ ] Phone provider (SIM swap attacks)

**Priority 2 - Financial (High impact):**
- [ ] Bank accounts
- [ ] Credit cards
- [ ] PayPal/payment services
- [ ] Cryptocurrency wallets

**Priority 3 - Infrastructure (Homelab access):**
- [ ] Domain registrar
- [ ] Cloud providers (AWS, GCP, etc.)
- [ ] VPS/hosting services
- [ ] Tailscale account

**For each account:**
1. Generate strong password (20+ characters, random)
2. Store in Bitwarden
3. Enable 2FA (preferably with YubiKey, fallback to authenticator app)
4. Save backup codes in Bitwarden secure notes
5. Test login with new credentials

---

### **Phase 2: Complete Migration (Weeks 2-4)**

#### **Week 2: Communication & Social**
- [ ] Discord
- [ ] Slack workspaces
- [ ] Telegram
- [ ] Signal
- [ ] Reddit
- [ ] Twitter/X
- [ ] LinkedIn

#### **Week 3: Development & Services**
- [ ] GitLab
- [ ] Docker Hub
- [ ] NPM registry
- [ ] PyPI
- [ ] Cloudflare
- [ ] Let's Encrypt (if using account)

#### **Week 4: Everything Else**
- [ ] Streaming services (Spotify, Netflix, etc.)
- [ ] Gaming accounts (Steam, Epic, etc.)
- [ ] Online stores
- [ ] Forums and communities
- [ ] Miscellaneous accounts

---

### **Phase 3: Hardware Key Deployment (Month 2)**

#### **YubiKey Purchase**

**Recommended:**
- **2x YubiKey 5 NFC** ($90 total)
  - Primary: Daily use on keychain
  - Backup: Stored in safe/secure location

**Setup:**
1. Register both keys with all services that support them
2. Test both keys on each service
3. Store backup key securely
4. Document which services use which key

#### **YubiKey-Compatible Services Priority:**

**Tier 1 (Must use hardware key):**
- Password manager (Bitwarden)
- Email accounts
- GitHub
- Financial services

**Tier 2 (Strongly recommended):**
- Cloud providers
- Domain registrar
- Social media
- Development platforms

**Tier 3 (Nice to have):**
- Gaming accounts
- Streaming services
- Forums

---

### **Phase 4: Self-Hosted Vaultwarden (Month 3)**

Once NixOS homelab is stable, migrate to self-hosted:

**NixOS Configuration:**

```nix
# In services module or machine config
services.vaultwarden = {
  enable = true;
  config = {
    DOMAIN = "https://vault.yourdomain.com";
    SIGNUPS_ALLOWED = false;  # Disable public signups
    ROCKET_ADDRESS = "127.0.0.1";
    ROCKET_PORT = 8222;
  };
};

# Reverse proxy with Caddy/Nginx
services.caddy.virtualHosts."vault.yourdomain.com" = {
  extraConfig = ''
    reverse_proxy localhost:8222
  '';
};
```

**Migration Steps:**
1. Deploy Vaultwarden on homelab server
2. Export from Bitwarden cloud
3. Import to self-hosted Vaultwarden
4. Test thoroughly
5. Update all clients
6. Cancel Bitwarden subscription

---

## 🛡️ **4th Amendment Protection Strategy**

### **Biometric Concerns:**

**Problem:** Courts have ruled biometric unlocks can be compelled (unlike passwords/PINs)

**Solutions:**

1. **Password Manager:** Always use strong password, never biometric
2. **Phone:** 
   - Use strong PIN/password
   - Quick lockdown feature (power button 5x on most phones)
   - Disable biometric in sensitive situations

3. **Laptop/Desktop:**
   - Full disk encryption with strong password
   - No biometric unlock for LUKS/encryption
   - Auto-lock on idle

4. **Emergency Lockdown Procedure:**
   - Document how to quickly lock all devices
   - Practice regularly
   - Consider "dead man's switch" for certain situations

**NixOS Implementation:**

```nix
# Disable biometric auth system-wide
security.pam.services = {
  login.fprintAuth = false;
  sudo.fprintAuth = false;
  polkit.fprintAuth = false;
};

# Strong disk encryption
boot.initrd.luks.devices = {
  root = {
    device = "/dev/nvme0n1p2";
    preLVM = true;
    # Strong password required, no biometric bypass
  };
};

# Auto-lock on idle
services.xserver.displayManager.gdm.autoSuspend = true;
programs.hyprland.settings = {
  general.auto_lock_timeout = 300;  # 5 minutes
};
```

---

## 📊 **Password Strength Guidelines**

### **Minimum Requirements:**

| Account Type | Length | Complexity | Rotation |
|--------------|--------|------------|----------|
| Critical (email, password manager) | 24+ chars | Max entropy | Never (unless compromised) |
| Financial | 20+ chars | High entropy | Yearly |
| Infrastructure | 20+ chars | High entropy | 6 months |
| Social/Gaming | 16+ chars | Medium entropy | As needed |

### **Entropy Sources:**

**Good:**
- Password manager generated: `Kx9$mP2#nQ7@wL5&zR8!`
- Diceware passphrase: `correct-horse-battery-staple-beyond-elephant`

**Bad:**
- Dictionary word + numbers: `password123`
- Personal info: `john1985!`
- Patterns: `qwerty123`

---

## 🔄 **Backup & Recovery Strategy**

### **Master Password Recovery:**

**Option 1: Sealed Envelope**
- Write master password on paper
- Seal in tamper-evident envelope
- Store in fireproof safe
- Document procedure for authorized access

**Option 2: Trusted Person Split**
- Split master password into 2-3 parts (Shamir's Secret Sharing)
- Give each part to different trusted person
- Requires 2 of 3 to reconstruct
- Document emergency contact procedure

**Option 3: Cryptographic Split**
- Use GPG or similar to encrypt master password
- Split GPG key
- Store pieces in multiple locations

### **Backup Codes Storage:**

```yaml
# Store in sops-encrypted secrets
backup-codes:
  bitwarden:
    - code1-xxxx-xxxx
    - code2-xxxx-xxxx
  
  github:
    - code1-yyyy-yyyy
    - code2-yyyy-yyyy
  
  google:
    - code1-zzzz-zzzz
    - code2-zzzz-zzzz
```

### **Regular Backup Schedule:**

- **Daily:** Password manager auto-sync to cloud/self-hosted
- **Weekly:** Encrypted export stored offline
- **Monthly:** Full backup tested for recovery

---

## 📅 **Ongoing Maintenance Schedule**

### **Weekly:**
- [ ] Check for compromised passwords (Bitwarden breach detection)
- [ ] Review recent account activity

### **Monthly:**
- [ ] Test backup restoration
- [ ] Review active sessions on critical accounts
- [ ] Check for new 2FA options on services

### **Quarterly:**
- [ ] Rotate infrastructure passwords
- [ ] Review and revoke unused API keys
- [ ] Update recovery contact information

### **Yearly:**
- [ ] Full security audit
- [ ] Rotate financial account passwords
- [ ] Test YubiKey backup
- [ ] Review and update this plan

---

## 🚨 **Incident Response Plan**

### **If Password Manager Compromised:**

1. **Immediately:**
   - Change master password from trusted device
   - Force log out all sessions
   - Review recent activity logs
   - Notify any services with sensitive data

2. **Within 24 hours:**
   - Change all Priority 1 passwords
   - Enable/verify 2FA on all accounts
   - Review security questions

3. **Within 1 week:**
   - Change all remaining passwords
   - Conduct full security review

### **If Email Compromised:**

1. **Immediately:**
   - Change password from trusted device
   - Review forwarding rules and filters
   - Check sent items for unauthorized activity
   - Revoke third-party app access

2. **Within 24 hours:**
   - Change passwords for all accounts using that email
   - Enable 2FA if not already
   - Notify contacts of potential phishing

### **If YubiKey Lost/Stolen:**

1. **Immediately:**
   - Use backup key to access accounts
   - Revoke lost key from all services
   - Order replacement key

2. **Within 1 week:**
   - Register new key
   - Store new backup securely
   - Update documentation

---

## 🎯 **Success Metrics**

### **Security Posture:**

- [ ] 100% of accounts in password manager
- [ ] 100% unique passwords
- [ ] 90%+ accounts with 2FA enabled
- [ ] 50%+ critical accounts with hardware key
- [ ] 0 reused passwords
- [ ] 0 dictionary-based passwords

### **Operational:**

- [ ] Backup restoration tested monthly
- [ ] No password-related lockouts
- [ ] Family members can access shared passwords
- [ ] Recovery procedure documented and tested

---

## 📚 **Resources**

- **Bitwarden:** https://bitwarden.com
- **Vaultwarden:** https://github.com/dani-garcia/vaultwarden
- **YubiKey Guide:** https://www.yubico.com/setup/
- **EFF Dice-Generated Passphrases:** https://www.eff.org/dice
- **Have I Been Pwned:** https://haveibeenpwned.com/
- **sops-nix Documentation:** https://github.com/Mic92/sops-nix

---

## ✅ **Next Immediate Actions**

1. **Today:**
   - [ ] Create Bitwarden account
   - [ ] Set strong master password
   - [ ] Install browser extension and mobile app
   - [ ] Enable 2FA on Bitwarden

2. **This Week:**
   - [ ] Migrate top 10 critical accounts
   - [ ] Enable 2FA on all Priority 1 accounts
   - [ ] Save backup codes

3. **This Month:**
   - [ ] Complete full migration to password manager
   - [ ] Order YubiKeys
   - [ ] Set up backup procedure

---

**Last Updated:** 2025-10-16  
**Next Review:** 2025-11-16  
**Status:** Ready to implement
