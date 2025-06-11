#!/bin/bash

DEVICE="/dev/cu.usbserial-10"  # Adjust this to your actual device (check with `ls /dev/tty.*`)
BAUDRATE="9600"

# Setup serial port
stty -f "$DEVICE" $BAUDRATE cs8 -cstopb -parenb -echo

# Clear input buffer
cat < "$DEVICE" & PID=$!
sleep 1
kill $PID

# Send commands
{
  echo -e "AT\r"
  sleep 1
  echo -e "AT+CMGF=1\r"
  sleep 1
  echo -e "AT+CMGL=\"ALL\"\r"
} > "$DEVICE"

# Read response line by line until "OK"
while IFS= read -r line < "$DEVICE"; do
  echo "$line"
  [[ "$line" == "OK" ]] && break
done
