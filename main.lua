-- HEADER
HEADER =
[[   
==========================================                                             
BRAINFUCK
COMPILER

Made with pride by Osteofelidae (c) 2023
==========================================
]]



-- VARIABLES

-- Memory simulation
memoryList = {}
memoryList[0] = 0
memoryIndex = 0

-- Program files
allowedChars = {">", "<", "+", "-", ".", ",", "[", "]"}
filePath = ""
fileDataRaw = ""

-- Program execution
programList = {}
programIndex = 0
printOutput = ""
stepCount = 0

loop = true -- Variable for loop

-- Preference variables
allowNegativeMemoryValues = false -- Allow negative memory values in programList
printActionSteps = true -- Print action steps
alwaysShowPrintOutput = true -- Print print output after every step
filterInput = true -- Ignore unwanted characters in input program
showMemoryLocations = true -- Show memory location diagram on each step
memoryLocationSlotsDisplay = 9 -- Max number of memory slots shown
memoryLocationsDigitsShown = 5 -- Number of digits shown on each memory slot
suppressOutput = false -- Suppress most output
nestedLoops = true -- Nested loops are enabled



-- FUNCTIONS

-- Console print with formatting
function consolePrint(type, text, content)

	-- If not suppressOutput
	if not suppressOutput then

		-- If step
		if type == "STEP" then

			-- Print divider
			print("")

			-- Print step number
			print("------> Step "..tostring(stepCount))

			-- Increment step count
			stepCount = stepCount + 1

		end

		-- Print first line
		print("   ["..type.."]".." "..text)

		-- If second line exists
		if content ~= nil then

			-- Print second line
			print("   "..content)

		end

		-- If step and print output enabled
		if type == "STEP" and alwaysShowPrintOutput then

			-- Print print output
			print("   [NOTE] Current print output: "..printOutput)

		end

		-- If step and show memory locations enabled
		if type == "STEP" and showMemoryLocations then

			-- Print memory locations
			print("   [NOTE] "..memoryLocationsString())

		end
	end

end

-- Number format
function numberFormat(number, digits)

	-- Change number to string
	number = tostring(number)

	-- If number is shorter than set digits
	if string.len(number) < digits then

		-- Add '0' digits to beginning of string
		for i = 1,(digits - string.len(number)) do

			-- Append '0' digit
			number = "0"..number

		end

	end

	return number

end


-- Memory locations to string
function memoryLocationsString()

	-- Output variable
	local outString = "Current memory contents: "

	-- Offset radius
	local radius = math.floor(memoryLocationSlotsDisplay / 2)

	-- Start and end
	local startIndex = math.max(0, memoryIndex - radius)
	local endIndex = math.min(#memoryList, memoryIndex + radius)

	-- If start index is larger than 0
	if startIndex > 0 then

		-- Append ...
		outString = outString.."... "

	end

	-- For loop from start to end
	for index = startIndex, endIndex do

		outString = outString.."["..numberFormat(memoryList[index], memoryLocationsDigitsShown).."] "

	end

	-- If start index is larger than 0
	if endIndex < #memoryList - 1 then

		-- Append ...
		outString = outString.."..."

	end

	-- New line + 3 spaces
	outString = outString.."\n   "

	-- Add preliminary spaces
	outString = outString..string.rep(" ", 32)

	-- Add offset spaces for start dots
	if startIndex > 0 then

		-- Add 4 spaces
		outString = outString..string.rep(" ", 4)

	end

	-- Add offset spaces and cursor
	outString = outString..string.rep(" ", (memoryIndex - startIndex)*(3 + memoryLocationsDigitsShown) + math.ceil(memoryLocationsDigitsShown/2)).."^"

	-- Return result
	return outString

end


-- Check if char is valud
function checkChar(char)

	-- Output var
	local found = false

	-- Loop through allowed chars
	for index = 1,#allowedChars do

		-- If character is matched
		if char == allowedChars[index] then

			-- Set found to true
			found = true

		end

	end

	-- Return result
	return found

end

-- Get file contents as command line argument
function getFilePath()

	-- If arg is provided
	if arg[1] ~= nil then

		-- Nested function to read file path
		function readFilePath()

			-- Open command line argument as path
			local file = io.open(arg[1])

			-- Set file as default input
			io.input(file)

			-- Read file into memory
			fileDataRaw = io.read("*all")

			-- Close file
			io.close(file)

			-- Set default input to stdin
			io.input(io.stdin)

		end

		-- Protected call nested function
		if pcall(readFilePath) then

			-- Return true if success
			return true

		-- If unsuccessful
		else

			-- Return false
			return false

		end

	-- If command line arg is not provided
	else

		-- Return false
		return false

	end

end

-- Get flag
function getFlag()

	-- Fast flag
	if arg[2] == "f" then

		printActionSteps = false -- Print action steps
		alwaysShowPrintOutput = false -- Print print output after every step
		memoryLocationSlotsDisplay = 0 -- Max number of memory slots shown
		showMemoryLocations = false
		memoryLocationsDigitsShown = 0 -- Number of digits shown on each memory slot
		suppressOutput = true

	-- If slow flag
	elseif arg[2] == "s" then

		-- Do nothing

	-- If not recognized
	else

		-- Print error
		consolePrint("WARN", "Flag not recognized. Only (f)ast or (s)low are supported. Will defailt to (s)low.")

	end

end

-- Execute an array
function runString(program)

	-- Local vars
	local index = 0

	-- While length of input string is larger than 0
	while string.len(program) > 0 do

		-- If input filtering is on
		if filterInput then

			-- If char is valid char
			if checkChar(string.sub(program, 1, 1)) then

				-- Add character to list
				programList[index] = string.sub(program, 1, 1)

				-- Increment index
				index = index + 1

			end

		-- If input filtering is off
		else

			-- Add character to list
			programList[index] = string.sub(program, 1, 1)

			-- Increment index
			index = index + 1

		end

		-- Remove first character fro string input
			program = string.sub(program,2)

	end

	index = 0

	-- While index is smaller than program length
	while programIndex <= #programList do

		-- Execute current character
		runChar(programList[programIndex])

		-- Increment program index
		programIndex = programIndex + 1

	end

	-- Enable output
	suppressOutput = false

	-- Print ending prompt
	consolePrint("STEP", "Program ended. Press enter to continue.")

	-- Final output
	consolePrint("OUTPUT", "Final output: "..printOutput)

	-- Wait for input before exiting
	io.read()

end

-- Execute 1 character
function runChar(char)



	-- Next memory index
	if char == ">" then

		-- If it is allowed
		if printActionSteps then
			
			-- Print action step
			consolePrint("STEP", "Move cursor to next memory slot", nil)

		end

		-- Increment memory index by 1
		memoryIndex = memoryIndex + 1

		-- If memory index is past the end
		if memoryIndex > #memoryList then

			-- Add empty entry to memory index
			memoryList[memoryIndex] = 0

		end

	-- Previous memory index
	elseif char == "<" then

		-- If it is allowed
		if printActionSteps then
			
			-- Print action step
			consolePrint("STEP", "Move cursor to previous memory slot", nil)

		end

		-- If memory index is not 0
		if memoryIndex ~= 0 then

			-- Decrement memory index
			memoryIndex = memoryIndex - 1

		-- If memory index is 0
		else

			-- Print error
			consolePrint("ERROR", "Cannot have memory index less than 0", nil)

		end

	-- Increment current memory slot
	elseif char == "+" then

		-- If it is allowed
		if printActionSteps then
			
			-- Print action step
			consolePrint("STEP", "Increment current memory slot", nil)

		end

		-- Increment it
		memoryList[memoryIndex] = memoryList[memoryIndex] + 1

	-- Decrement current memory slot
	elseif char == "-" then

		-- If it is allowed
		if printActionSteps then
			
			-- Print action step
			consolePrint("STEP", "Decrement current memory slot", nil)

		end

		-- If negative memory values are allowed
		if allowNegativeMemoryValues then
			
			-- Decrement memory value
				memoryList[memoryIndex] = memoryList[memoryIndex] - 1

		-- If negative memory alues are not allowed
		else

			-- If memory value is not 0
			if memoryList[memoryIndex] ~= 0 then

				-- Decrement memory value
				memoryList[memoryIndex] = memoryList[memoryIndex] - 1

			-- If memory value is 0
			else

				-- Print error
				consolePrint("ERROR", "Cannot have memory value less than 0", nil)

			end

		end

	-- Loop start
	elseif char == "[" then

		-- If it is allowed
		if printActionSteps then
			
			-- Print action step
			consolePrint("STEP", "Loop start character", nil)

		end

		-- Do nothing
		

	-- Loop end
	elseif char == "]" then

		-- Bracket level
		local bracketLevel = 1

		-- If current character is not 0
		if memoryList[memoryIndex] ~= 0 then

			-- While current character is not loop start character
			while bracketLevel > 0 do

				-- Decrement memory index
				programIndex = programIndex - 1

				-- If closing bracket
				if programList[programIndex] == "]" and nestedLoops then

					-- Increment bracketLevel
					bracketLevel = bracketLevel + 1

				-- Else if opening bracket
				elseif programList[programIndex] == "[" then

				-- Increment bracketLevel
					bracketLevel = bracketLevel - 1

				end

			end

		end

	-- Input one character
	elseif char == "," then 

		-- If it is allowed
		if printActionSteps then
			
			-- Print action step
			consolePrint("STEP", "Input character", nil)

		end

		-- Prompt user for input
		consolePrint("INPUT", "Input one character... ", nil)

		-- Set current memory slot to the input 1 character's ascii value
		memoryList[memoryIndex] = string.byte(io.read(1))

	-- Output one character
	elseif char == "." then

		-- If it is allowed
		if printActionSteps then
			
			-- Print action step
			consolePrint("STEP", "Print character", nil)

		end

		-- Print current memory location
		consolePrint("OUTPUT", string.char(memoryList[memoryIndex]), nil)

		-- Add output to print output variable
		printOutput = printOutput..string.char(memoryList[memoryIndex])

	else

		-- Print error
		consolePrint("STEP", "Unrecognized character", nil)
		consolePrint("ERROR", "Unrecognized character '"..char.. "' at location "..tostring(programIndex), nil)

	end

end

-- Print header (NONFUNCTIONAL)
function printHeader()

	print(HEADER)

end

-- MAIN

-- Get flag
getFlag()

-- If command line arg provided and read successfully
if getFilePath() then

	-- Run input file data
	runString(fileDataRaw)

-- If command line arg not provided
else

	-- Print header
	printHeader()

	-- Print instructions
	consolePrint("NOTE", "Instructions:", "Input file path... ")

	-- Print prompt
	io.write(">>>")

	-- Get file input
	arg[1] = io.read()

	-- Get file path
	getFilePath()

	-- Run
	runString(fileDataRaw)

end