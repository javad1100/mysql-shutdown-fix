# Repair - MySQL shutdown unexpectedly

**Author:** Devyarn  
**Website:** [www.devyarn.com](https://www.devyarn.com)

---

## What is this?
A Windows batch script to safely **sync MySQL data folder with a backup** in XAMPP. It automates pre-backups, cleans old data, and restores selected files.

**Use this tool only when you see the following error in XAMPP:**

```
[mysql] Error: MySQL shutdown unexpectedly. 
[mysql] This may be due to a blocked port, missing dependencies, 
[mysql] improper privileges, a crash, or a shutdown by another method 
[mysql] Press the Logs button to view error logs and check 
[mysql] the Windows Event Viewer for more clues 
[mysql] If you need more help, copy and post this 
[mysql] entire log window on the forums.
```

---

## How it works

1. **Initial Warning:** Displays the MySQL shutdown error message and prompts the user to proceed.  
2. **XAMPP Path Input:** Prompts for the XAMPP root path (default: `C:\xampp`).  
3. **Pre-Backup:** Creates a timestamped pre-backup of the current MySQL `data` folder (skipping `ibdata1`).  
4. **Folder Cleanup:** Deletes folders in the `data` directory that exist in the backup.  
5. **File Cleanup:** Deletes files in the `data` folder except critical system files like `ibdata1`.  
6. **Restore from Backup:** Copies all files and folders from the backup folder into the `data` folder.  
7. **Old Backup Cleanup:** Keeps only the latest 3 pre-backups and deletes older ones automatically.  
8. **Summary Report:** Displays total deleted items, source backup folder, target data folder, and pre-backup location.  

**Note:** All deleted items are pre-backed up, so you can restore if needed.

---

## How to use it

1. Run the script.  
2. Read the warning and press Enter.  
3. Enter your XAMPP root path (or press Enter to use `C:\xampp`).  
4. The script will automatically backup, clean, restore, and manage older pre-backups.  
5. Review the summary report after completion.

---

## Safety Notes

- Critical files like `ibdata1` are never deleted.  
- Ensure the backup folder contains valid MySQL database copies.  
- Do not run on live production servers without testing.  
- Avoid modifying system files while MySQL is running.

---

## More Tools & Solutions

Explore other professional scripts at [Devyarn](https://www.devyarn.com).

---

## Repository Name Suggestion

**Recommended GitHub repo name:** `xampp-mysql-repair`  
This is short, professional, and easy for developers to find when searching for MySQL repair tools.