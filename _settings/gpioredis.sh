#!/bin/bash

redis-cli set aogpio 'xCORE USB Audio 2.0'
redis-cli set volumegpio 0

defaultIFS=$IFS
IFS=$'\n'

acards=( $( cat gpioarediscards.txt ) )
ilength=${#acards[@]}
for (( i = 0; i < $ilength; i+=2 )); do
    redis-cli hset acardsgpio "${acards[i]}" "${acards[i+1]}"
	redis-cli hset acards "${acards[i]}" "${acards[i+1]}"
done

mpdconf=( $( cat gpioredismpdconf.txt ) )
ilength=${#mpdconf[@]}
for (( i = 0; i < $ilength; i+=2 )); do
    redis-cli hset mpdconfgpio "${mpdconf[i]}" "${mpdconf[i+1]}"
done

IFS=$defaultIFS
