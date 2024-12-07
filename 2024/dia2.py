import sys

def read_input(filename):
	f = open(filename, "r")
	lines = []
	for line in f:
		lines.append(line)
	f.close()
	return lines

def split_input(lines):
	levels = []
	for line in lines:
		levels.append(line.split(' '))
	for level in levels:
		level[-1] = level[-1].strip()
	return levels

def convert_lists(lists):
	for lista in lists:
		for i in range(len(lista)):
			lista[i] = int(lista[i])
	return lists

def check_level(level):
	diff = level[0] - level[1]
	increasing = 1 if diff > 0 else -1
	##print(increasing)
	for i in range(len(level)-1):
		diff = increasing * (level[i] - level[i+1]) 
		##print(f'{level[i]} - {level[i+1]} = {diff}')
		if diff > 3 or diff < 1:
			break
		if i == len(level) - 2:
			##print("safe")
			return 1
	return 0

def check_unsafe(level):
	diff = level[0] - level[1]
	increasing = 1 if diff > 0 else -1
	unsafe = []
	for i in range(len(level)-1):
		diff = increasing * (level[i] - level[i+1]) 
		##print(f'{level[i]} - {level[i+1]} = {diff}')
		if diff > 3 or diff < 1:
			unsafe.append([i, i+1])
		if i == len(level) - 2:
			break
	#print(unsafe)
	return unsafe

def check_brand(level):
	unsafes = check_unsafe(level)
	copies = []
	unsafes_len = len(unsafes)
	safe = 0
	if unsafes_len == 0:
		safe=check_level(level)
		#print(level)
	else:
		copies = []
		for l in range(len(level)):
			copies.append(level.copy())
			copies[l].pop(l)
		for copy in copies:
			safe=check_level(copy)
			if safe > 0:
				#print(level)
				break
	return safe

lists = convert_lists(split_input(read_input(sys.argv[1]))) 
safe = 0
for level in lists:
	safe+=check_brand(level) 
print(safe)
