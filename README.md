# Headless Raspberry Pi Setup

### Enable SSH
Using a clean Raspian install, create (touch) a blank file called 'ssh' on the /boot partition.
Raspbian will see this and enable SSH by default.


### Setup WiFi
Create a file called 'wpa_supplicant.conf' on the /boot partition with the following contents.

```code
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  ssid="<YOUR_SSID>"
  psk="<YOUR_PASSWORD>"
}
```

Use your SSID and Password.  Raspbian will see this file and copy it to /etc/wpa_supplicant.


### SSH into your Raspberry Pi
```shell
ssh pi@raspberrypi.local
```
(or use the IP address)


### Update/Upgrade
Update and upgrade all Raspbian software
```shell
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get autoremove -y && sudo apt-get autoclean && sync
```
This will ensure you are fully up to date (except the kernel which shouldn't matter in most cases) and lean.


### Optional: Update the Kernel
If you know what you are doing and know why you are doing it, update the kernel, modules, and firmware as well.
Install and run rpi-update
```shell
sudo apt-get install rpi-update -y
sudo rpi-update
```

Choose YES for updating the kernel if you are prompted.
Reboot the Pi.


### Raspi-Config
Run Raspi-Config (reboot the Pi first if you chose to update the kernel)

```shell
sudo raspi-config
```

Make the following recommended changes:
1. Change User Password
2. Change Hostname
3. Boot Options
  * Depending on your project, B2 Console Autologin may work best for autostarting programs
4. Change Localisation Options
  * Change Locale to en_US.UTF- UTF-8 (for US)
  * Change Timezone
  * Change Keyboard Layout (generic 104 usually works best for US)
  * Change WiFi Country to US

Reboot the Pi.
