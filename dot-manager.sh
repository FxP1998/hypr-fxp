#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  󰣇  FxP1998 REPOSITORY ORCHESTRATOR
#  󰀻  File: dot-manager.sh
#  󰁔  Description: Professional, self-contained Git & SSH management suite.
#
#  󰄬  Created By: M. H. IMAM (FxP1998)
#  󰊤  GitHub: https://github.com/FxP1998/
# -----------------------------------------------------------------------------

# --- Colors & Compatibility Engine ---
C_BLUE='\033[1;34m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_RESET='\033[0m'; C_BOLD='\033[1m'

if [[ "$TERM" == "linux" ]]; then
    I_GIT="[GIT]"; I_OK="[OK]"; I_INFO="->"; I_KEY="[KEY]"; I_SYNC="[SYNC]"; I_LOCK="[SEC]"; I_UP="[UP]"; I_FIX="[FIX]"; LINE="----------------------------------------------------"
else
    I_GIT="󰊤"; I_OK="󰄬"; I_INFO="󰁔"; I_KEY="󰒓"; I_SYNC="󰓦"; I_LOCK="󰒓"; I_UP="󰓅"; I_FIX="󰒓"; LINE="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

# --- Configuration & Security ---
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="$REPO_ROOT/.fxp_state.conf"
GITHUB_REMOTE="origin"

# --- UI Helpers ---
print_header() {
    clear
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}"
    echo -e "  ${I_GIT}  ${C_BOLD}FxP1998 REPOSITORY COMMAND CENTER${C_RESET}"
    echo -e "${C_BLUE}${C_BOLD}${LINE}${C_RESET}\n"
}

msg_info() { echo -e "  ${C_BLUE}${I_INFO}${C_RESET} $1"; }
msg_success() { echo -e "  ${C_GREEN}${I_OK}${C_RESET} $1"; }
msg_error() { echo -e "  ${C_RED}[✘]${C_RESET} $1"; }

# --- Security: Load/Create Local Config ---
initialize_security() {
    if [ ! -f "$STATE_FILE" ]; then
        print_header
        echo -e "  ${I_LOCK}  ${C_BOLD}INITIAL SECURITY SETUP${C_RESET}"
        echo -e "  ${I_INFO} Welcome to FxP1998. Let's configure your local identity."
        echo -e "  ${I_INFO} This data is stored locally and will NEVER be pushed to Git.\n"

        echo -e "  ${C_YELLOW}Step 1: Git Display Name${C_RESET}"
        echo -e "      (The name shown on your commits. Found in GitHub Profile Settings)"
        read -p "    󰁔 Enter Name: " git_name
        
        echo -e "\n  ${C_YELLOW}Step 2: Git Email Address${C_RESET}"
        echo -e "      (The email linked to your GitHub account)"
        read -p "    󰁔 Enter Email: " git_email
        
        echo -e "\n  ${C_YELLOW}Step 3: GitHub Username${C_RESET}"
        echo -e "      (Your public handle used in profile URLs)"
        read -p "    󰁔 Enter Username: " gh_user
        
        cat <<EOF > "$STATE_FILE"
# FxP1998 LOCAL SECURITY STATE
# DO NOT COMMIT THIS FILE
FXP_GIT_NAME="${git_name:-User}"
FXP_GIT_EMAIL="${git_email:-user@example.com}"
FXP_GH_USER="${gh_user:-username}"
EOF
        msg_success "Security state initialized."
        
        # Apply identity to git locally
        git config user.name "$git_name"
        git config user.email "$git_email"
        sleep 2
    fi
    source "$STATE_FILE"
}

# --- SSH Orchestrator ---
manage_ssh() {
    print_header
    echo -e "  ${C_BOLD}${I_KEY} SSH KEY MANAGEMENT${C_RESET}\n"
    
    msg_info "Checking for existing SSH keys..."
    if [ -f "$HOME/.ssh/id_ed25519" ]; then
        msg_success "Found active Ed25519 key."
    else
        msg_info "No Ed25519 key found. Generating now..."
        ssh-keygen -t ed25519 -C "$FXP_GIT_EMAIL" -f "$HOME/.ssh/id_ed25519" -N ""
    fi

    eval "$(ssh-agent -s)" > /dev/null
    ssh-add "$HOME/.ssh/id_ed25519" 2>/dev/null

    echo -e "\n  ${C_YELLOW}Your Public SSH Key:${C_RESET}"
    echo -e "${C_BLUE}${LINE}${C_RESET}"
    cat "$HOME/.ssh/id_ed25519.pub"
    echo -e "${C_BLUE}${LINE}${C_RESET}"
    
    echo -e "\n  ${I_INFO} Instructions:"
    echo -e "    1. Copy the key above."
    echo -e "    2. Go to: https://github.com/settings/ssh/new"
    echo -e "    3. Paste and save."
    
    echo -e "\n  Press any key to return..."
    read -n 1 -s
}

# --- Remote Fix (HTTPS -> SSH) ---
fix_remote() {
    local url=$(git remote get-url "$GITHUB_REMOTE" 2>/dev/null)
    if [[ "$url" =~ ^https://github.com/ ]]; then
        msg_info "Converting HTTPS to SSH for secure access..."
        local new_url=$(echo "$url" | sed "s|https://github.com/|git@github.com:|")
        git remote set-url "$GITHUB_REMOTE" "$new_url"
        msg_success "Remote updated to SSH: $new_url"
    fi
}

# --- Surgical Push (Select specific changes) ---
push_surgical() {
    print_header
    echo -e "  ${C_BOLD}${I_GIT} SURGICAL UPLOAD${C_RESET}\n"
    
    # Show status
    echo -e "  ${C_BOLD}Uncommitted Changes:${C_RESET}"
    git status -s
    echo ""

    read -p "    Enter path of file/folder to push: " item_path
    
    if [ -z "$item_path" ] || [ ! -e "$item_path" ]; then
        msg_error "Invalid path or file not found."
        sleep 2; return
    fi

    fix_remote
    
    # Pre-push rebase to avoid rejections
    msg_info "Aligning with remote state..."
    git pull origin $(git branch --show-current) --rebase > /dev/null 2>&1

    git add "$item_path"
    
    read -p "    Enter commit message: " commit_msg
    git commit -m "${commit_msg:-Update $item_path}"
    
    msg_info "Pushing changes..."
    if git push origin $(git branch --show-current); then
        msg_success "Surgical push successful!"
    else
        msg_error "Push failed. Check for conflicts manually."
    fi
    
    echo -e "\n  Press any key to return..."
    read -n 1 -s
}

# --- Global Push (Push all changes) ---
push_all() {
    print_header
    echo -e "  ${C_BOLD}${I_GIT} GLOBAL UPLOAD${C_RESET}\n"
    
    if [[ -z "$(git status --porcelain)" ]]; then
        msg_success "Nothing to upload. Repo is clean."
        sleep 2; return
    fi

    fix_remote

    # Pre-push rebase to avoid rejections
    msg_info "Aligning with remote state..."
    git pull origin $(git branch --show-current) --rebase > /dev/null 2>&1

    msg_info "Staging ALL current changes..."
    git add -A
    
    echo -e "  ${C_BOLD}Preparing to upload:${C_RESET}"
    git status -s
    echo ""

    read -p "    Enter commit message for all changes: " commit_msg
    git commit -m "${commit_msg:-Update all Rice configs}"
    
    msg_info "Pushing all changes to GitHub..."
    if git push origin $(git branch --show-current); then
        msg_success "Global upload successful!"
    else
        msg_error "Push failed. Check for conflicts manually."
    fi
    
    echo -e "\n  Press any key to return..."
    read -n 1 -s
}

# --- Force Overwrite Remote ---
force_push() {
    print_header
    echo -e "  ${C_RED}${C_BOLD}[WARNING] FORCE OVERWRITE REMOTE${C_RESET}\n"
    
    echo -e "  ${I_INFO} This will DELETE all content on GitHub and replace"
    echo -e "      it exactly with your local files."
    echo -e "  ${I_INFO} Use this ONLY if your remote is broken or you want"
    echo -e "      to completely restart your GitHub history.\n"
    
    read -p "    Type 'OVERWRITE' to confirm: " confirm
    
    if [[ "$confirm" == "OVERWRITE" ]]; then
        fix_remote
        msg_info "Staging all local files..."
        git add -A
        git commit -m "Force overwrite from local system" > /dev/null 2>&1
        
        msg_info "Force pushing to GitHub..."
        if git push origin $(git branch --show-current) --force; then
            msg_success "GitHub repository has been completely overwritten!"
        else
            msg_error "Force push failed."
        fi
    else
        msg_info "Action cancelled."
    fi
    
    echo -e "\n  Press any key to return..."
    read -n 1 -s
}

# --- Repository Maintenance & Repair ---
repair_repo() {
    print_header
    echo -e "  ${I_GEAR}  ${C_BOLD}REPOSITORY REPAIR UTILITY${C_RESET}\n"
    
    msg_info "Staging all surgical changes (moves/renames)..."
    git add -A
    
    msg_info "Cleaning up the Git index..."
    git gc --prune=now --quiet
    
    msg_success "Repository structure synchronized with Git."
    echo -e "  ${I_INFO} Status is now clean and ready for Sync."
    sleep 2
}

# --- Execution ---
cd "$REPO_ROOT" || exit 1
initialize_security

while true; do
    print_header
    echo -e "  ${C_BOLD}${C_BLUE}󰊤  REPOSITORY HEALTH${C_RESET}"
    echo -e "  ${C_YELLOW}1)${C_RESET} ${I_INFO}  Show Current Status"
    echo -e "  ${C_YELLOW}2)${C_RESET} ${I_GEAR}  Repair Index (Moves/Renames)"
    echo -e "  ${C_YELLOW}3)${C_RESET} 󰁯   Undo Last Commit\n"

    echo -e "  ${C_BOLD}${C_BLUE}󰓅  UPLOAD & SYNC${C_RESET}"
    echo -e "  ${C_YELLOW}4)${C_RESET} ${I_GIT}  Surgical Upload (Specific Path)"
    echo -e "  ${C_YELLOW}5)${C_RESET} ${I_UP}  Global Upload (Push All)"
    echo -e "  ${C_YELLOW}6)${C_RESET} ${C_RED}󰆴   Force Overwrite Remote (DANGER)${C_RESET}\n"

    echo -e "  ${C_BOLD}${C_BLUE}󰒓  SECURITY & ACCESS${C_RESET}"
    echo -e "  ${C_YELLOW}7)${C_RESET} ${I_KEY}  Manage SSH Keys"
    echo -e "  ${C_YELLOW}8)${C_RESET} ${I_LOCK}  Reset Security Config"
    echo -e "  ${C_YELLOW}9)${C_RESET} 󰈆   Exit\n"
    
    read -p "  Select Option [1-9]: " opt

    case $opt in
        1) print_header; echo -e "  ${C_BOLD}Git Identity:${C_RESET} $FXP_GIT_NAME <$FXP_GIT_EMAIL>"; git status; read -p "  Press Enter..." ;;
        2) repair_repo ;;
        3) git reset --soft HEAD~1 && msg_success "Last commit undone (changes kept)." && sleep 2 ;;
        4) push_surgical ;;
        5) push_all ;;
        6) force_push ;;
        7) manage_ssh ;;
        8) rm "$STATE_FILE" && msg_warn "Security file removed. Restart script to re-configure." && exit 0 ;;
        9) clear; exit 0 ;;
        *) ;;
    esac
done
