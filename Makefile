FIRMWARE?=firmware/nodemcu-master-13-modules-2017-08-22-13-11-15-integer.bin

include os.mk

ifeq ($(HOST),linux)
SERIAL_PORT?=/dev/ttyUSB0
endif

ifeq ($(HOST),mac)
SERIAL_PORT?=/dev/tty.SLAB_USBtoUART
endif

ifeq ($(HOST),windows)
SERIAL_PORT?=COM1
endif

ifeq ($(HOST),linux)
install:
	sudo apt install python-pip
	sudo pip install esptool
	sudo pip install nodemcu-uploader
endif

ifeq ($(HOST),mac)
install:
	echo todo
	# sudo pip install esptool
	# sudo pip install nodemcu-uploader
	curl "https://www.silabs.com/documents/public/software/Mac_OSX_VCP_Driver.zip" -o "usb-to-uart-driver.zip"
	unzip usb-to-uart-driver.zip
	rm usb-to-uart-driver.zip

	hdiutil mount SiLabsUSBDriverDisk.dmg
	sudo installer -store -pkg "/Volumes/Silicon Labs VCP Driver Install Disk/Silicon Labs VCP Driver.pkg" -target /
	hdiutil unmount "/Volumes/Silicon Labs VCP Driver Install Disk"
	rm SiLabsUSBDriverDisk.dmg
endif

ifeq ($(HOST),windows)
install:
	todo
	sudo pip install esptool
	sudo pip install nodemcu-uploader
endif

flash_firmware:
	esptool.py --baud 115200 --port $(SERIAL_PORT) write_flash -fm dio -fs 4MB 0x00000 $(FIRMWARE) 0x3fc000 firmware/esp_init_data_default.bin

flash_%:
	cd $*; nodemcu-uploader --port $(SERIAL_PORT) upload *.lua --compile

erase:
	nodemcu-uploader --port $(SERIAL_PORT) file format

restart:
	nodemcu-uploader --port $(SERIAL_PORT) node restart

terminal:
	screen $(SERIAL_PORT) 115200
