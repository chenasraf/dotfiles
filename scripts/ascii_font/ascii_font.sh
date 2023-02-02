# ascii-font() {
dir="$DOTFILES/scripts/ascii_font"
font="$dir/fonts/Big-Money-ne"
size=1
color=""
bg=""
bold=""
reset="$(tput sgr0)"

while [ $# -gt 0 ]; do
  case "$1" in
  -f | --font)
    font="$2"
    shift 2
    ;;
  -s | --size)
    size="$2"
    shift 2
    ;;
  -c | --color)
    if [[ $2 == "rainbow" ]]; then
      color="rainbow"
    else
      color="$(tput setaf $2)"
    fi
    shift 2
    ;;
  -b | --bg)
    bg="$(tput setab $2)"
    shift 2
    ;;
  -B | --bold)
    bold="$(tput bold)"
    shift
    ;;
  # -l | --list)
  #   # figlet -l
  #   return 0
  #   ;;
  -v | --version)
    echo "ascii-font 1.0.0"
    echo "Written by Chen Asraf <casraf@pm.me>"
    return 0
    ;;
  -h | --help)
    echo "Usage: ascii-font [OPTION]... [TEXT]..."
    echo "Convert text to ASCII art."
    echo
    echo "  -h, --help        display this help and exit"
    echo "  -f, --font        specify font (default: standard)"
    echo "  -s, --size        specify font size (default: 1)"
    echo "  -c, --color       specify font color (default: 0)"
    echo "  -b, --bg          specify background color (default: 0)"
    echo "  -B, --bold        set font bold"
    echo "  -C, --no-center   Disable centering the text"
    # echo "  -l, --list        list available fonts"
    echo "  -v, --version     display version information and exit"
    echo
    echo "See color options at:"
    echo "  $(tput smul)https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit"
    echo
    echo "Report bugs to Chen Asraf <casraf@pm.me>"
    return 0
    ;;
  *)
    break
    ;;
  esac

done

if [[ ! -f $(which figlet) ]]; then
  brew install figlet
fi

if [[ $color != "rainbow" ]]; then
  echo "$bold$color$bg$(figlet -f $font -w $(tput cols) -c "$@")$reset"
else
  echo "$bold$bg$(figlet -f $font -w $(tput cols) -c "$@" | lolcat -f)$reset"
fi
# }
