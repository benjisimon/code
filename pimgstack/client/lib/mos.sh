##
## Mosquitto helper functions
##

mos_sub() {
  topic="$1" ; shift
  mosquitto_sub -h $MOS_BROKER_IP -t $topic -C 1
}
