# My dotfiles
Config files for programs to set up a system the way I like it.

Use `./bootstrap.sh` to symlink these configs to your user's config files.

## Programs
### Newsboat
[Newsboat](https://newsboat.org/) is an RSS/Atom feed reader for the text console. Apart from catching on news, I use this to check the prices of products I want to get. Check out the fantastic [RSS-Bridge](https://github.com/RSS-Bridge/rss-bridge) project.
I use this script,
```
newsboat() {
 echo "Initializing background process"
 /home/ritik/proj/flipkart_scraper/main.py > /dev/null 2>&1 &
 sleep 1
 command newsboat "$@"
 echo "Exiting"
 kill $!
}
```
to run a parser for scraping Flipkart for the price of the products. Check the code of the scraper [here](https://github.com/dev-ritik/Flipkart-Price-Tracker).

### Neofetch
[Neofetch](https://github.com/dylanaraps/neofetch) is this amazing tool for printing system information to the terminal when spawning a new one.
![My neofetch](https://user-images.githubusercontent.com/32809272/100095340-56176f00-2e80-11eb-8572-c94277092bee.png)

### lf
[lf](https://github.com/gokcehan/lf) (as in "list files") is a terminal file manager written in Go.
It supports preview for general file types as well.
_Good terminal-based image preview is yet to be added_
I have added a shell function
```
lc () {                        
    tmp="$(mktemp)"
    lf --last-dir-path="$tmp" "$@" 
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}
```
for using `q` as cd at exit [ref](https://github.com/gokcehan/lf/issues/140).

### Zathura
[Zathura](https://pwmt.org/projects/zathura/) is a highly customizable and functional document viewer, mainly PDFs. 

### Zsh
Zsh is a shell arguably better than bash for day to day stuff. It adds a lot of features to the shell experience. 
- No `oh-my-zsh` here. Sourcing stuff in rc files myself.
- Usual helpful shortcuts that `oh-my-zsh` provides
- `Powerline10k` theme
- `XDG` compliant environment variables
- Vi mode improvements
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh_command_not_found](https://packages.ubuntu.com/search?keywords=command-not-found)
- [zsh-you-should-use](https://github.com/MichaelAquilina/zsh-you-should-use)
- [history-substring-search](https://superuser.com/a/585004)
- Useful aliases
- `cless` and `ccat` for coloured formatted output
- Other rather personal aliases: weather, background blur camera, internet connectivity status, broadband connect, `newsboat`, wifi forwarder

### Bash
bash is the secondary shell and configs are light. Aliases and env files are sourced by both of them.
Hence some of the above features are shared here as well.
