FIRMWARE?=firmware/nodemcu-master-13-modules-2017-08-22-13-11-15-integer.bin

include os.mk

ifeq ($(HOST),linux)
SERIAL_PORT?=/dev/ttyUSB0
endif

ifeq ($(HOST),mac)
SERIAL_PORT?=/dev/tty.SLAB_USBtoUART
endif

ifeq ($(HOST),linux)
install:
	sudo apt install screen
	sudo apt install python-pip
	sudo pip install esptool
	sudo pip install nodemcu-uploader
endif

ifeq ($(HOST),mac)
install:
	sudo pip install esptool
	sudo pip install nodemcu-uploader
	curl "https://www.silabs.com/documents/public/software/Mac_OSX_VCP_Driver.zip" -o "usb-to-uart-driver.zip"
	unzip usb-to-uart-driver.zip
	rm usb-to-uart-driver.zip

	hdiutil mount SiLabsUSBDriverDisk.dmg
	sudo installer -store -pkg "/Volumes/Silicon Labs VCP Driver Install Disk/Silicon Labs VCP Driver.pkg" -target /
	hdiutil unmount "/Volumes/Silicon Labs VCP Driver Install Disk"
	rm SiLabsUSBDriverDisk.dmg
endif

flash_firmware: erase
	esptool.py --baud 115200 --port $(SERIAL_PORT) write_flash -fm dio -fs 4MB 0x00000 $(FIRMWARE) 0x3fc000 firmware/esp_init_data_default.bin 0x7e000 firmware/blank.bin
	@echo
	@echo "After flashing firmware, the filesystem may need to be formatted. This can take a while. Please be patient."

flash_%:
	cd $* && nodemcu-uploader --port $(SERIAL_PORT) upload * && nodemcu-uploader --port $(SERIAL_PORT) upload *.lua --compile

erase:
	esptool.py --baud 115200 --port $(SERIAL_PORT) erase_flash

format:
	nodemcu-uploader --port $(SERIAL_PORT) file format

restart:
	nodemcu-uploader --port $(SERIAL_PORT) node restart

console:
	screen $(SERIAL_PORT) 115200
