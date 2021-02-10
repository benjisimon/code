##
## Mosquitto helper functions
##

mos_sub() {
  topic="$1" ; shift
  mosquitto_sub -h $MOS_HOST -p $MOS_PORT $MOS_SSL -u $MOS_USER -P $MOS_PASSWORD -t $MOS_TOPIC -C 1
}
