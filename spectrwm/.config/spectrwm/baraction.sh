#!/bin/sh
# Example Bar Action Script for OpenBSD-current.
#

print_date() {
	# The date is printed to the status bar by default.
	# To print the date through this script, set clock_enabled to 0
	# in spectrwm.conf.  Uncomment "print_date" below.
	FORMAT="%a %b %d %R %Z %Y"
	DATE=`date "+${FORMAT}"`
	echo -n "${DATE}     "
}

print_mem() {
	MEM=`/usr/bin/top | grep Free: | cut -d " " -f6`
	echo -n "Free mem: $MEM  "
}


print_wlan() {
	WLAN=`ifconfig wlan0 | grep 'ssid' | awk -F ' ' '{ print $2 }'`
	PUBLIC_IP=`curl ipecho.net/plain; echo`
	echo -n "WLAN:" $WLAN " "
	echo -n "IP:" $PUBLIC_IP " "
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
				echo -n "$FULL"
			fi
		fi
	fi
}

# cache the output of apm(8), no need to call that every second.
while :; do
	IOSTAT_DATA=`iostat -C | grep '[0-9]$'`
	APM_DATA=`apm -alb`
	# print_date
	print_mem
	print_wlan
	print_bat $APM_DATA
	echo ""
	
	sleep 10
done
