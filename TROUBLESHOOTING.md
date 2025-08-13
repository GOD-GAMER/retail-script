# ?? TROUBLESHOOTING GUIDE - "Couldn't find resource retail_jobs"

## Quick Fix Checklist

### ? Step 1: Verify Folder Location
1. **Current Location**: `C:\Users\cabca\Downloads\retail clerk\`
2. **Required Location**: `[Your FiveM Server]/resources/retail_jobs/`

**Action Required:**
```bash
# Move and rename your folder
FROM: C:\Users\cabca\Downloads\retail clerk\
TO: [Your-FiveM-Server-Path]/resources/retail_jobs/
```

### ? Step 2: Check Folder Name
- ? **Wrong**: `retail clerk` (has space)
- ? **Correct**: `retail_jobs` (no spaces, exact match)

### ? Step 3: Verify File Structure
Your `retail_jobs` folder should contain:
```
retail_jobs/
??? fxmanifest.lua          ? Required
??? config.lua              ? Required
??? shared/
?   ??? utils.lua           ? Required
?   ??? startup.lua         ? Required
??? server/
?   ??? main.lua            ? Required
??? client/
?   ??? main.lua            ? Required
?   ??? customer_ai.lua     ? Required
?   ??? optimization.lua    ? Required
??? html/
    ??? index.html          ? Required
    ??? style.css           ? Required
    ??? script.js           ? Required
```

### ? Step 4: Update server.cfg
Add this line to your `server.cfg`:
```cfg
ensure retail_jobs
```

**Common server.cfg locations:**
- Windows: `[Server Folder]/server.cfg`
- Linux: `/opt/cfx-server/server.cfg`

### ? Step 5: Restart Server
1. Stop your FiveM server completely
2. Start it again
3. Check console for messages

## Expected Console Output

When working correctly, you should see:
```
[RETAIL JOBS] Resource loading started...
[RETAIL JOBS] Required file: config.lua
[RETAIL JOBS] Required file: shared/utils.lua
[RETAIL JOBS] Config loaded successfully
[RETAIL JOBS] Framework: standalone
[RETAIL JOBS] Store count: 4
[RETAIL JOBS] Shared utilities loaded successfully
[RETAIL JOBS] Resource verification complete!
Started resource retail_jobs
```

## Testing the Resource

Once loaded, test with these commands in server console:
```
# Check if resource is running
list

# Test the export function
lua exports.retail_jobs:testResource()
```

## Common Error Solutions

### Error: "Failed to load script"
**Cause**: File permissions or file corruption
**Solution**: 
1. Check file permissions (should be readable)
2. Re-download/copy files
3. Ensure no special characters in filenames

### Error: "Resource failed to start"
**Cause**: Syntax error in Lua files
**Solution**:
1. Enable debug mode in config.lua
2. Check server console for specific errors
3. Validate Lua syntax

### Error: "ensure retail_jobs not found"
**Cause**: Wrong folder name or location
**Solution**:
1. Verify exact folder name: `retail_jobs`
2. Check path: `resources/retail_jobs/`
3. Restart server after moving

## Debug Mode

Enable debug mode for detailed logging:

1. Open `config.lua`
2. Set `Config.Debug = true`
3. Restart resource
4. Check console for detailed messages

## Alternative Installation

If still having issues, try manual installation:

1. Create folder: `resources/retail_jobs/`
2. Copy each file individually
3. Verify each file exists and is readable
4. Start with minimal config (disable features if needed)

## Get Help

If none of these steps work:
1. Check your server.cfg syntax
2. Verify FiveM server version compatibility
3. Test with a minimal resource first
4. Check file permissions on server