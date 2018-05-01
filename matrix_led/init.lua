local Matrix = dofile('Matrix.lc')

local matrix = Matrix(7, 5)

matrix.write_pixel(6, 6, true)
matrix.write_row(3, 0xA5)
matrix.write_row(0, 0xFF)
matrix.set_intensity(0)
matrix.render()
