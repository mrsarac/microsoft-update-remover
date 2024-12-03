#!/bin/zsh

# Check for root privileges
check_root() {
    if [ "$(id -u)" != "0" ]; then
        echo "This script requires root privileges."
        echo "Please run with 'sudo':"
        echo "sudo $0"
        exit 1
    fi
}

# Display file size in a human-readable format
get_size() {
    if [ -f "$1" ]; then
        size=$(du -h "$1" 2>/dev/null | cut -f1)
        echo "$size"
    elif [ -d "$1" ]; then
        size=$(du -sh "$1" 2>/dev/null | cut -f1)
        echo "$size"
    else
        echo "-"
    fi
}

# Show table header
show_table_header() {
    printf "%-3s | %-70s | %-10s | %s\n" "No" "File" "Status" "Size"
    printf "%s\n" "----+----------------------------------------------------------------------+------------+--------"
}

# Display all removable items in a table format
show_items() {
    echo "\nMicrosoft Update Components Check List:"
    
    show_table_header
    
    found_count=0
    i=1
    
    for file in "${files_to_remove[@]}"; do
        file_status=""
        file_size=""
        if [[ -e "$file" ]]; then
            file_status="[Exists]"
        else
            file_status="[Not Found]"
        fi
        file_size=$(get_size "$file")
        
        printf "%-3d | %-70s | %-10s | %s\n" "$i" "$file" "$file_status" "$file_size"
        
        if [[ "$file_status" == *"Exists"* ]]; then
            ((found_count++))
        fi
        ((i++))
    done
    
    echo "\nSummary:"
    echo "Total components: ${#files_to_remove[@]}"
    echo "Existing components: ${found_count}"
}

# Remove selected items
remove_items() {
    local success=0
    local failed=0
    
    echo "\nRemoving components...\n"
    
    show_table_header
    
    local i=1
    for file in "${files_to_remove[@]}"; do
        printf "%-3d | %-70s | " "$i" "$file"
        if sudo rm -rf "$file" 2>/dev/null; then
            printf "REMOVED\n"
            ((success++))
        else
            printf "ERROR\n"
            ((failed++))
        fi
        ((i++))
    done
    
    echo "\nResult:"
    echo "Successfully removed: $success"
    [ $failed -gt 0 ] && echo "Failed: $failed"
}

# Main function
main() {
    # Check for root privileges
    check_root
    
    # List of removable files
    files_to_remove=(
        "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app"
        "/Library/LaunchAgents/com.microsoft.update.agent.plist"
        "/Library/LaunchDaemons/com.microsoft.autoupdate.helper.plist"
        "/Library/PrivilegedHelperTools/com.microsoft.autoupdate.helper"
    )
    
    # Header
    echo "\nMicrosoft AutoUpdate Remover"
    echo "=================================="
    
    # File check prompt
    echo "\nCheck Microsoft Update components? (y/n)"
    read -r response
    if [[ ! "$response" =~ ^[YyEe]$ ]]; then
        echo "\nOperation cancelled."
        exit 0
    fi
    
    # Show items
    show_items
    
    # Deletion confirmation
    echo "\nRemove all existing Microsoft Update components? (y/n)"
    read -r response
    if [[ ! "$response" =~ ^[YyEe]$ ]]; then
        echo "\nOperation cancelled."
        exit 0
    fi
    
    # Remove selected items
    remove_items
    
    echo "\nOperation completed!"
    echo "\nNote: If you want to update Microsoft Office in the future,"
    echo "you can manually download updates from Microsoft's website:"
    echo "https://learn.microsoft.com/en-us/officeupdates/update-history-office-for-mac"
}

# Run the script
main