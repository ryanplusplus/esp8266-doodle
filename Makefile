FIRMWARE?=firmware/nodemcu-master-10-modules-2017-09-01-17-47-52-integer.bin

include os.mk

#
SERIAL_PORT?=/dev/$(shell ls /dev/ | grep -i tty | grep -m1 -i usb)

ifeq ($(HOST),linux)
.PHONY: install
	sudo apt install screen
install:
	sudo apt install python-pip
	sudo pip install esptool
	sudo pip install nodemcu-uploader
endif

ifeq ($(HOST),mac)
.PHONY: install
install:
	sudo easy_install pip
	sudo pip install esptool
	sudo pip install nodemcu-uploader

	curl "http://www.wch.cn/downfile/178" -o "usb-to-uart-driver.zip"
	unzip usb-to-uart-driver.zip
	rm usb-to-uart-driver.zip

	sudo installer -store -pkg "CH34x_Install_V1.3.pkg" -target /
	rm CH34x_Install_V1.3.pkg
endif

.PHONY: flash_firmware
flash_firmware: erase
	esptool.py --baud 115200 --port $(SERIAL_PORT) write_flash -fm dio -fs 4MB 0x00000 $(FIRMWARE) 0x3fc000 firmware/esp_init_data_default.bin 0x7e000 firmware/blank.bin
	@echo
	@echo "After flashing firmware, the filesystem may need to be formatted. This can take a while. Please be patient."

flash_%:
	cd $* && nodemcu-uploader --port $(SERIAL_PORT) upload * && nodemcu-uploader --port $(SERIAL_PORT) upload *.lua --compile

.PHONY: erase
erase:
	esptool.py --baud 115200 --port $(SERIAL_PORT) erase_flash

.PHONY: format
format:
	nodemcu-uploader --port $(SERIAL_PORT) file format

.PHONY: reset
reset:
	nodemcu-uploader --port $(SERIAL_PORT) node restart

.PHONY: console
console:
	screen $(SERIAL_PORT) 115200
