# ipick

An fzf-based interactive file and directory picker for the command line.

![Screenshot](static/3.png?raw=true)
![Screenshot](static/2.png?raw=true)
![Screenshot](static/1.png?raw=true)

## Features

- Preview files (including images) and directories before selection
- Fuzzy search functionality powered by `fzf`
- Symlink resolution

## Requirements

- [`eza`](https://github.com/eza-community/eza)
- [`fzf`](https://github.com/junegunn/fzf)
- [`bat`](https://github.com/sharkdp/bat)
- [`bat`](https://github.com/sharkdp/bat)
- [`chafa`](https://github.com/hpjansson/chafa/) (optional, for image preview)
- [`icat`](https://sw.kovidgoyal.net/kitty/kittens/icat/) (optional, for image preview)

## Installation

Download and source it in your shell configuration file:

```bash
if [ ! -f ~/.local/bin/ipick.sh ]; then
  mkdir -p ~/.local/bin
  curl -s https://raw.githubusercontent.com/tonypan2/ipick/refs/heads/main/ipick.sh > ~/.local/bin/ipick.sh
fi

source ~/.local/bin/ipick.sh
```

## Usage

```bash
# Launch ipick in the current directory and open the selected file in vim
vim $(ipick)
```

```bash
# Launch ipick in a specific directory and copy the selected file to another location
ipick /path/to/directory | xargs -I {} cp {} ~/path/to/destination/
```

## Support

- OS: macOS, Ubuntu
- Shell: bash, zsh
