function precmd {
  _title "%15<..<%~%<<" "%n@%m: %~"
}

function preexec {
  local cmd=${1[(wr)^(*=*|sudo|ssh|-*)]}
  _title "%100>...>$2%<<" "$cmd"
}

function _title {
  case $TERM in
  termite|vte*|*xterm*|rxvt*|(dt|k|E)term)
      print -Pn "\e]2;$2:q\a"
      print -Pn "\e]1;$1:q\a"
      ;;
  esac
}
