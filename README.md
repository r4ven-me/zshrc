> [!note]
> This repo is a part of the complete instruction on [r4ven.me](https://r4ven.me/en/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/).

This repo showcases my **Zsh** shell configuration, built with the **Oh-My-Zsh** framework. Check out the demo below; you might find it interesting. The terminal uses the Nord color palette.

---
## Demo

![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-2024-12-25-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-1.gif)

```bash
Tab
```

![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-2024-12-25-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-9.jpeg)

![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-2024-12-25-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-10.jpeg)

```bash
Ctrl+r
```

![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-2024-12-25-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-11.jpeg)

```bash
history
```

![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-2024-12-25-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-5.jpeg)

```bash
--help
```

![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-2024-12-25-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-15.jpeg)

```bash
cat
```

![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-2024-12-25-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-4.jpeg)

```bash
less
```

![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-2024-12-25-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-3.jpeg)

```bash
tail
```

![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-2024-12-25-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-14.jpeg)

```bash
tailf
```

![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-2024-12-25-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-2.jpeg)

```bash
ls
```

![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-2024-12-25-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-1.jpeg)

```bash
ss
```

![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-2024-12-25-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-12.jpeg)

```bash
ping
```

![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-2024-12-25-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-13.jpeg)

```bash
journalctl
```

![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-2024-12-25-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-16.jpeg)

```bash
docker
```

![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-2024-12-25-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-17.jpeg)

Convenient access to custom complex commands via the universal `cmd` function:
 ![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-1.gif)

And much more. Now let's move on to preparation and installation.

---

## Install powerline font

My readers know that I prefer the **Hack** font ☝️. Here's a simple example of how to install it:

```bash
# create font directory
sudo mkdir /usr/share/fonts/Hack

# download font archive
curl -fsSLO \
    $(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
    | grep browser_download_url \
    | grep 'Hack.zip' \
    | cut -d  '"' -f 4)

# unpack the archive, copy fonts to the system
sudo unzip ./Hack.zip -d /usr/share/fonts/Hack/ && rm -f ./Hack.zip
```

![](https://r4ven.me/images/font/1.jpeg)

After installing the font, activate it in your terminal settings🛠.

In **Gnome-terminal**, this is done as follows:

![](https://r4ven.me/images/font/2.jpeg)


## Install config

```bash {collapsed=true}
# install necessary utilities
sudo apt update && sudo apt install -y git curl zsh

# for a "colorful" terminal, install bat, exa, and grc
sudo apt install -y bat exa fzf grc || sudo apt install -y bat eza fzf grc

# backup existing .zshrc
[[ -f ~/.zshrc ]] && mv -v ~/.zshrc{,_backup}

# download ready .zshrc
curl -fsSL --output ~/.zshrc \
    https://raw.githubusercontent.com/r4ven-me/zshrc/main/.zshrc

# change default shell
[[ $SHELL == *zsh ]] || chsh -s /usr/bin/zsh

# apply changes for current session
exec zsh
```

 <details>
   <summary>Configuration description</summary>
This section provides a block-by-block🧱 description of the `.zshrc` file, detailing what this configuration changes/supplements in the behavior of the ZSH shell.

**GENERAL SETTINGS**🛠

- Adding user directories `bin`, `.bin`, `.local/bin` to the `PATH` variable to simplify access to user scripts;
- setting environment variables for `oh-my-zsh` (`ZSH`, `ZSH_CUSTOM`) and correct color support in the terminal (`TERM`);
- shell theme selection depending on the environment:
- `agnoster-r4ven` — for GUI and pseudo-terminal sessions (PTS);
- `dpoggi` (without icons) — for console sessions (TTY);
- disabling automatic `oh-my-zsh` updates (manual update command: `omz update`);
- command history configuration:
- storing up to 10,000 commands;
- adding timestamps in `yyyy-mm-dd` format;
- ignoring duplicate entries and commands starting with a space;
- shared history between terminal sessions🔥.

**PLUGINS**🗃

The following plugins are used to improve shell operation:

- `fzf` — command history search using the `fzf --exact` utility via `Ctrl+r`;
- `git` — aliases and utilities for working with Git;
- `sudo` — quick execution of the last/current command with [sudo](https://r4ven.me/it-razdel/zametki/komandnaya-stroka-linux-povyshenie-privilegij-komandy-su-sudo/) by double-pressing `Esc`;
- `docker`, `kubectl` — auxiliary commands for [Docker](https://r4ven.me/it-razdel/instrukcii/ustanovka-docker-engine-na-linux-server-pod-upravleniem-debian/) and Kubernetes;
- `cmdtime` — command execution time measurement (displayed at the end of the last line);
- `zsh-autopair` — automatic closing of parentheses and quotes during command input;
- `zsh-completions` — extended auto-completions via `Tab`, including subcommands and command options;
- `zsh-autosuggestions` — highlighted suggestions based on command history;
- `fast-syntax-highlighting` — command syntax highlighting;
- `history-substring-search` — history search when typing part of a command using `up`/`down` arrows.

A few usage examples:

- `Ctrl+r` — invoke `fzf` to search for a command from history;
- when typing part of a command, press `Tab` for extended auto-completion (subcommands, file names, or command options);
- when typing part of a command, press `up` to find similar commands from history.

**APPLICATIONS AND UTILITIES**🧑‍💻

- Aliases are set to simplify frequently used commands:
- `python` -> `python3`;
- quick ping of Google DNS server with command `p8`, highlighting of `ip` command output;
- default editor selection (`nvim` or `vim`) + convenient aliases;
- `Nord` color palette installation for the `fzf` utility;
- using `bat`/`batcat` as a replacement for `cat`, `less`, `man`, `--help`, and `tail -f` with `Nord` theme color highlighting;
- replacing `ls` command with `exa`/`eza` with improved display options (long list, tree output, sorting).

> For more details on bat and exa, see the article: [bat, exa – syntax highlighting for standard output in Linux terminal (cat, less, tail, and ls)](https://r4ven.me/it-razdel/poleznoe-po/bat-exa-podsvetka-sintaksisa-standartnogo-vyvoda-v-terminale-linux-cat-less-tail-i-ls/).

**AUTOMATIC INSTALLATION**🦾

When the shell starts, it automatically checks for and installs `oh-my-zsh` and missing plugins (`zsh-autopair`, `zsh-completions`, `zsh-autosuggestions`, `fast-syntax-highlighting`).

**FAST CALL FUNCTION FOR CUSTOM COMMANDS — cmd**

What the function does:

- contains an array of short key-command names, whose values contain, often complex, commands;
- displays the entire list of available commands using the `-h` flag;
- supports interactivity by cycling through options using the `Tab` key;
- after pressing Enter, the command is not executed, but rather entered as the next command without execution, so it can be edited if necessary.

How such a command/function works:

![](https://r4ven.me/dots/tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh/attachments/r4ven-me-tonkaya-nastrojka-zshrc-pri-ispolzovanii-oh-my-zsh-1.gif)

You only need to populate the `cmd_list` array with your commands, in the format:

```bash
short_name "long_command"
```

> Shell-sensitive special characters used in complex commands must be escaped. In some cases, using quotes, in others, using a backslash. Example: `\$`

**SHELL PROMPT**👋

The display of `user@host` is removed from the shell prompt if a [graphical environment](https://r4ven.me/it-razdel/slovarik/okruzhenie-rabochego-stola/) is used.
 </details>
 