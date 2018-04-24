local sda = 4
local scl = 5
local reset = 2
local address = 0x3c

i2c.setup(0, sda, scl, i2c.SLOW)

gpio.mode(reset, gpio.OUTPUT)
gpio.write(reset, gpio.HIGH)

return u8g.ssd1306_128x32_i2c(address)
