# Microsoft Update Remover

This project provides a Zsh script to remove Microsoft AutoUpdate components from macOS. It lists the components, asks for user confirmation, and deletes them if confirmed.

## Features
- Lists Microsoft AutoUpdate components
- Asks for user confirmation before deletion
- Deletes specified components

## Usage
1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd microsoft-update-remover
   ```
3. Run the script with root privileges:
   ```bash
   sudo ./remove_ms_update.sh
   ```

## Components Removed
- `/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app`
- `/Library/LaunchAgents/com.microsoft.update.agent.plist`
- `/Library/LaunchDaemons/com.microsoft.autoupdate.helper.plist`
- `/Library/PrivilegedHelperTools/com.microsoft.autoupdate.helper`

## Note
If you want to update Microsoft Office in the future, you can manually download updates from Microsoft's website:
[Microsoft Office Updates](https://learn.microsoft.com/en-us/officeupdates/update-history-office-for-mac)
