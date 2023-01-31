program = "abcde+-<>"

print(string.byte(program))

program = string.sub(program,2)

print(string.byte(program)	)

index = 0
array = {}

while string.len(program)>0 do

	array[index] = string.sub(program, 1, 1)
	program = string.sub(program,2)
	index = index + 1

end

for x = 1,10 do

	print(array[x])

end

while true do

end