# SSH Keys: Complete Guide

## What Are SSH Keys?

SSH keys are a pair of cryptographic keys used for authentication - proving you are who you say you are without a password.

```
┌─────────────────┐         ┌─────────────────┐
│  PRIVATE KEY    │         │  PUBLIC KEY     │
│  (id_ed25519)   │         │  (id_ed25519.pub)│
│                 │         │                 │
│  🔐 SECRET      │         │  🔓 SHAREABLE   │
│  Keep on YOUR   │         │  Put on servers │
│  machine only   │         │  GitHub, etc.   │
└─────────────────┘         └─────────────────┘
        │                           │
        │    Mathematical pair      │
        └───────────────────────────┘
```

**How it works:**
1. Server has your **public key**
2. You connect, server sends a challenge
3. Your **private key** signs the challenge
4. Server verifies with public key
5. You're in - no password needed

---

## Key Types (Best to Worst)

| Type | Bits | Security | Speed | Recommendation |
|------|------|----------|-------|----------------|
| **Ed25519** | 256 | Excellent | Fast | ✅ Use this |
| **ECDSA** | 256/384/521 | Good | Fast | Okay |
| **RSA** | 2048-4096 | Good | Slow | Legacy only |
| **DSA** | 1024 | Weak | - | ❌ Never use |

**Use Ed25519** unless you need compatibility with old systems.

---

## Generating SSH Keys

### Standard Ed25519 (Recommended)

```bash
ssh-keygen -t ed25519 -C "your.email@example.com"
```

You'll see:

```
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/ember/.ssh/id_ed25519):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
```

**Recommendations:**
- **File location:** Press Enter for default, or specify like `~/.ssh/github_ed25519`
- **Passphrase:** Always set one! It encrypts your private key.

### RSA (If Ed25519 Not Supported)

```bash
ssh-keygen -t rsa -b 4096 -C "your.email@example.com"
```

### Multiple Keys for Different Services

```bash
# GitHub
ssh-keygen -t ed25519 -C "github" -f ~/.ssh/github_ed25519

# Work server
ssh-keygen -t ed25519 -C "work" -f ~/.ssh/work_ed25519

# Personal server
ssh-keygen -t ed25519 -C "personal" -f ~/.ssh/personal_ed25519
```

---

## Understanding Your Keys

```bash
# List your keys
ls -la ~/.ssh/

# You'll see pairs:
# id_ed25519       <- PRIVATE (no extension) - NEVER share
# id_ed25519.pub   <- PUBLIC (.pub) - safe to share
```

### View Your Public Key

```bash
cat ~/.ssh/id_ed25519.pub
```

Output looks like:

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... your.email@example.com
```

This is what you copy to GitHub, servers, etc.

---

## SSH Config File

Create `~/.ssh/config` to manage multiple keys and hosts:

```bash
# Create/edit config
nano ~/.ssh/config
```

```ssh-config
# Default settings for all hosts
Host *
    AddKeysToAgent yes
    IdentitiesOnly yes

# GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_ed25519

# Work server
Host work
    HostName work.example.com
    User ember
    IdentityFile ~/.ssh/work_ed25519
    Port 22

# Personal VPS
Host vps
    HostName 123.45.67.89
    User root
    IdentityFile ~/.ssh/personal_ed25519

# Jump through bastion
Host internal
    HostName 10.0.0.5
    User admin
    ProxyJump bastion.example.com
```

Now you can just:

```bash
ssh work      # Instead of: ssh -i ~/.ssh/work_ed25519 ember@work.example.com
ssh vps       # Instead of: ssh -i ~/.ssh/personal_ed25519 root@123.45.67.89
```

Set proper permissions:

```bash
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
chmod 700 ~/.ssh
```

---

## SSH Agent (Key Manager)

The SSH agent holds your decrypted keys in memory so you don't type your passphrase repeatedly.

### Start Agent (Fish Shell)

Add to `~/.config/fish/config.fish`:

```fish
# SSH Agent
if test -z "$SSH_AUTH_SOCK"
    eval (ssh-agent -c) > /dev/null
end
```

### Add Keys to Agent

```bash
# Add default key
ssh-add

# Add specific key
ssh-add ~/.ssh/github_ed25519

# List loaded keys
ssh-add -l

# Remove all keys
ssh-add -D
```

### Persistent Agent (KDE/GNOME)

Your desktop environment likely has a built-in agent. Check:

```bash
echo $SSH_AUTH_SOCK
# Should show something like: /run/user/1000/keyring/ssh
```

If using KDE Wallet or GNOME Keyring, keys are stored securely and unlocked at login.

---

## Adding Keys to Services

### GitHub/GitLab

1. Copy your public key:

```bash
cat ~/.ssh/github_ed25519.pub | wl-copy  # Wayland
# or
cat ~/.ssh/github_ed25519.pub | xclip -selection clipboard  # X11
```

2. Go to GitHub → Settings → SSH and GPG keys → New SSH key
3. Paste and save

4. Test:

```bash
ssh -T git@github.com
# Hi username! You've successfully authenticated...
```

### Remote Server

```bash
# Method 1: ssh-copy-id (easiest)
ssh-copy-id -i ~/.ssh/work_ed25519.pub user@server.com

# Method 2: Manual
cat ~/.ssh/work_ed25519.pub | ssh user@server.com "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

# Method 3: Copy-paste
# On server, edit ~/.ssh/authorized_keys and paste your public key
```

---

## Post-Quantum SSH Keys

Quantum computers could break Ed25519/RSA. New algorithms are being standardized.

### Current Status (2025-2026)

| Algorithm | Type | Status |
|-----------|------|--------|
| **ML-KEM** (Kyber) | Key exchange | NIST standardized |
| **ML-DSA** (Dilithium) | Signatures | NIST standardized |
| **SLH-DSA** (SPHINCS+) | Signatures | NIST standardized |

### OpenSSH 9.x Post-Quantum Support

OpenSSH 9.0+ supports hybrid key exchange:

```bash
# Check your OpenSSH version
ssh -V
```

### Generate Hybrid PQ Keys (If Supported)

OpenSSH 9.5+ with `sntrup761x25519-sha512@openssh.com`:

```bash
# This uses hybrid: classical X25519 + post-quantum NTRU Prime
ssh-keygen -t ed25519 -C "pq-hybrid"
```

The key exchange is automatically PQ-hybrid if both client and server support it.

### Force PQ Key Exchange

In `~/.ssh/config`:

```ssh-config
Host secure-server
    HostName pq.example.com
    KexAlgorithms sntrup761x25519-sha512@openssh.com
```

### Check What's Available

```bash
# List supported key exchange algorithms
ssh -Q kex

# Look for:
# sntrup761x25519-sha512@openssh.com  <- Hybrid PQ
```

### OQS-OpenSSH (Experimental)

For full PQ keys (not just key exchange), use Open Quantum Safe fork:

```bash
# Not in standard repos - requires building from source
# https://github.com/open-quantum-safe/openssh

# Generate ML-DSA key (experimental)
# ssh-keygen -t ml-dsa-65
```

**Recommendation:** For now, use Ed25519 with hybrid PQ key exchange. Full PQ signature keys are still maturing.

---

## Security Best Practices

### Do's ✅

```bash
# Always use a passphrase
ssh-keygen -t ed25519 -C "email" -N "strong-passphrase"

# Correct permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/authorized_keys

# Use specific keys per service
ssh-keygen -t ed25519 -f ~/.ssh/github_ed25519
ssh-keygen -t ed25519 -f ~/.ssh/work_ed25519

# Rotate keys periodically (yearly)
```

### Don'ts ❌

```bash
# Never share your private key
# Never commit private keys to git
# Never use empty passphrase for important keys
# Never use DSA or RSA < 2048 bits
# Never ignore host key warnings
```

### Add to `.gitignore`

```bash
echo "id_*" >> ~/.gitignore_global
echo "!*.pub" >> ~/.gitignore_global
```

---

## Useful Commands Cheat Sheet

```bash
# Generate key
ssh-keygen -t ed25519 -C "comment"

# View public key
cat ~/.ssh/id_ed25519.pub

# View key fingerprint
ssh-keygen -lf ~/.ssh/id_ed25519.pub

# Copy to server
ssh-copy-id -i ~/.ssh/key.pub user@host

# Test GitHub connection
ssh -T git@github.com

# Debug connection
ssh -vvv user@host

# Agent - add key
ssh-add ~/.ssh/id_ed25519

# Agent - list keys
ssh-add -l

# Agent - remove all
ssh-add -D

# Change passphrase
ssh-keygen -p -f ~/.ssh/id_ed25519

# Convert key format (OpenSSH <-> PEM)
ssh-keygen -p -m PEM -f ~/.ssh/id_rsa
```

---

## Quick Setup Script

```bash
#!/bin/bash
# setup-ssh.sh - Run once on new machine

set -e

SSH_DIR="$HOME/.ssh"
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Generate main key if not exists
if [ ! -f "$SSH_DIR/id_ed25519" ]; then
    echo "Generating main Ed25519 key..."
    ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)" -f "$SSH_DIR/id_ed25519"
fi

# Generate GitHub key
if [ ! -f "$SSH_DIR/github_ed25519" ]; then
    echo "Generating GitHub Ed25519 key..."
    ssh-keygen -t ed25519 -C "github" -f "$SSH_DIR/github_ed25519"
fi

# Create config if not exists
if [ ! -f "$SSH_DIR/config" ]; then
    cat > "$SSH_DIR/config" << 'EOF'
Host *
    AddKeysToAgent yes
    IdentitiesOnly yes

Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_ed25519
EOF
    chmod 600 "$SSH_DIR/config"
fi

echo ""
echo "Done! Your GitHub public key:"
cat "$SSH_DIR/github_ed25519.pub"
echo ""
echo "Copy the above to: https://github.com/settings/ssh/new"
```

---

## Summary

1. **Use Ed25519** for all new keys
2. **Always set a passphrase**
3. **Use SSH config** for multiple hosts/keys
4. **Use SSH agent** to avoid retyping passphrase
5. **One key per service** (GitHub, work, personal)
6. **PQ-hybrid** is automatic in modern OpenSSH 9.x
7. **Protect your private keys** - never share, proper permissions

---
---
---

# SSH Setup for GitHub

## Step 1: Generate Key

```bash
ssh-keygen -t ed25519 -C "redwan@example.com" -f ~/.ssh/github_ed25519
```

## Step 2: SSH Config

```bash
nano ~/.ssh/config
```

```ssh-config
# GitHub - redwan-cefalo
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_ed25519
    AddKeysToAgent yes
```

## Step 3: Add to Agent & Copy Key

```bash
ssh-add ~/.ssh/github_ed25519
cat ~/.ssh/github_ed25519.pub
```

## Step 4: Add to GitHub

Go to: **https://github.com/settings/keys**

Or directly: **https://github.com/<YOUR_USERNAME>/settings/keys** doesn't work - settings is always at root.

The flow:
1. https://github.com/redwan-cefalo → Your profile
2. Click avatar → Settings → SSH and GPG keys → New SSH key

## Step 5: Test

```bash
ssh -T git@github.com
```

Expected output:

```
Hi redwan-cefalo! You've successfully authenticated, but GitHub does not provide shell access.
```

## Step 6: Clone Repos with SSH

```bash
# Format: git@github.com:<USERNAME>/<REPO>.git

# Examples:
git clone git@github.com:redwan-cefalo/dotfiles.git
git clone git@github.com:redwan-cefalo/fyp25-agentic-caregivers.git

# Switch existing repo from HTTPS to SSH:
cd ~/Projects/myproject
git remote -v
# origin  https://github.com/redwan-cefalo/myproject.git (fetch)

git remote set-url origin git@github.com:redwan-cefalo/myproject.git
git remote -v
# origin  git@github.com:redwan-cefalo/myproject.git (fetch)
```

## Full Config Example

```ssh-config
# ═══════════════════════════════════════════════════
# SSH Config - ~/.ssh/config
# ═══════════════════════════════════════════════════

Host *
    AddKeysToAgent yes
    IdentitiesOnly yes
    ServerAliveInterval 60

# GitHub (redwan-cefalo)
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_ed25519

# GitLab (if used)
Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/gitlab_ed25519

# Work server
Host work
    HostName server.company.com
    User redwan
    IdentityFile ~/.ssh/work_ed25519
    Port 22

# Personal VPS
Host vps
    HostName 192.168.1.100
    User redwan
    IdentityFile ~/.ssh/vps_ed25519
```

Replace `redwan-cefalo` and `redwan` with your actual GitHub username and server username.
