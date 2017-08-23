FIRMWARE?=firmware/nodemcu-master-13-modules-2017-08-22-13-11-15-integer.bin

ifdef OS
HOST:=windows
else
ifeq ($(shell uname),Darwin)
HOST:=mac
else
ifeq ($(shell uname),Linux)
HOST:=linux
endif
endif
endif

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
	todo
	sudo pip install esptool
	sudo pip install nodemcu-uploader
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
