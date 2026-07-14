# Enable Powerlevel10k instant prompt. Should stay close to the top of
# ~/.zshrc. Initialization code that may require console input (password
# prompts, [y/n] confirmations, etc.) must go above this block; everything
# else is fine below it.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#============================================
# Desc: .zshrc config for oh-my-zsh 
# Author: Ivan Cherniy
# Main site: https://r4ven.me
# Config note: https://r4ven.me/zshrc-config
#============================================

#============================================
#             COMMON SETTINGS
#============================================

if [[ -d "$HOME/.config/environment.d" ]]; then
    for file in "$HOME"/.config/environment.d/*.conf(N); do
        set -a
        source "$file"
        set +a
    done
fi

_zshrc_term="${TERM:-}"
if [[ -r "${HOME}"/.profile ]]; then
    source "${HOME}"/.profile               # Source '.profile' if it exists
fi

[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# Add custom directories to PATH and keep entries unique.
typeset -U path PATH
for dir in "$HOME/bin" "$HOME/.bin" "$HOME/.local/bin"; do
    [[ -d "$dir" ]] && path=("$dir" "${path[@]}")
done
export PATH

export ZSH="$HOME/.config/oh-my-zsh"       # Path to Oh My Zsh installation
export ZSH_CUSTOM="$ZSH/custom"            # Path to Oh My Zsh custom dir

# Keep TERM from the terminal emulator/tmux. A forced TERM can break prompt width.
if [[ -n "$_zshrc_term" && "$_zshrc_term" != "dumb" ]]; then
    export TERM="$_zshrc_term"
elif [[ -z "$TERM" || "$TERM" == "dumb" || ( "$TERM" == "screen-256color" && -z "$TMUX" ) ]]; then
    export TERM="xterm-256color"
else
    export TERM
fi
unset _zshrc_term

have() {
    (( $# )) || return 1
    local utils=("$@")
    for util in "${utils[@]}"; do
        [[ -n "$util" ]] || return 1
        if ! command -v "$util" &> /dev/null; then return 1; fi
    done
    return 0
}

cmd_alias() {
  local cmd="$1"
  shift
  local replacement=( "$@" )
  [[ -n "$cmd" && ${#replacement[@]} -gt 0 ]] || return 1
  if alias "$cmd" &> /dev/null; then unalias "$cmd"; fi
  if functions "$cmd" &> /dev/null; then unset -f "$cmd"; fi
  eval "$cmd() { command ${(@q)replacement} \"\$@\"; }"
}

# Autoinstall oh-my-zsh framework
if [[  ! -d "$ZSH" ]] && have "git"; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"
fi

# Oh-my-zsh theme selection
# Find more themes: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
if [[ -n "$DISPLAY" || $(tty) == /dev/pts* ]] && have "git"; then
    if [[ ! -d "${ZSH_CUSTOM}/themes/powerlevel10k" ]]; then
        git clone \
            https://github.com/romkatv/powerlevel10k.git \
            "${ZSH_CUSTOM}"/themes/powerlevel10k
    fi
    # export VIRTUAL_ENV_DISABLE_PROMPT=1  # Disable default virtualenv prompt
    ZSH_THEME="powerlevel10k/powerlevel10k"
else
    ZSH_THEME="dpoggi"                     # Use the 'noicon' theme in other cases, e.g. in console (tty)
fi

# Powerlevel10k theme (requires installation)
# https://github.com/romkatv/powerlevel10k
# ZSH_THEME="powerlevel10k/powerlevel10k"

DISABLE_AUTO_UPDATE="true"                  # Disable automatic updates for Oh My Zsh (cmd: omz update)
DISABLE_AUTO_TITLE="true"                   # Don't print command title escape sequences
COMPLETION_WAITING_DOTS="true"              # Show dots while completing commands

# Command History Configuration
HIST_STAMPS="yyyy-mm-dd"                    # Add timestamp to command history
HISTFILE=~/.zsh_history                     # File to save history
HISTSIZE=50000                              # Max number of history entries in memory
SAVEHIST=50000                              # Max number of history entries to save to file
setopt hist_ignore_all_dups                 # Ignore duplicate entries in history
setopt share_history                        # Share history between sessions
setopt histignorespace                      # Ignore commands starting with a space

# Enable vi-mode for the command line (default is emacs mode)
# set -o vi

#============================================
#                  PLUGINS
#============================================

plugins=(
    fzf                        # Fuzzy finder integration (Ctrl+r)
    git                        # Git aliases and functions
    sudo                       # Run/repeat last command with sudo (duble Esc)
    docker                     # Docker command-line helper
    kubectl                    # Kubernetes command-line helper
    # zsh-autopair               # Auto-close parentheses and quotes
    zsh-completions            # Additional completion scripts (Tab)
    zsh-autosuggestions        # Suggest commands based on history
    fast-syntax-highlighting   # Syntax highlighting for commands
    history-substring-search   # Search history with substring matches (up/down arrows)
)

# zsh-autopair: disable this plugin in MidnightCommander
# if ! [[ $(ps -o comm -h $PPID) =~ "^mc" ]]; then
#     plugins+=(zsh-autopair)
# fi

# Autoinstall selected plugins
if [[ -d "$ZSH_CUSTOM" ]] && have "git"; then
    if [[ ! -d "${ZSH_CUSTOM}"/plugins/zsh-autopair ]]; then
        git clone https://github.com/hlissner/zsh-autopair \
            "${ZSH_CUSTOM}"/plugins/zsh-autopair
    fi
    
    if [[ ! -d "${ZSH_CUSTOM}"/plugins/zsh-completions ]]; then
        git clone https://github.com/zsh-users/zsh-completions \
            "${ZSH_CUSTOM}"/plugins/zsh-completions
    fi
    
    if [[ ! -d "${ZSH_CUSTOM}"/plugins/zsh-autosuggestions ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions \
            "${ZSH_CUSTOM}"/plugins/zsh-autosuggestions
    fi
    
    if [[ ! -d "${ZSH_CUSTOM}"/plugins/fast-syntax-highlighting ]]; then
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting \
            "${ZSH_CUSTOM}"/plugins/fast-syntax-highlighting
    fi
fi

#============================================
#              INIT OH-MY-ZSH
#============================================

# Rehash automatically so newly installed binaries show up in Tab completion
# without starting a new shell or running `rehash` manually.
zstyle ':completion:*' rehash true

[[ -r "${ZSH}"/oh-my-zsh.sh ]] && source "${ZSH}"/oh-my-zsh.sh

#============================================
#              APPS AND UTILS
#============================================

# Python
cmd_alias "python" "python3"

# Network
cmd_alias "p8" "ping" "-c3" "8.8.8.8"
cmd_alias "ip" "ip" "--color"

# Configure code editor
if have "nvim"; then
    export EDITOR="$(command -v nvim)"
    export VISUAL="$(command -v nvim)"
    alias vim="nvim"
    alias n="nvim"
    alias N="sudo nvim"
elif have "vim"; then
    export EDITOR="$(command -v vim)"
    export VISUAL="$(command -v vim)"
    alias v="vim"
    alias V="sudo vim"
fi

# Configure FZF with Nord theme colors
if have "fzf"; then
    export FZF_DEFAULT_OPTS="--exact"
    export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
        --color=fg:#e5e9f0,bg:#2e3440,hl:#81a1c1
        --color=fg+:#e5e9f0,bg+:#2e3440,hl+:#81a1c1
        --color=info:#eacb8a,prompt:#bf6069,pointer:#b48dac
        --color=marker:#a3be8b,spinner:#b48dac,header:#a3be8b
        --color=border:#5e81ac
        --border=rounded
    '
    # export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    #     --color=fg:#ebdbb2,bg:#282828,hl:#83a598
    #     --color=fg+:#ebdbb2,bg+:#32302f,hl+:#83a598
    #     --color=info:#fabd2f,prompt:#fb4934,pointer:#d3869b
    #     --color=marker:#b8bb26,spinner:#8ec07c,header:#b8bb26
    #     --color=border:#83a598
    #     --border=rounded
    # '
fi

# Defining a variable with the name of the utility: bat or batcat
if have "batcat"; then
    _bat="batcat"
elif have "bat"; then
    _bat="bat"
else
    _bat=""
fi

# Usage bat instead of cat, less, man, --help, tail -f
# See more: https://r4ven.me/bat-exa-config
if have "$_bat"; then
    # export COLORTERM="truecolor"
    export BAT_THEME="Nord"
    # export BAT_THEME="gruvbox-dark"
    # less's default search-match highlight ("standout") is documented to not
    # apply to text already colored via ANSI escapes (-R) — which is exactly
    # what bat outputs — so `/search` finds matches but never highlights them.
    # --use-color turns on less's own color-based UI highlighting instead,
    # which does render correctly on top of ANSI-colored input; -DSkY sets its
    # "search results" (S) color to black-on-bright-yellow.
    export BAT_PAGER="less -R --use-color -DSkY"
    export MANPAGER="sh -c 'col -bx | $_bat --language=man --style=plain'"  # Command to view man pages
    export MANROFFOPT="-c"  # Disabling line wrapping in man
    cmd_alias "cat" "$_bat" "--style=plain" "--paging=never"
    cmd_alias "less" "$_bat" "--paging=always"
    alias -g -- --help='--help 2>&1 | "$_bat" --language=help --style=plain'
    help() { "$@" --help 2>&1 | "$_bat" --language=help --style=plain; }
    tailf() { tail -f "$@" | "$_bat" --paging=never --language=log; }
    batdiff() { git diff --name-only --relative --diff-filter=d | xargs "$_bat" --diff; }
fi

# Usage exa instead of ls
# See more: https://r4ven.me/bat-exa-config
_exa=""
if have "exa"; then
    _exa="exa"
elif have "eza"; then
    _exa="eza"
fi

if have "$_exa"; then
    if [[ -n "$DISPLAY" || $(tty) == /dev/pts* ]]; then # display icons if pseudo terminal
        cmd_alias "ls" "$_exa" "--group" "--header" "--icons" "--time-style=long-iso"
    else
        cmd_alias "ls" "$_exa" "--group" "--header" "--time-style=long-iso"
    fi
    alias l="ls"
    alias ll="ls --long"
    alias lll="ls --long --all"
    alias llll="ls -lbHigUmuSa --sort=modified --time-style=long-iso"
    alias lm="ls --long --all --sort=modified"
    alias lt="ls --tree"
    alias lr="ls --recurse"
    alias lg="ls --long --git --sort=modified"
fi

# Highlight the output of various commands
# Note: no `tty -s` guard here — grc already detects a non-terminal stdout on its
# own and skips colorizing, and gating alias *creation* on the tty at shell
# startup broke coloring entirely whenever stdout wasn't a tty at that moment
# (e.g. under Powerlevel10k instant prompt, which temporarily redirects it).
if have "grc" && [[ -n "$TERM" && "$TERM" != dumb ]]; then
    GRC_UTILS=(
        configure ping traceroute gcc make netstat stat ss diff
        wdiff last who cvs mount findmnt mtr ps dig ifconfig
        df du env systemctl iptables lspci lsblk lsof blkid
        id iostat sar fdisk free docker journalctl kubectl
        sensors sysctl tail head tcpdump tune2fs lsmod lsattr
        semanage getsebool vmstat dnf nmap uptime w
        getfacl ntpdate showmount apache iwconfig lolcat whois
        go sockstat
        #ls ip
    )
    for cmd in "${GRC_UTILS[@]}"; do
        if have "$cmd"; then
            cmd_alias "$cmd" "grc" "--stderr" "--stdout" "$cmd"
        fi
    done
fi

# APT
if have "apt"; then
    alias AU="sudo apt update"
    alias AUP="sudo apt upgrade"
    alias AR="sudo apt autoremove"
    alias AI="sudo apt install"
    alias AUI="sudo apt update && sudo apt install"
fi

# Ansible
if have "ansible"; then
    AP() { ansible-playbook ~/ansible/playbooks/"$@"; }
    alias AC="ansible-console"
fi

# Tmux
if have "tmux"; then
    alias T="tmux attach -t Work || tmux new -s Work"
    alias TT="sudo tmux attach -t Work! || sudo tmux new -s Work!"
fi

# ShellGPT 
if have "sgpt"; then
    export LITELLM_LOG="ERROR"
    G() { sgpt --chat temp "$*"; }
    GS() { sgpt --shell "$*"; }
    GC() { 
        echo ""
        sgpt --code --no-md "$*" | "$_bat" --language=sh --paging=never --style=plain
        echo ""
    }
    alias GG="sgpt --repl temp"
fi

# Minio
if have "minio-client"; then
    alias mc="minio-client"
fi

# Define the 'cmd' function, which exec cistom commands form list
# It takes one argument - the command name and insert it to command line
# User TAB key for suggestion
cmd() {
    local cmd_name="${1}"
    typeset -A cmd_list

    # Associative array to store the list of commands
    # Keys are command names, values are the actual commands
    cmd_list=(
        ps_top5_cpu "ps --sort=-%cpu -eo user,pid,ppid,state,comm | head -n6"
        ps_top5_mem "ps --sort=-%mem -eo user,pid,ppid,state,comm | head -n6"
        ps_zombie "ps -eo user,pid,ppid,state,comm | awk '\$4=="Z" {print \$3}'"
        cron_add_task '{ crontab -l; echo "0 3 * * 0 ls -l &> dirs.txt"; } | crontab -'
        du_top20 'du -x -h / 2> /dev/null | sort -rh | head -n 20'
        df_80 "df -h | awk '\$5 ~ /^8[0-9]%/ {print \$6}'"
        git_init 'git init --initial-branch=main && git remote add origin ssh://git@github.com/r4ven-me/reponame.git'
        journal_vacuum 'journalctl --vacuum-size=800M'
        lsof_opened 'lsof +D /opt'
    )

    # Check if the command exists in the array, or if help is requested
    if [[ -z ${cmd_list[$cmd_name]} || -z "$cmd_name" || "$cmd_name" == "-h" ]]; then
        # Display the list of available commands
        echo "AVAILABLE COMMANDS:\n"
        printf "%-20s %s\n" "Key" "Command"
        echo "----------------------------"
        # Iterate over all keys in the array and display them
        for key in "${(@k)cmd_list}"; do
            printf "%-20s %s\n" "$key" "${cmd_list[$key]}"
            # echo "------------------"
        done | sort
        return 0
    else
        # If the command is found, insert it into the command line
        print -zr "${cmd_list[$cmd_name]}"
        return 0
    fi
}

# Function for command autocompletion
_cmd_completion() {
    local -a keys
    keys=($(cmd -h | awk 'NR>4 {print $1}'))  # Extract keys from help output
    compadd "$@" -- "${keys[@]}"
}

# Register the autocompletion function for the `cmd` command
(( $+functions[compdef] )) && compdef _cmd_completion cmd

# # Autocompletion for ansible
# _get_ansible_hosts() {
#     local IFS=$'\n'
#     for host in $(grep -oP '^\s*\K\S+' ~/Ansible/inventory.yml | sort -u); do
#         echo "$host"
#     done
# }

# _ansible_hosts_completion() {
#     local -a hosts
#     hosts=("${(f)$(_get_ansible_hosts)}")
#     _values 'ansible hosts' $hosts
# }

# compdef _ansible_hosts_completion ssh
# compdef _ansible_hosts_completion scp
# compdef _ansible_hosts_completion rsync
# compdef _ansible_hosts_completion ansible
# compdef _ansible_hosts_completion ansible-playbook

#============================================
#                  PROMPT
#============================================

# Remove user@host context from the prompt when DISPLAY is set
# if [[ -n "$DISPLAY" && -z "$SSH_CONNECTION" ]]; then
#     prompt_context() { }                    # Empty function to disable context
# fi

# Powerlevel10k config lives in its own file so it can be regenerated with
# `p10k configure` without touching the rest of this .zshrc. If it's missing
# (e.g. fresh machine), fetch the tracked copy from GitHub before sourcing it.
P10K_CONFIG="$HOME/.p10k.zsh"
P10K_CONFIG_URL="https://raw.githubusercontent.com/r4ven-me/zshrc/main/.p10k.zsh"

if [[ ! -r "$P10K_CONFIG" && -n "$P10K_CONFIG_URL" ]] && have "curl"; then
    curl -fsSL "$P10K_CONFIG_URL" -o "$P10K_CONFIG"
fi

[[ ! -r "$P10K_CONFIG" ]] || source "$P10K_CONFIG"
unset P10K_CONFIG P10K_CONFIG_URL

export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim
unset XMODIFIERS
