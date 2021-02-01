#!/bin/bash

##
## This guys runs on the Raspberry Pi and pulls stack
## instructions from the queue
##

MOS_BROKER_IP=100.25.165.97
STACK_FILE=$HOME/.pimg.stack
IMAGE_DIR=$(dirname $0)/img

. $(dirname $0)/lib/mos.sh
. $(dirname $0)/lib/stack.sh
. $(dirname $0)/lib/image.sh

img_display

while true; do
  message=$(mos_sub pimgstack/1)
  case $message in
    push:*)
      do_push $message
      ;;

    pop)
      do_pop
      ;;

    clear)
      do_clear
      ;;
    *)
      do_error $message
      ;;
  esac
  img_display
done
