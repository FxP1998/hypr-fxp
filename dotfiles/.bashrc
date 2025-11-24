#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '


# Custome Bin for FxP-Hyprland
export PATH="$HOME/.local/share/fxp-custom/bin:$PATH"

# spec. view
pfetch


# Font Update
alias uf='fc-cache -fv && echo " Font cache updated."'

# Chance Directorys
alias c='cd ~/.config'
alias ec='nvim ~/.config/'
alias fxp='cd ~/.config/hypr/'
alias efxp='nvim ~/.config/hypr/'

# The Ultimate Extactor
# Required pakages "unzip unrar p7zip zstd xz gzip bzip2 tar"
x () {
    if [[ -f "$1" ]]; then
        filepath=$(realpath "$1")
        filename=$(basename -- "$filepath")
        filedir=$(dirname -- "$filepath")
        dirname="${filename%.*}"

        # Handle double extensions like .tar.gz, .tar.xz, .tar.bz2, .tar.zst
        case "$filename" in
            *.tar.gz|*.tgz)   dirname="${filename%.tar.gz}"; dirname="${dirname%.tgz}" ;;
            *.tar.bz2|*.tbz2) dirname="${filename%.tar.bz2}"; dirname="${dirname%.tbz2}" ;;
            *.tar.xz)         dirname="${filename%.tar.xz}" ;;
            *.tar.zst)        dirname="${filename%.tar.zst}" ;;
        esac

        outdir="$filedir/$dirname"
        mkdir -p "$outdir"

        case "$filename" in
            *.tar.bz2|*.tbz2)   tar xvjf "$filepath" -C "$outdir" ;;
            *.tar.gz|*.tgz)     tar xvzf "$filepath" -C "$outdir" ;;
            *.tar.xz)           tar xvJf "$filepath" -C "$outdir" ;;
            *.tar.zst)          unzstd -c "$filepath" | tar xvf - -C "$outdir" ;;
            *.tar)              tar xvf "$filepath" -C "$outdir" ;;
            *.zip)              unzip -d "$outdir" "$filepath" ;;
            *.rar)              unrar x "$filepath" "$outdir"/ ;;
            *.7z)               7z x "$filepath" -o"$outdir" ;;
            *.gz)               gunzip -c "$filepath" > "$outdir/${filename%.gz}" ;;
            *.bz2)              bunzip2 -c "$filepath" > "$outdir/${filename%.bz2}" ;;
            *.xz)               unxz -c "$filepath" > "$outdir/${filename%.xz}" ;;
            *.zst)              unzstd -c "$filepath" > "$outdir/${filename%.zst}" ;;
            *) echo " Unknown archive format: $1" ;;
        esac
    else
        echo " File does not exist: $1"
    fi
}


# EXA aliases with icons and colors
alias ls='exa --icons --color=always --group-directories-first'
alias ll='exa -l --icons --color=always --group-directories-first --time-style=long-iso --git'
alias la='exa -la --icons --color=always --group-directories-first --time-style=long-iso --git'
alias lt='exa --tree --icons --color=always --group-directories-first --level=2'
alias ltree='exa --tree --icons --color=always --group-directories-first --level=3'


# Package Manager
# === pacman ===
alias i='sudo pacman -S --needed'
alias s='sudo pacman -Ss'
alias pq='pacman -Q'
alias ipq='pacman -Qi'
alias r='sudo pacman -Rns'
alias u='sudo pacman -Syyu'

# === yay ===
alias yi='sudo pacman -S --needed'
alias ys='sudo pacman -Ss'
alias yr='sudo pacman -Rns'
alias yu='yay -Syyu'

# === paru ===
alias pi='sudo pacman -S --needed'
alias ps='sudo pacman -Ss'
alias pr='sudo pacman -Rns'
alias pu='paru -Syyu'


# === yt-dlp ===
# Download video (max 1080p, mp4 format) to ~/Videos/yt-dlp-video/
alias ytv='mkdir -p ~/Videos/yt-dlp-video && yt-dlp -f "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[height<=1080][ext=mp4]" --merge-output-format mp4 -o "~/Videos/yt-dlp-video/%(title)s.%(ext)s"'

# Download audio (best quality, mp3 format with thumbnail) to ~/Music/yt-dlp-audio/
alias yta='mkdir -p ~/Music/yt-dlp-audio && yt-dlp -f "ba" --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata -o "~/Music/yt-dlp-audio/%(title)s.%(ext)s"'


# Sortcuts
# alias gr='cd ~/Projects/FxP-Hyprland/'
# alias sf='cd ~/Projects/FxP-Hyprland/ && ./stow.sh'
# alias df='cd ~/Projects/FxP-Hyprland/dotfiles'
# alias gc='cd ~/Projects/FxP-Hyprland/dotfiles/.config'
# alias lc='cd ~/.config/'


alias sn='shutdown now'


#alias ct='/home/fxp/Projects/FxP-Hyprland/dotfiles/.config/fxp-hyprland/scripts/custom/theme-switcher/theme-switcher.sh'

#alias gp='/home/fxp/Projects/FxP-Hyprland/dotfiles/.config/fxp-hyprland/scripts/custom/Github-Auto-Pusher/github-pusher.sh'
