#!/bin/bash

# GitHub Auto-Pusher with SSH Setup
# ==================================

# Configuration
REPO_DIR="$HOME/dotfiles"
REMOTE_NAME="origin"
BRANCH="main"
GITHUB_USER="FxP1998"
GITHUB_REPO="hypr-fxp"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if directory exists
check_repo_dir() {
    if [ ! -d "$REPO_DIR" ]; then
        print_error "Repository directory not found: $REPO_DIR"
        exit 1
    fi
    
    if [ ! -d "$REPO_DIR/.git" ]; then
        print_error "Not a git repository: $REPO_DIR"
        exit 1
    fi
}

# Check SSH key and setup if needed
setup_ssh_key() {
    print_status "Checking SSH keys..."
    
    # Check if SSH key exists
    if [ -f "$HOME/.ssh/id_ed25519" ] || [ -f "$HOME/.ssh/id_rsa" ]; then
        print_success "SSH key found"
        return 0
    fi
    
    print_warning "No SSH key found. Let's create one..."
    
    # Ask for email
    echo
    print_status "We need your email for the SSH key"
    read -p "Enter your email address: " user_email
    
    if [ -z "$user_email" ]; then
        print_error "Email is required for SSH key"
        exit 1
    fi
    
    # Create SSH directory if it doesn't exist
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    
    # Generate SSH key (prefer ed25519)
    print_status "Generating new SSH key (ed25519)..."
    ssh-keygen -t ed25519 -C "$user_email" -f "$HOME/.ssh/id_ed25519" -N ""
    
    if [ $? -eq 0 ]; then
        print_success "SSH key generated successfully"
        
        # Start SSH agent and add key
        print_status "Starting SSH agent..."
        eval "$(ssh-agent -s)"
        ssh-add "$HOME/.ssh/id_ed25519"
        
        # Show public key
        echo
        print_success "Your SSH public key:"
        cat "$HOME/.ssh/id_ed25519.pub"
        echo
        
        print_warning "IMPORTANT: You need to add this SSH key to your GitHub account:"
        print_warning "1. Go to: https://github.com/settings/keys"
        print_warning "2. Click 'New SSH key'"
        print_warning "3. Paste the above key and give it a title"
        print_warning "4. Press Enter after you've added the key to GitHub"
        
        read -p "Press Enter to continue after adding the key to GitHub..."
        
        # Test SSH connection
        test_ssh_connection
    else
        print_error "Failed to generate SSH key"
        exit 1
    fi
}

# Test SSH connection to GitHub
test_ssh_connection() {
    print_status "Testing SSH connection to GitHub..."
    
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        print_success "SSH connection to GitHub successful!"
        return 0
    else
        print_error "SSH connection failed"
        print_warning "Make sure you added the SSH key to your GitHub account"
        exit 1
    fi
}

# Configure remote URL to use SSH
setup_ssh_remote() {
    print_status "Checking remote repository URL..."
    
    cd "$REPO_DIR" || exit 1
    
    current_url=$(git remote get-url "$REMOTE_NAME" 2>/dev/null)
    
    if [ -n "$current_url" ]; then
        if [[ "$current_url" == *"git@github.com"* ]]; then
            print_success "Remote already uses SSH"
            return 0
        elif [[ "$current_url" == *"https://github.com"* ]]; then
            print_warning "Switching from HTTPS to SSH remote..."
            git remote set-url "$REMOTE_NAME" "git@github.com:$GITHUB_USER/$GITHUB_REPO.git"
            print_success "Remote updated to use SSH"
        fi
    else
        print_warning "Adding SSH remote..."
        git remote add "$REMOTE_NAME" "git@github.com:$GITHUB_USER/$GITHUB_REPO.git"
        print_success "SSH remote added"
    fi
}

# Git operations with error handling
git_operations() {
    cd "$REPO_DIR" || exit 1
    
    print_status "Checking git status..."
    
    # Check if we need to pull first
    print_status "Checking remote status..."
    git fetch "$REMOTE_NAME"
    
    local_behind=$(git rev-list --count "$REMOTE_NAME/$BRANCH..HEAD")
    local_ahead=$(git rev-list --count "HEAD..$REMOTE_NAME/$BRANCH")
    
    # If remote has changes, give override options
    if [ "$local_behind" -gt 0 ]; then
        print_warning "⚠️  Remote has $local_behind new commit(s) that you don't have locally."
        echo
        echo "Since you want to OVERRIDE remote with your local version:"
        echo "1) 󰬳  OVERRIDE REMOTE - Replace everything with your local version (Recommended)"
        echo "2)   Pull and merge (keep both changes)"
        echo "3)   Cancel push"
        echo
        
        read -p "Enter your choice (1-3): " override_choice
        
        case $override_choice in
            1)
                print_warning "  OVERRIDING REMOTE REPOSITORY..."
                print_warning "This will replace ALL remote content with your local version!"
                read -p "Are you absolutely sure? (type 'YES' to confirm): " confirmation
                
                if [ "$confirmation" = "YES" ]; then
                    # Proceed with force push
                    print_status "Overriding remote repository..."
                    
                    # First, commit local changes if any
                    if ! git diff-index --quiet HEAD --; then
                        print_status "Committing local changes..."
                        git add .
                        git commit -m "Auto-commit before override: $(date '+%Y-%m-%d %H:%M:%S')"
                    fi
                    
                    # Force push to override remote
                    if git push --force-with-lease "$REMOTE_NAME" "$BRANCH"; then
                        print_success "  Remote repository successfully OVERRIDDEN with your local version!"
                        return 0
                    else
                        print_error "Failed to override remote"
                        return 1
                    fi
                else
                    print_status "Override cancelled."
                    return 1
                fi
                ;;
            2)
                print_status "Pulling and merging remote changes..."
                if git pull "$REMOTE_NAME" "$BRANCH"; then
                    print_success "Successfully merged remote changes"
                else
                    print_error "Merge failed. Please resolve conflicts manually."
                    return 1
                fi
                ;;
            3)
                print_status "Push cancelled."
                return 1
                ;;
            *)
                print_error "Invalid choice. Push cancelled."
                return 1
                ;;
        esac
    fi
    
    # Normal push flow (no remote changes)
    # Check if there are changes to commit
    if git diff-index --quiet HEAD --; then
        print_warning "No changes to commit"
        
        # Even with no changes, we might need to push if we're ahead
        if [ "$local_ahead" -gt 0 ]; then
            print_status "No local changes, but you have $local_ahead commit(s) to push"
            read -p "Push commits to GitHub? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                print_status "Pushing to GitHub..."
                if git push "$REMOTE_NAME" "$BRANCH"; then
                    print_success "Successfully pushed to GitHub!"
                    return 0
                else
                    print_error "Failed to push to GitHub"
                    return 1
                fi
            fi
        fi
        return 0
    fi
    
    # Show what files changed
    print_status "Changed files:"
    git status --short
    
    # Ask for commit message
    echo
    read -p "Enter commit message: " commit_message
    
    if [ -z "$commit_message" ]; then
        commit_message="Auto-commit: $(date '+%Y-%m-%d %H:%M:%S')"
        print_warning "Using default commit message: $commit_message"
    fi
    
    # Add all changes
    print_status "Adding changes..."
    git add .
    
    # Commit changes
    print_status "Committing changes..."
    if git commit -m "$commit_message"; then
        print_success "Changes committed"
    else
        print_error "Failed to commit changes"
        return 1
    fi
    
    # Push changes
    print_status "Pushing to GitHub..."
    if git push "$REMOTE_NAME" "$BRANCH"; then
        print_success "Successfully pushed to GitHub!"
        return 0
    else
        print_error "Push failed due to remote changes."
        print_status "Run the push operation again and choose the OVERRIDE option."
        return 1
    fi
}

# Force push option (use with caution)
force_push() {
    print_warning "⚠️  FORCE PUSH - This will overwrite remote history!"
    read -p "Are you sure you want to force push? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Force pushing to GitHub..."
        cd "$REPO_DIR" && git push --force-with-lease "$REMOTE_NAME" "$BRANCH"
    else
        print_status "Force push cancelled"
    fi
}

# Pull changes from remote
pull_changes() {
    print_status "Pulling latest changes from GitHub..."
    cd "$REPO_DIR" && git pull "$REMOTE_NAME" "$BRANCH"
}

# Show git status
show_status() {
    print_status "Repository status:"
    cd "$REPO_DIR" && git status
}

# Main function
main() {
    echo "========================================="
    echo "   GitHub Auto-Pusher with SSH Setup"
    echo "========================================="
    echo
    
    # Check repository directory
    check_repo_dir
    
    # Setup SSH key if needed
    setup_ssh_key
    
    # Configure SSH remote
    setup_ssh_remote
    
    # Test SSH connection
    test_ssh_connection
    
    # Show menu
    while true; do
        echo
        echo "Choose an option:"
        echo "1)   PUSH to GitHub (with override option)"
        echo "2)   Pull changes from GitHub" 
        echo "3) 󱖫  Show git status"
        echo "4)   Force push (direct override)"
        echo "5) 󰩈  Exit"
        echo
        
        read -p "Enter your choice (1-5): " choice
        
        case $choice in
            1)
                git_operations
                ;;
            2)
                pull_changes
                ;;
            3)
                show_status
                ;;
            4)
                force_push
                ;;
            5)
                print_success "Goodbye! 󱠡 "
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please try again."
                ;;
        esac
    done
}

# Handle script interruption
trap 'echo; print_error "Script interrupted"; exit 1' INT

# Run main function
main
