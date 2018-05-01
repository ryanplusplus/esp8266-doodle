return function(data_pin, clock_pin, intensity)
  buffer = {}

  for i = 0, 7 do
    buffer[i] = 0
  end

  local function send(byte)
    for i = 0, 7 do
      gpio.write(clock_pin, gpio.LOW)
      gpio.write(data_pin, bit.isset(byte, i) and gpio.HIGH or gpio.LOW)
      gpio.write(clock_pin, gpio.HIGH)
    end
  end

  local function send_command(command)
    gpio.write(data_pin, gpio.LOW)
    send(command)
    gpio.write(data_pin, gpio.HIGH)
  end

  local function send_data(address, data)
    send_command(0x44)
    gpio.write(data_pin, gpio.LOW)
    send(bit.bor(0xC0, address))
    send(data)
    gpio.write(data_pin, gpio.HIGH)
  end

  local function render()
    for i = 0, 7 do
      send_data(i, buffer[i])

      gpio.write(data_pin, gpio.LOW)
      gpio.write(clock_pin, gpio.LOW)
      gpio.write(clock_pin, gpio.HIGH)
      gpio.write(data_pin, gpio.HIGH)
    end

    send_command(bit.bor(0x88, intensity))
  end

  local function clear()
    for i = 0, 7 do
      buffer[i] = 0
    end
  end

  local function write_pixel(x, y, value)
    buffer[y] = bit[value and 'set' or 'clear'](buffer[y], x)
  end

  local function write_row(y, value)
    buffer[y] = value
  end

  local function set_intensity(value)
    intensity = math.min(value, 7)
  end

  gpio.mode(data_pin, gpio.OUTPUT)
  gpio.mode(clock_pin, gpio.OUTPUT)

  gpio.write(data_pin, gpio.HIGH)
  gpio.write(clock_pin, gpio.HIGH)

  set_intensity(intensity or 7)

  return {
    render = render,
    clear = clear,
    write_pixel = write_pixel,
    write_row = write_row,
    set_intensity = set_intensity
  }
end
