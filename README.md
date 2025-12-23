# Personal dotfiles

    git clone --bare https://github.com/mfrsn/dots.git .dotfiles
    alias dots='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    dots checkout
