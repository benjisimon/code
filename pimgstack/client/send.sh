##
## Command line tool to send messages to a pimg stack
##

. $HOME/.pimg.settings
. $(dirname $0)/lib/mos.sh

usage() {
  echo "Usage: $(basename $0) {push|pop|clear} [url]"
  exit 1
}

action="$1" ; shift

case "$action" in
  push)
    url="$1"
    if [ -z "$url" ]; then
      usage
    fi

    mos_pub "push:$url"
    ;;

  pop)
    mos_pub "pop"
    ;;

  clear)
    mos_pub "clear"
    ;;

  *)
    usage
esac

    
