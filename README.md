# esp8266-doodle
Projects using NodeMCU (Lua) firmware for ESP8266. Project management is handled with [espeon](https://github.com/ryanplusplus/espeon).

## What?
http://esp8266.net/

## Getting Started
Install `espeon` and all of its dependencies (do this once):

```shell
luarocks install espeon
espeon install_dependencies
```

Flash firmware (do this when switching to a new project):

```shell
# Enter the project directory first
cd blinky
espeon flash_firmware

# Wait a bit for the filesystem to be formatted
```

Flash application (do this after you've made some changes):

```shell
# While in the project directory
espeon flash
```

Resetting the board (do this or press the reset button after flashing):

```shell
espeon reset
```

## Resources
### NodeMCU Documentation
https://nodemcu.readthedocs.io/en/master/

### Pinout
![Pinout](https://raw.githubusercontent.com/nodemcu/nodemcu-devkit-v1.0/master/Documents/NODEMCU_DEVKIT_V1.0_PINMAP.png)

### Fancy Framework
https://github.com/devyte/nodemcu-platform

## Tools
### Espeon
https://github.com/ryanplusplus/espeon
http://luarocks.org/modules/ryanplusplus/espeon

### Firmware Build Service
https://nodemcu-build.com/

### Firmware Flasher
https://github.com/espressif/esptool

### File Upload
https://github.com/kmpm/nodemcu-uploader
