# Easier access to nvim
alias vi='nvim'

# nnn will open text files in the the text editor
alias nnn='nnn -e'

# ls
alias ls='eza -F'

# hidden ls
alias lsa='eza -F -a'

# long
alias l='eza -F -hl --git'

# hidden long
alias la='eza -F -hla --git'

# This also accepts flags -a for hidden, and -l for long output
alias tree='eza -Th -F --git -I .git'

# mein
alias se='fzf --height=30% --border=horizontal'
alias ys="yay -Slq | fzf -m --preview 'yay -Si {1}' --preview-window right:70% | yay -S --needed -"
alias ysr="yay -Qq | fzf -m --preview 'yay -Qi {1}' --preview-window right:70% | yay -Rsn -"
