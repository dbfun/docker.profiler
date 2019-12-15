#!/bin/bash

trap "service apache2 stop; exit 0" TERM

service apache2 start

while true; do sleep 60; done
