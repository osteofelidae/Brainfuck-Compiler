-- VARIABLES

-- Memory simulation
memoryList = {}
memoryList[0] = 0
memoryIndex = 0

-- Program files
allowedChars = {">", "<", "+", "-", ".", ",", "[", "]"}
filePath = ""

-- Program execution
programList = {}
programIndex = 0
printOutput = ""

-- Preference variables
allowNegativeMemoryValues = false -- Allow negative memory values in programList
printActionSteps = true -- Print action steps
alwaysShowPrintOutput = true -- Print print output after every step
filterInput = true -- Ignore unwanted characters in input program



-- FUNCTIONS

-- Console print with formatting
function consolePrint(type, text, content)

	-- If step
	if type == "STEP" then

		-- Print divider
		print("-+----------------------------------------------+-")

	end

	-- Print first line
	print("   ["..type.."]".." "..text)

	-- If second line exists
	if content ~= nil then

		-- Print second line
		print("   "..content)

	end

	-- If step and print output enables
	if type == "STEP" and alwaysShowPrintOutput then

		-- Print print output
		print("   Current print output: "..printOutput)

	end

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

-- Get file path as input
function requestFilePath()

	-- Set file path to input
	filePath = io.read()

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
	while programIndex < #programList do

		-- Execute current character
		runChar(programList[programIndex])

		-- Increment program index
		programIndex = programIndex + 1

	end

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

		-- If current character is not 0
		if memoryList[memoryIndex] ~= 0 then

			-- While current character is not loop start character
			while programList[programIndex] ~= "[" do

				-- Decrement memory index
				programIndex = programIndex - 1

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
		--consolePrint("STEP", "Unrecognized character", nil)
		consolePrint("ERROR", "Unrecognized character '"..char.. "' at location "..tostring(programIndex), nil)

	end

end



-- MAIN
runString(io.read())

while true do

	

end