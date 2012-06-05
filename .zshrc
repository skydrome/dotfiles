zstyle ':omz:*' case-sensitive 'no'
zstyle ':omz:*' color 'yes'

zstyle ':omz:load' omodule 'alias' 'bindkey' 'completion' 'environment' 'history' 'directory' 'prompt' 'git' 'pacman'
zstyle ':omz:module:prompt' theme 'steeef'

autoload omz && omz
source ~/.bashrc
