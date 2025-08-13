# ?? GitHub Repository Setup & Release Guide

## Step 1: Create GitHub Repository

1. **Go to GitHub**: Navigate to https://github.com/GOD-GAMER
2. **Create New Repository**:
   - Repository name: `retail-script`
   - Description: `Advanced FiveM Retail and Fast Food Job System with Corporate Ladder`
   - Set to **Public**
   - ? Add README file
   - ? Add .gitignore (choose "Node" template, we'll replace it)
   - ? Choose MIT License

## Step 2: Prepare Your Local Files

### Current Structure Fix
Your files are currently in: `C:\Users\cabca\Downloads\retail clerk\`

**Required Actions:**
1. **Create a new folder**: `C:\Users\cabca\Downloads\retail-script\`
2. **Copy all files** from `retail clerk` to `retail-script`
3. **Ensure the structure looks like this**:
```
retail-script/
??? .github/
?   ??? ISSUE_TEMPLATE/
?   ??? workflows/
??? client/
??? server/
??? shared/
??? html/
??? fxmanifest.lua
??? config.lua
??? README.md
??? LICENSE
??? CHANGELOG.md
??? CONTRIBUTING.md
??? .gitignore
??? [other files]
```

## Step 3: Initialize Git Repository

Open **Command Prompt** or **PowerShell** in your `retail-script` folder:

```bash
# Navigate to your folder
cd "C:\Users\cabca\Downloads\retail-script"

# Initialize git repository
git init

# Add the remote repository
git remote add origin https://github.com/GOD-GAMER/retail-script.git

# Add all files
git add .

# Make initial commit
git commit -m "Initial release v0.0.2 - Complete retail job system"

# Push to GitHub
git push -u origin main
```

## Step 4: Create Release v0.0.2

### Method 1: GitHub Web Interface (Recommended)

1. **Go to your repository**: https://github.com/GOD-GAMER/retail-script
2. **Click "Releases"** in the right sidebar
3. **Click "Create a new release"**
4. **Fill in the release form**:
   - **Tag version**: `v0.0.2`
   - **Release title**: `?? FiveM Retail Jobs Script v0.0.2`
   - **Description**: Copy content from `RELEASE_NOTES.md`
   - **Upload files**: Create a zip of your `retail-script` folder and upload as `retail_jobs-v0.0.2.zip`

### Method 2: GitHub CLI (Alternative)

If you have GitHub CLI installed:
```bash
# Create release
gh release create v0.0.2 --title "?? FiveM Retail Jobs Script v0.0.2" --notes-file RELEASE_NOTES.md

# Upload release asset
gh release upload v0.0.2 retail_jobs-v0.0.2.zip
```

## Step 5: Create the Release Package

### Manual Method:
1. **Create a new folder**: `retail_jobs`
2. **Copy these files/folders** into `retail_jobs`:
   ```
   retail_jobs/
   ??? fxmanifest.lua
   ??? config.lua
   ??? database.sql
   ??? README.md
   ??? CHANGELOG.md
   ??? TROUBLESHOOTING.md
   ??? shared/
   ??? server/
   ??? client/
   ??? html/
   ```
3. **Create ZIP file**: Right-click `retail_jobs` folder ? "Send to" ? "Compressed folder"
4. **Rename**: `retail_jobs.zip` ? `retail_jobs-v0.0.2.zip`

### PowerShell Method:
```powershell
# Create retail_jobs folder and copy files
New-Item -ItemType Directory -Path "retail_jobs" -Force

# Copy required files (exclude git and github folders)
$exclude = @(".git", ".github", "*.zip")
Get-ChildItem -Path "." | Where-Object { $_.Name -notin $exclude } | Copy-Item -Destination "retail_jobs" -Recurse -Force

# Create ZIP file
Compress-Archive -Path "retail_jobs" -DestinationPath "retail_jobs-v0.0.2.zip" -Force
```

## Step 6: Repository Settings (Optional)

### Enable Discussions
1. Go to repository **Settings**
2. Scroll to **Features**
3. ? Enable **Discussions**

### Add Topics
1. Go to repository main page
2. Click **?? gear icon** next to "About"
3. Add topics: `fivem`, `lua`, `retail`, `jobs`, `rp`, `roleplay`, `gta5`

### Set up Branch Protection (Optional)
1. Go to **Settings** ? **Branches**
2. Add rule for `main` branch
3. ? Require pull request reviews

## Step 7: Verify Everything Works

### Check Repository Structure
Visit https://github.com/GOD-GAMER/retail-script and verify:
- ? All files are present
- ? README displays correctly
- ? License is visible
- ? Release v0.0.2 exists
- ? Release has downloadable ZIP file

### Test Download
1. Download the release ZIP
2. Extract it
3. Verify folder structure is correct
4. Test in FiveM server

## Step 8: Share Your Release

### Create Announcement
Share on:
- FiveM Forums
- Discord servers
- Reddit (r/FiveM)
- Social media

### Example Announcement:
```
?? NEW RELEASE: FiveM Retail Jobs Script v0.0.2

? Complete retail and fast food job system
?? 10-tier corporate ladder progression  
?? Advanced NPC customer AI
? Multi-framework support (ESX/QBCore/Standalone)
?? Modern UI interface

Download: https://github.com/GOD-GAMER/retail-script/releases/tag/v0.0.2

#FiveM #RetailJobs #Roleplay
```

## Troubleshooting

### Common Issues:

**Git not recognized**
- Install Git from https://git-scm.com/

**Permission denied**
- Use GitHub Desktop or authenticate with personal access token

**Files not uploading**
- Check file size limits (100MB per file)
- Use Git LFS for large files

**Release not creating**
- Ensure you're on the main branch
- Check that tag doesn't already exist

## Next Steps

After your release is live:
1. **Monitor Issues**: Watch for bug reports
2. **Engage Community**: Respond to questions and feedback  
3. **Plan Updates**: Use feedback to plan v0.0.3
4. **Documentation**: Consider creating a Wiki
5. **Marketing**: Share in FiveM communities

---

?? **Your repository will be live at**: https://github.com/GOD-GAMER/retail-script  
?? **Download link**: https://github.com/GOD-GAMER/retail-script/releases/tag/v0.0.2