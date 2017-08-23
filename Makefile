SERIAL_PORT?=/dev/ttyUSB0
FIRMWARE?=firmware/nodemcu-master-13-modules-2017-08-22-13-11-15-integer.bin

install_ubuntu:
	sudo apt install python-pip
	sudo pip install esptool
	sudo pip install nodemcu-uploader

flash_firmware:
	esptool.py --baud 115200 --port $(SERIAL_PORT) write_flash -fm dio -fs 4MB 0x00000 $(FIRMWARE) 0x3fc000 firmware/esp_init_data_default.bin

upload_blinky:
	cd blinky; nodemcu-uploader --port $(SERIAL_PORT) upload *.lua --compile

erase:
	nodemcu-uploader --port $(SERIAL_PORT) file format

restart:
	nodemcu-uploader --port $(SERIAL_PORT) node restart

terminal:
	screen $(SERIAL_PORT) 115200
