#!/bin/sh
# Example Bar Action Script for OpenBSD-current.
#
set -Eeuo pipefail

print_date() {
	# The date is printed to the status bar by default.
	# To print the date through this script, set clock_enabled to 0
	# in spectrwm.conf.  Uncomment "print_date" below.
	FORMAT="%a %b %d %R %Z %Y"
	DATE=$(date "+${FORMAT}")
	echo -n "${DATE}     "
}

print_proc() {
	MEM=$(top | grep 'processes' | awk -F ' ' '{ print $1 }')
	echo -n " Runing proc: $MEM" 
}


print_wlan() {
	PUBLIC_IP=$1
	WLAN=$(ifconfig wlan0 | grep 'ssid' | awk -F ' ' '{ print $2 }')

	echo -n " WLAN: $WLAN"
	echo -n " IP: $PUBLIC_IP"
}

print_bat() {
	BAT_STATUS=$2
	BAT_LEVEL=$3
	AC_STATUS=$1

	if [ $AC_STATUS -ne 255 -o $BAT_STATUS -lt 4 ]; then
		if [ $AC_STATUS -eq 0 ]; then
			echo -n "on battery (${BAT_LEVEL}%)"
		else
			case $AC_STATUS in
			1)
				AC_STRING="on AC: "
				;;
			2)
				AC_STRING="on backup AC: "
				;;
			*)
				AC_STRING=""
				;;
			esac;
			case $BAT_STATUS in
			4)
				BAT_STRING="(no battery)"
				;;
			[0-3])
		 		BAT_STRING="(battery ${BAT_LEVEL}%)"
				;;
			*)
				BAT_STRING="(battery unknown)"
				;;
			esac;

			FULL="${AC_STRING}${BAT_STRING}"
			if [ "$FULL" != "" ]; then
				echo -n " $FULL"
			fi
		fi
	fi
}

# cache the output of apm(8), no need to call that every second.
SLEEP_SEC=5
while :; do
	APM_DATA=$(apm -alb)
	PUBLIC_IP=$(curl ipecho.net/plain --no-progress-meter)
	# print_date
	print_proc
	print_wlan $PUBLIC_IP
	#print_bat $APM_DATA

	echo ""
	
	sleep $SLEEP_SEC
done
