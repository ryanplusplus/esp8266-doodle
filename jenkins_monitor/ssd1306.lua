local sda = 1
local scl = 2
local address = 0x3c
i2c.setup(0, sda, scl, i2c.SLOW)
return u8g.ssd1306_128x64_i2c(address)
