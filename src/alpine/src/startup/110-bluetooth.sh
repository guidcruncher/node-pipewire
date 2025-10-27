#!/bin/bash

hciconfig hci0 down
hciconfig hci0 up

rc-service bluetooth start 
