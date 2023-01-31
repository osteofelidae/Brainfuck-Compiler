fileDataRaw = "init"


print(arg[1])

-- Get file contents as command line argument
function getFilePath()

	-- If arg is provided
	if arg[1] ~= nil then

		print("YESSS")

		-- Nested function to read file path
		function readFilePath()

			-- Open command line argument as path
			file = io.read(arg[1])

			-- Set file as default input
			io.input(file)

			-- Read file into memory
			print(io.read("*all"))
			fileDataRaw = io.read("*all")

			-- Close file
			io.close(file)

			-- Set default input to stdin
			io.input(io.stdin)

		end

		-- Protected call nested function
		if pcall(readFilePath) then -- problem with pcall

		else

			print("ERROR")

		end

	-- If command line arg is not provided
	else

		-- TODO

	end

end

getFilePath()

pcall(print, "hello")

print(fileDataRaw)

print("Done")

io.read()