# Centralized Theme System

Purpose-driven themes for intentional workflows. Each theme is designed for a specific activity or time of day.

## 🎯 Philosophy

These aren't just color schemes - they're **workflow tools**. Each theme is crafted with a specific purpose, optimizing your environment for different types of work.

## 🎨 Available Themes

### 🧠 Deep Focus
**When:** Complex problems requiring intense concentration
**Purpose:** Monochromatic design eliminates color distractions
**Best For:**
- Deep work sessions (2-4 hours)
- Complex debugging
- Architecture planning
- Algorithm design

**Why It Works:** Reduces cognitive load by removing color variety. Your brain processes fewer visual stimuli, leaving more capacity for the problem at hand.

---

### 👁️ Code Review
**When:** Reviewing pull requests and diffs
**Purpose:** Maximizes change visibility with high-contrast diff colors
**Best For:**
- Git diff viewing
- Pull request reviews
- Merge conflict resolution
- Change detection

**Why It Works:** Enhanced green/red contrast makes additions and deletions immediately obvious. Yellow for warnings stands out clearly.

---

### 🌙 Night Owl
**When:** Late night coding (8PM-2AM)
**Purpose:** Low blue light emission preserves circadian rhythm
**Best For:**
- Late night sessions
- Reducing eye strain
- Preserving sleep cycle
- Extended evening work

**Why It Works:** Warm amber tones reduce blue light exposure, minimizing melatonin suppression. You'll sleep better after late coding sessions.

---

### ☀️ Morning Boost
**When:** Morning productivity (6AM-12PM)
**Purpose:** Energizing bright colors kickstart your day
**Best For:**
- Morning coding
- Planning sessions
- Creative work
- High-energy tasks

**Why It Works:** Vibrant colors promote alertness. Light background leverages natural morning light for energy.

---

### ♿ Accessibility Plus
**When:** Bright environments or vision needs
**Purpose:** WCAG AAA compliant maximum contrast
**Best For:**
- Bright offices
- Screen sharing
- Presentations
- Vision accessibility
- Outdoor coding

**Why It Works:** Exceeds WCAG AAA standards for contrast. Readable in any lighting condition.

---

### 🖥️ Terminal Native
**When:** CLI-heavy workflows and DevOps
**Purpose:** Optimized for shell output and log parsing
**Best For:**
- DevOps work
- System administration
- Log analysis
- SSH sessions
- Server management

**Why It Works:** Enhanced colors for common terminal outputs (errors, success, warnings). Makes log parsing easier.

---

### 🎨 Minimalist Mono
**When:** Writing documentation or reading code
**Purpose:** Pure grayscale for zero visual noise
**Best For:**
- Documentation writing
- Reading/studying code
- Absolute focus
- Meditative coding

**Why It Works:** Complete absence of color eliminates all visual distractions. Forces focus on structure and content.

---

### 🌊 Zen Mode
**When:** Refactoring and thoughtful design
**Purpose:** Calming earth tones reduce stress
**Best For:**
- Refactoring
- Architecture design
- Thoughtful coding
- Stress reduction
- Long sessions

**Why It Works:** Inspired by Japanese tea room aesthetics. Muted earth tones promote calm, sustained focus without fatigue.

---

### ⚡ Synthwave Energy
**When:** Creative projects and experiments
**Purpose:** Retro-futuristic aesthetics inspire innovation
**Best For:**
- Creative coding
- Hackathons
- Experimental projects
- Side projects
- Innovation sessions

**Why It Works:** Neon colors create an energizing, playful atmosphere. Encourages creative thinking and experimentation.

---

### 🐛 Debugging Mode
**When:** Hunting bugs and analyzing errors
**Purpose:** High contrast for error spotting
**Best For:**
- Active debugging
- Stack trace analysis
- Error investigation
- Test failure diagnosis

**Why It Works:** Enhanced red/yellow for errors and warnings. Makes problems jump out visually for faster identification.

---

### 🌸 Sakura (Dark/Light)
**When:** General purpose with aesthetic preference
**Purpose:** Your current beloved theme
**Best For:**
- Default daily use
- Aesthetic enjoyment
- General coding

---

## 🚀 Usage

### List All Themes
```bash
cd ~/.dotfiles
./scripts/switch-theme.sh list
```

### Apply By Purpose
```bash
# Starting deep work session
./scripts/switch-theme.sh deep-focus alacritty

# About to review PRs
./scripts/switch-theme.sh code-review ghostty

# Late night coding
./scripts/switch-theme.sh night-owl all

# Morning productivity
./scripts/switch-theme.sh morning-boost all

# Debugging a critical issue
./scripts/switch-theme.sh debugging-mode alacritty
```

### Different Themes Per Tool
```bash
# Terminal for deep focus, editor for code review
./scripts/switch-theme.sh deep-focus alacritty
./scripts/switch-theme.sh code-review ghostty
```

## 💡 Workflow Examples

### Morning Developer
```bash
# 7 AM - Start with energy
./scripts/switch-theme.sh morning-boost all

# 10 AM - Deep focus on complex feature
./scripts/switch-theme.sh deep-focus all

# 2 PM - PR review time
./scripts/switch-theme.sh code-review all

# 4 PM - Debugging production issue
./scripts/switch-theme.sh debugging-mode all

# 9 PM - Late evening refactor
./scripts/switch-theme.sh night-owl all
```

### DevOps Engineer
```bash
# Terminal for system work
./scripts/switch-theme.sh terminal-native alacritty

# Editor for code changes
./scripts/switch-theme.sh code-review ghostty
```

### Open Source Maintainer
```bash
# Review PRs
./scripts/switch-theme.sh code-review all

# Deep architectural work
./scripts/switch-theme.sh zen-mode all

# Write documentation
./scripts/switch-theme.sh minimalist-mono all
```

## 🎯 Choosing The Right Theme

**Ask yourself:**
1. **What time is it?** → Morning Boost / Night Owl
2. **What am I doing?** → Match the purpose
3. **How long will I work?** → Zen Mode / Deep Focus for long sessions
4. **What's my energy level?** → Synthwave Energy / Minimalist Mono
5. **Where am I?** → Accessibility Plus for bright environments

## 🛠️ Creating Your Own Purpose-Driven Theme

Think about your workflow:
1. **Identify a specific activity** (not just "coding")
2. **Define the goal** (focus? energy? calm?)
3. **Choose colors intentionally** based on psychology
4. **Test in real scenarios**
5. **Iterate based on effectiveness**

### Color Psychology Guide
- **Blue:** Calm, trust, productivity
- **Red:** Urgency, errors, action
- **Green:** Success, calm, nature
- **Yellow:** Warning, energy, attention
- **Gray:** Neutral, minimal distraction
- **Warm tones:** Comfort, reduce blue light
- **Cool tones:** Energy, alertness

## 📝 Tips

### 1. Match Theme to Task
Don't use Synthwave Energy for debugging. Don't use Minimalist Mono for creative work. Each theme has a purpose.

### 2. Time-Based Switching
```bash
# Add to your shell config
alias theme-morning='~/.dotfiles/scripts/switch-theme.sh morning-boost all'
alias theme-night='~/.dotfiles/scripts/switch-theme.sh night-owl all'
alias theme-focus='~/.dotfiles/scripts/switch-theme.sh deep-focus all'
```

### 3. Activity Aliases
```bash
alias start-review='~/.dotfiles/scripts/switch-theme.sh code-review all'
alias start-debug='~/.dotfiles/scripts/switch-theme.sh debugging-mode all'
alias start-zen='~/.dotfiles/scripts/switch-theme.sh zen-mode all'
```

### 4. Experiment
Try each theme for its intended purpose. Notice how it affects your work. Adjust your workflow accordingly.

## 🧪 Scientific Backing

- **Monochrome for focus:** Research shows reduced color variety improves concentration
- **Warm tones at night:** Reduces blue light exposure, preserves melatonin production
- **High contrast for errors:** Pre-attentive processing makes red stand out automatically
- **Earth tones for calm:** Studies show natural colors reduce stress and cortisol

## 📚 Resources

- [Color Psychology in Design](https://www.toptal.com/designers/ux/color-in-ux)
- [Blue Light and Sleep](https://www.health.harvard.edu/staying-healthy/blue-light-has-a-dark-side)
- [Focus and Distraction Research](https://www.nature.com/articles/s41562-019-0680-1)

---

**Remember:** These themes are tools, not decorations. Use them intentionally to enhance your workflow.
