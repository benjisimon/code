##
## for working with images shown on the pimg stack
##

img_display() {
  top_url=$(stack_top)
  if [ -z "$top_url" ] ; then
    img_render $IMAGE_DIR/empty.jpgpng
  else
    wget -O $IMAGE_DIR/top.png -o $IMAGE_DIR/top.info $top_url
    img_render $IMAGE_DIR/top.png
  fi
}

img_render() {
  path=$1 ; shift;
  sudo fbi -vt 1 -a $path 2> $IMAGE_DIR/fbi.info
}
