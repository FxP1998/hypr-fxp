# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/firebird/.zshrc'

autoload -Uz compinit
compinit

# End of lines added by compinstall
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# IGNORE THE WARNINGS
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)


# pfetch
pfetch


# Font Update
alias uf='fc-cache -fv && echo " Font cache updated."'

# Chance Directorys
alias c='cd ~/.config'
alias ec='nvim ~/.config/'
alias fxp='cd ~/.config/hypr/'
alias efxp='nvim ~/.config/hypr/'

# File preview (text/pdf/images) [require: chafa]
fp() {
    [ $# -eq 0 ] && echo "Usage: fp <file>" && return
    case $(file -b --mime-type "$1") in
        text/*) bat --style=numbers "$1";;          # Text files
        application/pdf) pdftotext "$1" -;;         # PDF files
        image/*) chafa "$1";;                       # Images
        *) echo "Preview not supported for $1";;    # Other types
    esac
}

# wf-recorder (wayland only)
rec-h() {
  # Define the output directory
  local output_dir="$HOME/Videos/wf-recorder"

  # Create the directory if it doesn't exist
  mkdir -p "$output_dir"

  # Get the current date and time for timestamp
  local timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

  # The filename argument (if provided)
  local filename="$1"

  # Check if a filename is provided, if not, use default
  if [[ -z "$filename" ]]; then
    filename="recording"
  fi

  # Final output file path with timestamp
  local output_file="$output_dir/${filename}_${timestamp}.mp4"

  # Record video with wf-recorder using internal audio, 60 FPS, and chosen filename
  wf-recorder -f "$output_file" --audio=alsa_output.pci-0000_00_1f.3.analog-stereo.monitor -r 60
}

# ffmpef screen recording (X11)
rec-b() {
  local output_dir="$HOME/Videos/ffmpeg-recordings"
  mkdir -p "$output_dir"
  local timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
  local filename="${1:-recording}"
  local output_file="$output_dir/${filename}_${timestamp}.mp4"

  # Get current screen resolution
  local resolution=$(xdpyinfo | grep dimensions | awk '{print $2}')

  # System audio source (not mic!)
  local audio_source="alsa_output.pci-0000_00_1f.3.analog-stereo.monitor"

  # Run ffmpeg to record screen + internal audio
  ffmpeg -video_size "$resolution" -framerate 60 -f x11grab -i "$DISPLAY" \
         -f pulse -i "$audio_source" \
         -c:v libx264 -preset veryfast -crf 23 \
         -c:a aac -b:a 192k \
         "$output_file"
}


# === yt-dlp ===
# Download video (max 1080p, mp4 format) to ~/Videos/yt-dlp-video/
alias ytv='mkdir -p ~/Videos/yt-dlp-video && yt-dlp -f "bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[height<=1080][ext=mp4]" --merge-output-format mp4 -o "~/Videos/yt-dlp-video/%(title)s.%(ext)s"'

# Download audio (best quality, mp3 format with thumbnail) to ~/Music/yt-dlp-audio/
alias yta='mkdir -p ~/Music/yt-dlp-audio && yt-dlp -f "ba" --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata -o "~/Music/yt-dlp-audio/%(title)s.%(ext)s"'



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


# Qt configuration aliases
alias qt5config='env QT_QPA_PLATFORM=xcb qt5ct'
alias qt6config='env QT_QPA_PLATFORM=xcb qt6ct'
alias qtconfig='env QT_QPA_PLATFORM=xcb qt6ct'

# Package Manager
# === pacman ===
alias i='sudo pacman -S --needed'
alias s='sudo pacman -Ss'
alias ip='pacman -Q'
alias ipd='pacman -Qi'
alias r='sudo pacman -Rns'
alias u='sudo pacman -Syyu'

# === yay ===
alias yi='sudo pacman -S --needed'
alias ys='sudo pacman -Ss'
alias yip='pacman -Q'
alias yipd='pacman -Qi'
alias yr='sudo pacman -Rns'
alias yu='yay -Syyu'

# === paru ===
alias pi='sudo pacman -S --needed'
alias ps='sudo pacman -Ss'
alias pip='pacman -Q'
alias pipd='pacman -Qi'
alias pr='sudo pacman -Rns'
alias pu='paru -Syyu'


alias sn='shutdown now'

# === Correct Setup for Your Intel HD 520 === 
export LIBVA_DRIVER_NAME=iHD
export VDPAU_DRIVER=va_gl


# Path Variable for cargo
export PATH="$PATH:$HOME/.cargo/bin"
