##
## stack related functions
##

do_push() {
  m=$1 ; shift;
  body=$(echo $m | sed 's/^push://')
  prep_stack
  (echo $body ; cat $STACK_FILE.last) > $STACK_FILE
}

do_pop() {
  prep_stack
  sed 1d $STACK_FILE.last > $STACK_FILE
}

do_clear() {
  prep_stack
  cp /dev/null $STACK_FILE
}

do_error() {
  m=$1 ; shift
  echo "Unknow stack op: $m" > /dev/stderr
}

prep_stack() {
  cp $STACK_FILE $STACK_FILE.last
}

stack_top() {
  sed -n 1p $STACK_FILE
}
