file = io.open([[C:\Users\theas\Documents\LUA\Brainfuck Compiler\testfile.txt]])

-- Set file as default input
io.input(file)

-- Read file into memory
print(io.read("*all"))

-- Close file
io.close(file)

-- Set default input to stdin
io.input(io.stdin)

io.read()