local cs  = 1
local res = 2
local dc  = 3
spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 8)
gpio.mode(8, gpio.INPUT, gpio.PULLUP)
return u8g.pcd8544_84x48_hw_spi(cs, dc, res)
