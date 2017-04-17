#!/bin/bash
#
# RPI Setup - Bash script that sets the locale, keyboard, time zone, 
#             hostname, password, and autologin settings.
#
# Author: Stacey M. Sharp, Jr. (github.com/ssharpjr)
# Revision: 17-APR-2017


# Set the following variables
NEWHOSTNAME="newrpi"
NEWPASSWORD="changeme"

echo
echo Running RPI Setup

# Set Locale
echo
echo Setting Locale...
sudo sed -i 's/# en_US.UTF-8/en_US.UTF-8/g' /etc/locale.gen
sudo sed -i 's/en_GB.UTF-8/# en_GB.UTF-8/g' /etc/locale.gen
echo LANG="en_US.UTF-8" | sudo tee /etc/default/locale
sudo locale-gen en_US.UTF-8
sudo update-locale

# Set Keyboard
echo
echo Setting Keyboard...
echo XKBMODEL="pc104" | sudo tee /etc/default/keyboard
echo XKBLAYOUT="us" | sudo tee --append /etc/default/keyboard

# Set Time Zone
echo
echo Setting Time Zone...
echo "US\Eastern" | sudo tee /etc/timezone

# Enable SSH
sudo update-rc.d ssh enable
sudo update-rc.d ssh start

# Change Pi User Password
echo
echo Changing PI Password
# change this to just 'passwd' if you want to be prompted for the password
echo "pi:$NEWPASSWORD" | sudo chpasswd

# Set Hostname
echo
echo Setting Hostname
sudo sed -i 's/127\.0\.1\.1\traspberrypi/127\.0\.1\.1\t'"$NEWHOSTNAME"'/g' \
/etc/hosts
echo $NEWHOSTNAME | sudo tee /etc/hostname > /dev/null
HOSTNAME=$NEWHOSTNAME
sudo /etc/init.d/hostname.sh

# Set AutoLogin
echo
echo Setting AutoLogin
sudo sed -i 's/ExecStart=-\/sbin\/agetty --noclear \%I \$TERM/ExecStart=-\/sbin\/agetty --autologin pi --noclear \%I \$TERM/g' \
/etc/systemd/system/autologin@.service
sudo rm -rf /etc/systemd/system/getty.target.wants/getty@tty1.service
sudo systemctl set-default multiuser.target
sudo ln -fs /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty1.service

# Reboot
echo
echo Rebooting in 5 seconds...
sleep 5
sudo reboot
