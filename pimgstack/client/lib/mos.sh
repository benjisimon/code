##
## Mosquitto helper functions
##

mos_sub() {
  mosquitto_sub -h $MOS_HOST -p $MOS_PORT $MOS_SSL -u $MOS_USER -P $MOS_PASSWORD -t $MOS_TOPIC -C 1
}

mos_pub() {
  message="$1" ; shift
  mosquitto_pub -h $MOS_HOST -p $MOS_PORT $MOS_SSL -u $MOS_USER -P $MOS_PASSWORD -t $MOS_TOPIC -m "$message"
}
