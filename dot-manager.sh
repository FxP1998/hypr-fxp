#!/usr/bin/env bash
# AUTHOR: M. H. IMAM (FxP1998)
# GITHUB: https://github.com/FxP1998

# --- DYNAMIC CONFIGURATION ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR" 
CONFIG_FILE="$SCRIPT_DIR/.dot-manager.conf"
LOG_FILE="$SCRIPT_DIR/dot-manager.log"

GITHUB_REMOTE="origin"
BRANCH="main"  # Default, will be detected/set during setup

# --- TTY-COMPATIBLE COLORS ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'  # No Color

# --- TTY TEXT ICONS ---
# Pure ASCII/Text indicators for maximum compatibility
ICON_GIT="[GIT]"       
ICON_UPLOAD="[UP]"    
ICON_PUSH="[PUSH]"
ICON_UNDO="[UNDO]"      
ICON_FIX="[FIX]"       
ICON_REFRESH="[RELOAD]"   
ICON_KEY="[KEY]"       
ICON_OK="[OK]"        
ICON_FAIL="[FAIL]"      
ICON_DANGER="[WARN]"    
ICON_REPAIR="[REPAIR]"     
ICON_CONFIG="[CONF]"     
ICON_LOG="[LOG]"        
ICON_GITHUB="[GITHUB]"
ICON_HOME="[HOME]"       
ICON_INFO="[INFO]"       
ICON_QUESTION="[?]"   
ICON_STAR="*"
ICON_PULL="[DOWN]"
ICON_BRANCH="[BR]"
ICON_SYNC="[SYNC]"

# --- DEPENDENCY CHECK ---
check_dependencies() {
    local missing=0
    for cmd in git stow; do
        if ! command -v "$cmd" &> /dev/null; then
            echo -e "${RED}${ICON_FAIL} Error: '$cmd' is not installed.${NC}"
            missing=1
        fi
    done
    if [ $missing -eq 1 ]; then
        echo -e "${YELLOW}Please install missing dependencies first.${NC}"
        exit 1
    fi
}

# --- LOGGING ---
init_log() {
    [[ ! -f "$LOG_FILE" ]] && touch "$LOG_FILE" && echo "# Dot-Manager Log File" > "$LOG_FILE"
    echo "=== Session started at $(date) ===" >> "$LOG_FILE"
}
log_msg() {
    local msg="$1"
    # Improved regex to strip ANSI color codes for the log file
    local clean_msg=$(echo "$msg" | sed 's/\x1b\[[0-9;]*m//g')
    echo -e "$msg"
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $clean_msg" >> "$LOG_FILE"
}

# --- CONFIG ENGINE ---
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then 
        source "$CONFIG_FILE"
        # Ensure PACKAGE_NAME is valid
        if [[ ! -d "$DOTFILES_DIR/$PACKAGE_NAME" ]]; then
            echo -e "${YELLOW}${ICON_INFO} Package '$PACKAGE_NAME' not found.${NC}"
            reconfigure_package
        fi
    fi
    
    if [[ -z "$PACKAGE_NAME" ]] || [[ ! -d "$DOTFILES_DIR/$PACKAGE_NAME" ]]; then
        # Auto-detect folder logic
        if [[ -d "$DOTFILES_DIR/Dotfiles" ]]; then
            PACKAGE_NAME="Dotfiles"
            echo "PACKAGE_NAME=\"$PACKAGE_NAME\"" > "$CONFIG_FILE"
            log_msg "${GREEN}${ICON_OK} Auto-detected package: $PACKAGE_NAME${NC}"
        else
            reconfigure_package
        fi
    fi
}

reconfigure_package() {
    echo -e "${BLUE}${ICON_CONFIG} DOTFILES SETUP WIZARD${NC}"
    echo -e "${CYAN}----------------------------------------------${NC}"
    
    mapfile -t options < <(find . -maxdepth 1 -type d -not -path '*/.*' -not -name 'scripts' -not -name 'Note' -not -name '.' -printf '%P\n')
    
    if [ ${#options[@]} -eq 0 ]; then
        log_msg "${RED}${ICON_FAIL} ERROR: No config subdirectory found!${NC}"
        echo -e "${YELLOW}Please create a folder for your dotfiles first (e.g., 'Dotfiles').${NC}"
        read -p "Press Enter to exit..." && exit 1
    fi
    
    echo -e "${BLUE}Available dotfiles folders:${NC}"
    echo ""
    local i=1
    for opt in "${options[@]}"; do 
        echo -e "  ${GREEN}$i)${NC} $opt"
        ((i++))
    done
    
    echo -e "\n${YELLOW}${ICON_QUESTION} Select folder number (1-$((i-1))):${NC}"
    while true; do
        read -p "> " selection
        if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le $((i-1)) ]; then
            local idx=$((selection-1))
            PACKAGE_NAME="${options[$idx]}"
            echo "PACKAGE_NAME=\"$PACKAGE_NAME\"" > "$CONFIG_FILE"
            log_msg "${GREEN}${ICON_OK} Linked to package: '$PACKAGE_NAME'${NC}"
            break
        else
            echo -e "${RED}${ICON_FAIL} Invalid selection. Please enter a number between 1 and $((i-1)).${NC}"
        fi
    done
}

# --- GIT FUNCTIONS ---
check_status() {
    if [[ ! -d ".git" ]]; then 
        echo -e "${RED}${ICON_FAIL} Not a git repository!${NC}"
        echo -e "${YELLOW}Run option 12 to initialize git repository.${NC}"
        return 1
    fi
    
    echo -e "${BLUE}${ICON_GIT} Repository Status:${NC}"
    echo -e "${CYAN}----------------------------------------------${NC}"
    
    # Show current branch
    current_branch=$(git branch --show-current 2>/dev/null || echo "none")
    echo -e "  Branch: ${GREEN}$current_branch${NC}"
    
    # Show remote
    remote_url=$(git remote get-url "$GITHUB_REMOTE" 2>/dev/null || echo "none")
    echo -e "  Remote: ${CYAN}$remote_url${NC}"
    
    echo -e "\n${BLUE}Changes:${NC}"
    changes=$(git status -s)
    if [[ -z "$changes" ]]; then
        echo -e "  ${GREEN}${ICON_OK} Working directory clean${NC}"
    else
        git status -s
    fi
}

check_git_identity() {
    current_name=$(git config user.name)
    current_email=$(git config user.email)
    
    if [[ -z "$current_name" || -z "$current_email" ]]; then
        echo -e "${YELLOW}${ICON_INFO} Git identity setup${NC}"
        echo -e "${CYAN}----------------------------------------------${NC}"
        
        if [[ -z "$current_name" ]]; then
            echo -e "${BLUE}Enter your name (for git commits):${NC}"
            echo -e "${YELLOW}Example: John Doe${NC}"
            read -p "> " input_name
            [[ -n "$input_name" ]] && git config --global user.name "$input_name"
        fi
        
        if [[ -z "$current_email" ]]; then
            echo -e "\n${BLUE}Enter your email (for git commits):${NC}"
            echo -e "${YELLOW}Example: john@example.com${NC}"
            read -p "> " input_email
            [[ -n "$input_email" ]] && git config --global user.email "$input_email"
        fi
        
        log_msg "${GREEN}${ICON_OK} Git identity configured${NC}"
    fi
}

# --- SSH/REMOTE FUNCTIONS ---
ensure_ssh_url() {
    remote_url=$(git remote get-url "$GITHUB_REMOTE" 2>/dev/null || echo "")
    
    if [[ -n "$remote_url" ]]; then
        # Convert HTTPS URL to SSH if detected
        if [[ "$remote_url" =~ ^https://github.com/ ]]; then
            echo -e "${YELLOW}${ICON_INFO} Converting HTTPS URL to SSH...${NC}"
            repo_path=$(echo "$remote_url" | sed -E 's|https://github.com/||' | sed 's|\.git$||')
            new_url="git@github.com:$repo_path.git"
            git remote set-url "$GITHUB_REMOTE" "$new_url"
            log_msg "${GREEN}${ICON_OK} Remote URL updated to: $new_url${NC}"
            return 0
        elif [[ "$remote_url" =~ ^git@github\.com: ]]; then
            return 0  # Already SSH
        else
            echo -e "${RED}${ICON_FAIL} Unknown remote URL format: $remote_url${NC}"
            return 1
        fi
    fi
    return 1
}

# --- PULL FROM REMOTE ---
pull_from_remote() {
    if [[ ! -d ".git" ]]; then
        echo -e "${RED}${ICON_FAIL} Not a git repository!${NC}"
        return 1
    fi
    
    echo -e "${BLUE}${ICON_PULL} PULL FROM GITHUB${NC}"
    echo -e "${CYAN}----------------------------------------------${NC}"
    
    ensure_ssh_url
    
    echo -e "${BLUE}Pulling latest changes from $BRANCH branch...${NC}"
    
    # Check if there are local changes
    if [[ -n "$(git status --porcelain)" ]]; then
        echo -e "${YELLOW}${ICON_INFO} You have local changes that might conflict.${NC}"
        echo -e "Options:"
        echo -e "  ${GREEN}1)${NC} Stash changes, pull, then apply stash"
        echo -e "  ${GREEN}2)${NC} Pull and try to merge automatically"
        echo -e "  ${GREEN}3)${NC} Cancel"
        
        read -p "Select: " pull_opt
        
        case $pull_opt in
            1)
                echo -e "${BLUE}Stashing local changes...${NC}"
                git stash
                git pull origin "$BRANCH"
                echo -e "${BLUE}Applying stashed changes...${NC}"
                git stash pop
                ;;
            2)
                git pull origin "$BRANCH"
                ;;
            *)
                echo -e "${YELLOW}Cancelled.${NC}"
                return 1
                ;;
        esac
    else
        git pull origin "$BRANCH"
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}${ICON_OK} Successfully pulled latest changes.${NC}"
        return 0
    else
        echo -e "${RED}${ICON_FAIL} Pull failed due to conflicts.${NC}"
        echo -e "${YELLOW}You need to resolve conflicts manually.${NC}"
        return 1
    fi
}

# --- SYNC WITH REMOTE (PULL THEN PUSH) ---
sync_with_remote() {
    if [[ ! -d ".git" ]]; then
        echo -e "${RED}${ICON_FAIL} Not a git repository!${NC}"
        return 1
    fi
    
    echo -e "${BLUE}${ICON_SYNC} SYNC WITH GITHUB${NC}"
    echo -e "${CYAN}----------------------------------------------${NC}"
    
    ensure_ssh_url
    
    # First pull
    echo -e "${BLUE}Step 1: Pulling latest changes...${NC}"
    if ! pull_from_remote; then
        echo -e "${RED}${ICON_FAIL} Sync aborted due to pull failure.${NC}"
        return 1
    fi
    
    # Check if there are changes to push
    if [[ -z "$(git status --porcelain)" ]]; then 
        echo -e "${GREEN}${ICON_OK} Already up to date with remote.${NC}"
        return 0
    fi
    
    echo -e "\n${BLUE}Step 2: Pushing changes...${NC}"
    echo -e "${BLUE}Changes to be pushed:${NC}"
    git status -s
    echo ""
    
    read -p "Push changes? (y/n): " confirm
    if [[ "${confirm,,}" != "y" ]]; then
        echo -e "${YELLOW}Cancelled.${NC}"
        return 0
    fi

    git add .
    
    echo -e "${BLUE}Enter commit message:${NC}"
    echo -e "${YELLOW}Example: 'Update dotfiles'${NC}"
    read -p "> " msg
    
    git commit -m "${msg:-Update dotfiles}"
    
    echo -e "\n${BLUE}Pushing to GitHub...${NC}"
    if git push origin "$BRANCH" 2>&1; then
        echo -e "${GREEN}${ICON_OK} Sync completed successfully!${NC}"
        return 0
    else
        echo -e "${RED}${ICON_FAIL} Push failed.${NC}"
        echo -e "${YELLOW}You may need to resolve conflicts.${NC}"
        return 1
    fi
}

setup_ssh() {
    clear
    echo -e "${BLUE}${ICON_KEY} SSH KEY SETUP WIZARD${NC}"
    echo -e "${CYAN}----------------------------------------------${NC}"
    echo ""
    
    # Check for existing SSH agent
    if [[ -z "$SSH_AUTH_SOCK" ]]; then
        echo -e "${YELLOW}${ICON_INFO} Starting SSH agent...${NC}"
        eval "$(ssh-agent -s)" > /dev/null 2>&1
    fi
    
    # Check existing keys
    echo -e "${BLUE}Checking existing SSH keys...${NC}"
    existing_keys=$(ls ~/.ssh/id_*.pub 2>/dev/null)
    
    if [[ -n "$existing_keys" ]]; then
        echo -e "${GREEN}Found existing SSH keys:${NC}"
        i=1
        declare -A key_map
        for key in $existing_keys; do
            key_map[$i]=$key
            echo -e "  ${GREEN}$i)${NC} $key"
            ((i++))
        done
        
        echo -e "\n  ${GREEN}$i)${NC} Create new SSH key"
        echo -e "  ${GREEN}$((i+1)))${NC} Cancel"
        
        read -p "Select option: " key_choice
        
        if [[ "$key_choice" =~ ^[0-9]+$ ]]; then
            if [ "$key_choice" -eq "$i" ]; then
                # Create new key
                KEY_FILE=""
            elif [ "$key_choice" -eq $((i+1)) ]; then
                return
            elif [ "$key_choice" -lt "$i" ]; then
                KEY_FILE="${key_map[$key_choice]%.pub}"
                echo -e "${GREEN}${ICON_OK} Using existing key: $KEY_FILE${NC}"
                
                # Add to SSH agent if not already
                ssh-add "$KEY_FILE" 2>/dev/null
                
                # Show public key
                echo -e "\n${BLUE}Public key:${NC}"
                echo -e "${CYAN}----------------------------------------------${NC}"
                cat "${KEY_FILE}.pub"
                echo -e "${CYAN}----------------------------------------------${NC}"
                
                echo -e "\n${YELLOW}${ICON_INFO} To add this key to GitHub:${NC}"
                echo -e "1. Go to ${CYAN}https://github.com/settings/ssh/new${NC}"
                echo -e "2. Paste the key above"
                echo -e "3. Click 'Add SSH key'"
                
                read -p "Press Enter to continue..."
                return
            fi
        fi
    fi
    
    # Create new key
    echo -e "${BLUE}Creating new SSH key...${NC}"
    echo -e "\n${YELLOW}Choose key type:${NC}"
    echo -e "  ${GREEN}1)${NC} ed25519 ${CYAN}(Recommended - Faster, more secure)${NC}"
    echo -e "  ${GREEN}2)${NC} rsa-4096 ${CYAN}(Compatible with older systems)${NC}"
    
    read -p "Select [1]: " key_type
    key_type=${key_type:-1}
    
    key_email=$(git config user.email 2>/dev/null)
    if [[ -z "$key_email" ]]; then
        echo -e "\n${BLUE}Enter email for the key (optional):${NC}"
        echo -e "${YELLOW}Example: your-email@example.com${NC}"
        read -p "> " key_email
    fi
    
    if [[ "$key_type" == "2" ]]; then
        KEY_FILE="$HOME/.ssh/id_rsa"
        if [[ -f "$KEY_FILE" ]]; then
            echo -e "${YELLOW}Key already exists. Overwrite? (y/n):${NC}"
            read -p "> " overwrite
            if [[ "${overwrite,,}" != "y" ]]; then
                echo -e "${YELLOW}Cancelled.${NC}"
                return
            fi
        fi
        ssh-keygen -t rsa -b 4096 -C "${key_email:-$(whoami)@$(hostname)}" -f "$KEY_FILE" -N ""
    else
        KEY_FILE="$HOME/.ssh/id_ed25519"
        if [[ -f "$KEY_FILE" ]]; then
            echo -e "${YELLOW}Key already exists. Overwrite? (y/n):${NC}"
            read -p "> " overwrite
            if [[ "${overwrite,,}" != "y" ]]; then
                echo -e "${YELLOW}Cancelled.${NC}"
                return
            fi
        fi
        ssh-keygen -t ed25519 -C "${key_email:-$(whoami)@$(hostname)}" -f "$KEY_FILE" -N ""
    fi
    
    # Add to SSH agent
    ssh-add "$KEY_FILE" 2>/dev/null
    
    echo -e "\n${GREEN}${ICON_OK} SSH key created successfully!${NC}"
    echo -e "\n${BLUE}Your public key:${NC}"
    echo -e "${CYAN}----------------------------------------------${NC}"
    cat "${KEY_FILE}.pub"
    echo -e "${CYAN}----------------------------------------------${NC}"
    
    echo -e "\n${YELLOW}${ICON_INFO} Next steps:${NC}"
    echo -e "1. Copy the key above"
    echo -e "2. Go to ${CYAN}https://github.com/settings/ssh/new${NC}"
    echo -e "3. Paste and save"
    echo -e "4. Test with: ${GREEN}ssh -T git@github.com${NC}"
    
    read -p "Press Enter when ready..."
}

setup_github_repo() {
    clear
    echo -e "${BLUE}${ICON_GITHUB} GITHUB REPOSITORY SETUP${NC}"
    echo -e "${CYAN}----------------------------------------------${NC}"
    echo ""
    
    # Check if already a git repo
    if [[ -d ".git" ]]; then
        echo -e "${YELLOW}${ICON_INFO} Git repository already exists.${NC}"
        
        current_remote=$(git remote get-url "$GITHUB_REMOTE" 2>/dev/null || echo "")
        if [[ -n "$current_remote" ]]; then
            echo -e "Current remote: ${CYAN}$current_remote${NC}"
            echo -e "\n${YELLOW}Options:${NC}"
            echo -e "  ${GREEN}1)${NC} Keep current remote"
            echo -e "  ${GREEN}2)${NC} Change remote URL"
            echo -e "  ${GREEN}3)${NC} Cancel"
            
            read -p "Select: " opt
            case $opt in
                2)
                    read -p "Enter new SSH URL: " new_url
                    if [[ -n "$new_url" ]]; then
                        git remote set-url "$GITHUB_REMOTE" "$new_url"
                        echo -e "${GREEN}${ICON_OK} Remote URL updated.${NC}"
                    fi
                    ;;
                3) return ;;
            esac
        fi
        
        # Ensure SSH URL
        ensure_ssh_url
        return
    fi
    
    # Initialize git repository
    echo -e "${BLUE}Initializing git repository...${NC}"
    git init
    
    # Set git identity
    check_git_identity
    
    # Choose branch name
    echo -e "\n${BLUE}Choose default branch name:${NC}"
    echo -e "  ${GREEN}1)${NC} main ${CYAN}(GitHub default)${NC}"
    echo -e "  ${GREEN}2)${NC} master ${CYAN}(Legacy default)${NC}"
    echo -e "  ${GREEN}3)${NC} Custom name"
    
    read -p "Select [1]: " branch_opt
    branch_opt=${branch_opt:-1}
    
    case $branch_opt in
        1) BRANCH="main" ;;
        2) BRANCH="master" ;;
        3) 
            read -p "Enter branch name: " custom_branch
            BRANCH="${custom_branch:-main}"
            ;;
    esac
    
    git branch -M "$BRANCH"
    echo -e "${GREEN}${ICON_OK} Branch set to: $BRANCH${NC}"
    
    # Add remote
    echo -e "\n${BLUE}GitHub Repository URL${NC}"
    echo -e "${YELLOW}Enter your GitHub repository SSH URL:${NC}"
    echo -e "Format: ${GREEN}git@github.com:USERNAME/REPOSITORY.git${NC}"
    echo -e "Example: ${CYAN}git@github.com:FxP1998/hypr-fxp.git${NC}"
    echo -e "\nIf you don't have a repository yet:"
    echo -e "1. Create at ${CYAN}https://github.com/new${NC}"
    echo -e "2. DO NOT initialize with README"
    echo -e "3. Copy the SSH URL"
    echo ""
    
    read -p "SSH URL (press Enter to skip): " repo_url
    
    if [[ -n "$repo_url" ]]; then
        # Validate SSH URL format
        if [[ ! "$repo_url" =~ ^git@github\.com: ]]; then
            echo -e "${RED}${ICON_FAIL} Invalid SSH URL format!${NC}"
            echo -e "${YELLOW}Must start with: git@github.com:${NC}"
            read -p "Try again? (y/n): " retry
            if [[ "${retry,,}" == "y" ]]; then
                setup_github_repo
                return
            fi
        else
            git remote add origin "$repo_url"
            echo -e "${GREEN}${ICON_OK} Remote added: $repo_url${NC}"
            
            # Test connection
            echo -e "\n${BLUE}${ICON_INFO} Testing SSH connection...${NC}"
            if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
                echo -e "${GREEN}${ICON_OK} SSH connection successful!${NC}"
                
                # Check if remote has commits
                echo -e "\n${BLUE}${ICON_INFO} Checking remote repository...${NC}"
                if git ls-remote --exit-code origin "$BRANCH" &>/dev/null; then
                    echo -e "${YELLOW}${ICON_INFO} Remote repository has existing commits.${NC}"
                    echo -e "Choose option:"
                    echo -e "  ${GREEN}1)${NC} Pull and merge remote changes"
                    echo -e "  ${GREEN}2)${NC} Force push (overwrite remote)"
                    echo -e "  ${GREEN}3)${NC} Skip for now"
                    
                    read -p "Select: " remote_opt
                    case $remote_opt in
                        1)
                            echo -e "${BLUE}Pulling from remote...${NC}"
                            git pull origin "$BRANCH" --allow-unrelated-histories
                            ;;
                        2)
                            echo -e "${YELLOW}${ICON_DANGER} This will overwrite remote repository!${NC}"
                            read -p "Type 'OVERWRITE' to confirm: " confirm
                            if [[ "$confirm" == "OVERWRITE" ]]; then
                                git add .
                                git commit -m "Initial commit" || true
                                git push -u origin "$BRANCH" --force
                            fi
                            ;;
                    esac
                else
                    echo -e "${GREEN}${ICON_OK} Remote repository is empty. Ready for first push.${NC}"
                fi
            else
                echo -e "${RED}${ICON_FAIL} SSH connection failed!${NC}"
                echo -e "${YELLOW}Make sure:${NC}"
                echo -e "1. SSH key is added to GitHub"
                echo -e "2. You've run: ${GREEN}ssh-add ~/.ssh/id_ed25519${NC}"
            fi
        fi
    else
        echo -e "${YELLOW}${ICON_INFO} Remote not set. You can add it later.${NC}"
    fi
    
    echo -e "\n${GREEN}${ICON_OK} Repository setup complete.${NC}"
    read -p "Press Enter to continue..."
}

push_specific() {
    if [[ ! -d ".git" ]]; then
        echo -e "${RED}${ICON_FAIL} Not a git repository!${NC}"
        echo -e "${YELLOW}Run option 12 to initialize git first.${NC}"
        return
    fi
    
    ensure_ssh_url
    
    echo -e "${BLUE}${ICON_PUSH} PUSH SPECIFIC FILE${NC}"
    echo -e "${CYAN}----------------------------------------------${NC}"
    echo -e "${YELLOW}Select file or folder to push${NC}"
    echo ""
    
    # Show changed files
    changes=$(git status -s)
    if [[ -z "$changes" ]]; then
        echo -e "${GREEN}${ICON_OK} No changes detected.${NC}"
        return
    fi
    
    echo -e "${BLUE}Changed files:${NC}"
    git status -s
    echo -e "${CYAN}----------------------------------------------${NC}"
    echo ""
    
    echo -e "${BLUE}Enter path to push:${NC}"
    echo -e "${YELLOW}Examples:${NC}"
    echo -e "  Single file:  ${CYAN}~/.config/hypr/hyprland.conf${NC}"
    echo -e "  Folder:       ${CYAN}~/.config/waybar${NC}"
    echo -e "  Current dir:  ${CYAN}.${NC}"
    echo ""
    read -p "Path: " file_path
    
    if [[ -z "$file_path" ]]; then
        echo -e "${RED}${ICON_FAIL} Path cannot be empty.${NC}"
        return
    fi
    
    # Expand tilde to home directory
    file_path="${file_path/#\~/$HOME}"
    
    if [[ ! -e "$file_path" ]]; then
        echo -e "${RED}${ICON_FAIL} File/folder not found: $file_path${NC}"
        return
    fi
    
    echo -e "\n${BLUE}${ICON_INFO} Adding $file_path...${NC}"
    git add "$file_path"
    
    echo -e "${BLUE}Enter commit message:${NC}"
    echo -e "${YELLOW}Example: 'Update hyprland config'${NC}"
    read -p "> " msg
    
    git commit -m "${msg:-Update $file_path}"
    
    echo -e "\n${BLUE}${ICON_INFO} Pushing to GitHub...${NC}"
    if git push origin "$BRANCH" 2>&1; then
        log_msg "${GREEN}${ICON_OK} Push successful!${NC}"
        echo -e "${GREEN}${ICON_OK} Push successful!${NC}"
    else
        push_error=$?
        log_msg "${RED}${ICON_FAIL} Push failed with code $push_error${NC}"
        echo -e "${RED}${ICON_FAIL} Push failed!${NC}"
        echo -e "${YELLOW}${ICON_INFO} Try:${NC}"
        echo -e "1. Run option 14 (Pull from GitHub) first"
        echo -e "2. Check SSH setup (option 8)"
    fi
}

push_all() {
    if [[ ! -d ".git" ]]; then
        echo -e "${RED}${ICON_FAIL} Not a git repository!${NC}"
        echo -e "${YELLOW}Run option 12 to initialize git first.${NC}"
        return
    fi
    
    ensure_ssh_url
    
    echo -e "${BLUE}${ICON_UPLOAD} PUSH ALL CHANGES${NC}"
    echo -e "${CYAN}----------------------------------------------${NC}"
    
    # Check for changes
    if [[ -z "$(git status --porcelain)" ]]; then 
        echo -e "${GREEN}${ICON_OK} Nothing to commit. Working directory clean.${NC}"
        return
    fi

    echo -e "${BLUE}Changes to be pushed:${NC}"
    git status -s
    echo ""
    
    read -p "Are you sure? (y/n): " confirm
    if [[ "${confirm,,}" != "y" ]]; then
        echo -e "${YELLOW}Cancelled.${NC}"
        return
    fi

    git add .
    
    echo -e "${BLUE}Enter commit message:${NC}"
    echo -e "${YELLOW}Example: 'Update dotfiles'${NC}"
    read -p "> " msg
    
    git commit -m "${msg:-Update dotfiles}"
    
    echo -e "\n${BLUE}${ICON_INFO} Pushing to GitHub...${NC}"
    if git push origin "$BRANCH" 2>&1; then
        echo -e "${GREEN}${ICON_OK} All changes pushed successfully!${NC}"
    else
        push_error=$?
        echo -e "${RED}${ICON_FAIL} Push failed!${NC}"
        echo -e "${YELLOW}${ICON_INFO} Error code: $push_error${NC}"
        echo -e "${YELLOW}${ICON_INFO} Try:${NC}"
        echo -e "1. Run option 14 (Pull from GitHub) first"
        echo -e "2. Run option 15 (Sync with GitHub) instead"
    fi
}

remove_commits() {
    if [[ ! -d ".git" ]]; then
        echo -e "${RED}${ICON_FAIL} Not a git repository!${NC}"
        return
    fi
    
    # Check if there are commits
    if ! git log --oneline -1 &>/dev/null; then
        echo -e "${YELLOW}${ICON_INFO} No commits found in repository.${NC}"
        return
    fi
    
    echo -e "${RED}${ICON_UNDO} UNDO LAST COMMIT${NC}"
    echo -e "${CYAN}----------------------------------------------${NC}"
    echo -e "${YELLOW}Warning: This will undo your last commit${NC}"
    echo ""
    
    echo -e "${BLUE}Last commit:${NC}"
    git log --oneline -1
    echo ""
    
    echo -e "Choose undo method:"
    echo -e "  ${GREEN}1)${NC} Soft undo - Keep changes, only remove commit"
    echo -e "  ${GREEN}2)${NC} Hard undo - Remove commit AND discard changes"
    echo -e "  ${GREEN}3)${NC} Cancel"
    
    read -p "Select: " undo_opt
    
    case $undo_opt in
        1) 
            git reset --soft HEAD~1
            echo -e "${GREEN}${ICON_OK} Soft undo complete. Changes preserved.${NC}"
            ;;
        2) 
            echo -e "${RED}${ICON_DANGER} This will DELETE your changes!${NC}"
            read -p "Type 'DELETE' to confirm: " del_conf
            if [[ "$del_conf" == "DELETE" ]]; then
                git reset --hard HEAD~1
                echo -e "${RED}${ICON_OK} Hard undo complete. Changes deleted.${NC}"
            else
                echo -e "${YELLOW}Cancelled.${NC}"
            fi
            ;;
        *) 
            echo -e "${YELLOW}Cancelled.${NC}"
            ;;
    esac
}

force_push() {
    if [[ ! -d ".git" ]]; then
        echo -e "${RED}${ICON_FAIL} Not a git repository!${NC}"
        return
    fi
    
    ensure_ssh_url
    
    echo -e "${RED}${ICON_DANGER} FORCE PUSH${NC}"
    echo -e "${CYAN}----------------------------------------------${NC}"
    echo -e "${YELLOW}WARNING: This will overwrite remote history!${NC}"
    echo -e "${YELLOW}Only use this if you know what you're doing.${NC}"
    echo ""
    
    echo -e "${BLUE}Current remote:${NC}"
    git remote -v
    echo ""
    
    read -p "Type 'FORCE' to confirm: " confirm
    if [[ "$confirm" != "FORCE" ]]; then
        echo -e "${YELLOW}Cancelled.${NC}"
        return
    fi

    git add .
    git commit -m "Force push update" || true
    git push origin "$BRANCH" --force
    
    echo -e "${GREEN}${ICON_OK} Force push complete.${NC}"
}

# --- SYMLINK DOCTOR ---
symlink_doctor() {
    echo -e "${BLUE}${ICON_FIX} SYMLINK DOCTOR${NC}"
    echo -e "${CYAN}----------------------------------------------${NC}"
    
    if [[ ! -d "$PACKAGE_NAME" ]]; then
        echo -e "${RED}${ICON_FAIL} Package '$PACKAGE_NAME' not found!${NC}"
        return
    fi
    
    echo -e "${BLUE}Checking symlinks for package: $PACKAGE_NAME${NC}"
    
    RAW_OUTPUT=$(stow -n -t "$HOME" "$PACKAGE_NAME" 2>&1)
    CONFLICT_FILES=$(echo "$RAW_OUTPUT" | grep "existing target" | sed 's/.*: //')

    if [[ -z "$CONFLICT_FILES" ]]; then
        stow -R -t "$HOME" "$PACKAGE_NAME" 2>&1
        echo -e "${GREEN}${ICON_OK} All symlinks updated successfully.${NC}"
    else
        echo -e "${RED}${ICON_FAIL} Found conflicts:${NC}"
        echo "$CONFLICT_FILES"
        echo ""
        
        echo -e "${BLUE}Resolution options:${NC}"
        echo -e "  ${GREEN}1)${NC} Backup conflicts and create symlinks"
        echo -e "  ${GREEN}2)${NC} Adopt system files into repository"
        echo -e "  ${GREEN}3)${NC} Cancel"
        
        read -p "Select: " fix_opt
        
        case $fix_opt in
            1)
                BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"
                echo -e "${BLUE}Creating backup in: $BACKUP_DIR${NC}"
                mkdir -p "$BACKUP_DIR"
                
                while IFS= read -r file; do
                    if [[ -n "$file" ]]; then
                        TARGET="$HOME/$file"
                        if [[ -e "$TARGET" || -L "$TARGET" ]]; then
                            mkdir -p "$(dirname "$BACKUP_DIR/$file")"
                            mv "$TARGET" "$BACKUP_DIR/$file"
                            echo -e "  ${GREEN}${ICON_OK}${NC} Backed up: $file"
                        fi
                    fi
                done <<< "$CONFLICT_FILES"
                
                stow -R -t "$HOME" "$PACKAGE_NAME"
                echo -e "${GREEN}${ICON_OK} Conflicts backed up and symlinks created.${NC}"
                ;;
            2) 
                stow --adopt -t "$HOME" "$PACKAGE_NAME"
                echo -e "${GREEN}${ICON_OK} System files adopted into repository.${NC}"
                ;;
            *) 
                echo -e "${YELLOW}Cancelled.${NC}"
                ;;
        esac
    fi
}

# --- LOG VIEWER ---
view_logs() {
    clear
    echo -e "${BLUE}${ICON_LOG} DOT-MANAGER LOGS${NC}"
    echo -e "${CYAN}----------------------------------------------${NC}"
    
    if [[ ! -f "$LOG_FILE" ]]; then
        echo -e "${YELLOW}${ICON_INFO} No log file found.${NC}"
        read -p "Press Enter to return..."
        return
    fi
    
    echo -e "${BLUE}Log file: $LOG_FILE${NC}"
    echo -e "${BLUE}Last modified: $(date -r "$LOG_FILE" '+%Y-%m-%d %H:%M:%S')${NC}"
    echo ""
    
    # Show last 50 entries
    log_lines=$(tail -50 "$LOG_FILE")
    
    if [[ -z "$log_lines" ]]; then
        echo -e "${YELLOW}Log file is empty.${NC}"
    else
        # Simple display without complex parsing
        tail -50 "$LOG_FILE" | while IFS= read -r line; do
            # Basic color coding
            if echo "$line" | grep -q "ERROR\|FAIL\|fatal\|rejected"; then
                echo -e "${RED}$line${NC}"
            elif echo "$line" | grep -q "OK\|SUCCESS\|Complete\|successful"; then
                echo -e "${GREEN}$line${NC}"
            elif echo "$line" | grep -q "WARNING\|DANGER\|Warning\|conflict"; then
                echo -e "${YELLOW}$line${NC}"
            elif echo "$line" | grep -q "INFO\|COMMAND"; then
                echo -e "${CYAN}$line${NC}"
            else
                echo "$line"
            fi
        done
    fi
    
    echo -e "\n${CYAN}----------------------------------------------${NC}"
    echo -e "${BLUE}Options:${NC}"
    echo -e "  ${GREEN}c${NC} Clear logs   ${GREEN}t${NC} Tail follow   ${GREEN}q${NC} Return"
    
    read -p "Select: " log_opt
    
    case $log_opt in
        c)
            echo "# Log cleared at $(date)" > "$LOG_FILE"
            echo -e "${GREEN}${ICON_OK} Logs cleared.${NC}"
            sleep 1
            ;;
        t)
            echo -e "${BLUE}Following logs (Ctrl+C to stop)...${NC}"
            tail -f "$LOG_FILE"
            read -p "Press Enter to return..."
            ;;
    esac
}

# --- REPAIR GIT REPO ---
repair_git_repo() {
    echo -e "${BLUE}${ICON_REPAIR} REPAIR GIT REPOSITORY${NC}"
    echo -e "${CYAN}----------------------------------------------${NC}"
    echo ""
    
    current_dir=$(pwd)
    echo -e "${BLUE}Current directory:${NC} $current_dir"
    echo ""
    
    if [[ -d ".git" ]]; then
        echo -e "${YELLOW}${ICON_INFO} Git repository already exists here.${NC}"
        echo ""
        
        echo -e "${BLUE}Current status:${NC}"
        git status --short
        echo ""
        
        echo -e "${RED}${ICON_DANGER} What do you want to do?${NC}"
        echo -e "  ${GREEN}1)${NC} Reinitialize git (keep files, delete .git)"
        echo -e "  ${GREEN}2)${NC} Fix remote URL"
        echo -e "  ${GREEN}3)${NC} Cancel"
        
        read -p "Select: " repair_opt
        
        case $repair_opt in
            1)
                echo -e "${RED}${ICON_DANGER} This will delete the .git folder!${NC}"
                echo -e "${YELLOW}Your files will be kept, but git history will be lost.${NC}"
                read -p "Type 'REINIT' to confirm: " confirm
                
                if [[ "$confirm" == "REINIT" ]]; then
                    rm -rf .git
                    echo -e "${GREEN}${ICON_OK} .git folder removed.${NC}"
                    setup_github_repo
                else
                    echo -e "${YELLOW}Cancelled.${NC}"
                    return
                fi
                ;;
            2)
                ensure_ssh_url
                ;;
            3)
                echo -e "${YELLOW}Cancelled.${NC}"
                return
                ;;
        esac
    else
        echo -e "${YELLOW}${ICON_INFO} No git repository found.${NC}"
        echo -e "${BLUE}Do you want to initialize a new git repository here?${NC}"
        read -p "(y/n): " init_choice
        
        if [[ "${init_choice,,}" == "y" ]]; then
            setup_github_repo
        else
            echo -e "${YELLOW}Cancelled.${NC}"
        fi
    fi
}

# --- QUICK STOW ---
quick_stow() {
    echo -e "${BLUE}${ICON_REFRESH} QUICK REFRESH${NC}"
    echo -e "${CYAN}----------------------------------------------${NC}"
    
    if [[ ! -d "$PACKAGE_NAME" ]]; then
        echo -e "${RED}${ICON_FAIL} Package '$PACKAGE_NAME' not found!${NC}"
        return
    fi
    
    echo -e "${BLUE}Refreshing symlinks for: $PACKAGE_NAME${NC}"
    stow -R -t "$HOME" "$PACKAGE_NAME"
    echo -e "${GREEN}${ICON_OK} Symlinks refreshed.${NC}"
}

# --- MAIN MENU ---
init_log
check_dependencies
load_config
cd "$DOTFILES_DIR" || { echo -e "${RED}${ICON_FAIL} Cannot access directory: $DOTFILES_DIR${NC}"; exit 1; }

while true; do
    clear
    # HEADER
    echo -e "${BLUE}=====================================================${NC}"
    echo -e "         ${ICON_STAR} DOT-MANAGER v3.6 TTY Edition ${ICON_STAR} "
    echo -e "${BLUE}=====================================================${NC}"
    echo ""
    
    # Get git info for display
    if [[ -d ".git" ]]; then
        current_branch=$(git branch --show-current 2>/dev/null || echo "none")
        remote_url=$(git remote get-url "$GITHUB_REMOTE" 2>/dev/null || echo "Not set")
        # Truncate long URLs
        if [[ ${#remote_url} -gt 40 ]]; then
            remote_display="${remote_url:0:37}..."
        else
            remote_display="$remote_url"
        fi
        echo -e "  ${ICON_HOME}     ${CYAN}Repo:${NC}   ${YELLOW}$DOTFILES_DIR${NC}"
        echo -e "  ${ICON_CONFIG}     ${CYAN}Package:${NC} ${YELLOW}$PACKAGE_NAME${NC}"
        echo -e "  ${ICON_GIT}      ${CYAN}Git:${NC}     ${GREEN}$current_branch${NC} @ ${CYAN}$remote_display${NC}"
    else
        echo -e "  ${ICON_HOME}     ${CYAN}Repo:${NC}   ${YELLOW}$DOTFILES_DIR${NC}"
        echo -e "  ${ICON_CONFIG}     ${CYAN}Package:${NC} ${YELLOW}$PACKAGE_NAME${NC}"
        echo -e "  ${ICON_GIT}      ${CYAN}Git:${NC}     ${RED}Not initialized${NC}"
    fi
    echo ""
    echo -e "${BLUE}=====================================================${NC}"
    echo ""
    
    echo -e "${GREEN}[GIT OPERATIONS]${NC}"
    echo -e "  ${GREEN}1)${NC} ${ICON_INFO}     Show Status"
    echo -e "  ${GREEN}2)${NC} ${ICON_PUSH}     Push Specific File"
    echo -e "  ${GREEN}3)${NC} ${ICON_UPLOAD}       Push All Changes"
    echo -e "  ${GREEN}4)${NC} ${ICON_UNDO}     Undo Last Commit"
    echo -e "  ${GREEN}5)${NC} ${ICON_DANGER}     Force Push"
    echo -e "  ${GREEN}14)${NC} ${ICON_PULL}     Pull from GitHub"
    echo -e "  ${GREEN}15)${NC} ${ICON_SYNC}     Sync with GitHub"
    echo -e ""
    
    echo -e "${CYAN}[DOTFILES MANAGEMENT]${NC}"
    echo -e "  ${GREEN}6)${NC} ${ICON_FIX}      Symlink Doctor"
    echo -e "  ${GREEN}7)${NC} ${ICON_REFRESH}   Quick Refresh"
    echo -e ""
    
    echo -e "${MAGENTA}[SSH & GITHUB SETUP]${NC}"
    echo -e "  ${GREEN}8)${NC} ${ICON_KEY}      Setup SSH Keys"
    echo -e "  ${GREEN}9)${NC} ${ICON_GITHUB}   Setup GitHub Repository"
    echo -e ""
    
    echo -e "${YELLOW}[CONFIGURATION]${NC}"
    echo -e "  ${GREEN}10)${NC} ${ICON_CONFIG}     Reconfigure Package"
    echo -e "  ${GREEN}11)${NC} ${ICON_LOG}      View Logs"
    echo -e "  ${GREEN}12)${NC} ${ICON_REPAIR}   Repair Git Repository"
    echo -e "  ${GREEN}13)${NC} ${ICON_FAIL}     Exit"
    echo ""
    echo -e "${BLUE}=====================================================${NC}"
    read -p "  Select Option (1-15): " opt

    case $opt in
        1) check_status; read -p "  Press Enter..." ;;
        2) push_specific; read -p "  Press Enter..." ;;
        3) push_all; read -p "  Press Enter..." ;;
        4) remove_commits; read -p "  Press Enter..." ;;
        5) force_push; read -p "  Press Enter..." ;;
        6) symlink_doctor; read -p "  Press Enter..." ;;
        7) quick_stow; read -p "  Press Enter..." ;;
        8) setup_ssh ;;
        9) setup_github_repo ;;
        10) reconfigure_package ;;
        11) view_logs ;;
        12) repair_git_repo; read -p "  Press Enter..." ;;
        13) 
            echo -e "${GREEN}${ICON_OK} Thank you for using Dot-Manager!${NC}"
            echo "# Session ended at $(date)" >> "$LOG_FILE"
            exit 0 
            ;;
        14) pull_from_remote; read -p "  Press Enter..." ;;
        15) sync_with_remote; read -p "  Press Enter..." ;;
        *) 
            echo -e "  ${RED}${ICON_FAIL} Invalid option. Please enter 1-15.${NC}"
            sleep 1
            ;;
    esac
done
