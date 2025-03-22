#!/usr/bin/python3

import sys

def read_input(filename):
	f = open(filename, "r")
	lines = ""
	for line in f:
		lines+=line
	f.close()
	return lines


def find_digit(string):
	i = 3
	digit = None
	while(i > 0):
		if(string[:i].isdigit()):
			digit = string[:i]
			break
		i-=1
	return digit


def switch_check(string, switchvalue):
	if(switchvalue):
		#checa se atual caractere é dont
		return not (string[:7] == "don\'t()")
	else:
		#checa se atual caractere é do
		return (string[:4] == "do()")


def find_ops(lines):
	pattern = "mul(*,*)"
	idx = 0
	current = 0
	ops = []
	op_len = len(pattern)-1
	switchvalue = True
	while(idx < len(lines)):
		if(switchvalue):
			if(lines[idx] == pattern[current]):
				current+=1
			elif(pattern[current] == '*'):
				dig = find_digit(lines[idx:])
				if(dig!=None):
					current+=1
					op_len+=len(dig)-1
					idx+=len(dig)-1
			else:
				switchvalue = switch_check(lines[idx:], switchvalue)
				if(current == 0):
					idx+=1
					if(idx >= len(lines)):
						break
				else:
					current=0
				op_len = len(pattern)-1
				continue
			if(current == len(pattern)):
				ops.append(lines[idx-op_len:idx+1])
				current = 0;
				op_len = len(pattern)-1
		else:
			switchvalue = switch_check(lines[idx:], switchvalue)
		idx+=1
	return ops


operations = find_ops(read_input(sys.argv[1]))
results = 0
numbers = []
for op in operations:
	numbers.append(find_digit(op[4:]))	
	numbers.append(find_digit(op[5+len(numbers[-1]):]))
	numbers[-1]=int(numbers[-1])
	numbers[-2]=int(numbers[-2])
	results+=(numbers[-1]*numbers[-2])

print(results)
