# esp8266-doodle
## What?
http://esp8266.net/

## Usage
### make install
Install dependencies on Mac or Linux.

### make flash_firmware
Erase the device and flash the included firmware. To flash your own firmware, set the `FIRMWARE` variable to the path a firmware image.

The included firmware is built with:
> adc, file, gpio, http, net, node, pwm, tmr, uart, wifi

### make erase
Erase the device.

### make format
Format the file system.

### make reset
Reset the device.

### make console
Open a serial console using GNU `screen`.

### make flash_(project)
Copy all files in the folder `(project)` to the device's file system. This will automatically pre-compile all `.lua` files to `.lc` files. Note that this does not remove any files from the file system that were previously loaded unless they are overwritten by the files in the project. To remove files from another project to save space, use `make format`.

Example:

```
make flash_http_server
```

## Resources
### NodeMCU Documentation
https://nodemcu.readthedocs.io/en/master/

### Pinout
![Pinout](https://raw.githubusercontent.com/nodemcu/nodemcu-devkit-v1.0/master/Documents/NODEMCU_DEVKIT_V1.0_PINMAP.png)

### Fancy Framework
https://github.com/devyte/nodemcu-platform

## Tools
### Firmware Build Service
https://nodemcu-build.com/

### Firmware Flasher
https://github.com/espressif/esptool

### File Upload
https://github.com/kmpm/nodemcu-uploader
