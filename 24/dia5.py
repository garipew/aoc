#!/usr/bin/python3

import sys


def read_input(filename):
	f = open(filename, "r")
	lines = ["", ""]
	current = 0
	for line in f:
		if(line == "\n"):
			current+=1
		lines[current]+=line
	f.close()
	return lines


def create_rules(rules):
	guidebook = {}
	for rule in rules:
		numbers = rule.split('|')
		if(len(numbers) != 2):
			break
		if(not numbers[0] in guidebook):
			guidebook[numbers[0]] = []
		guidebook[numbers[0]].append(numbers[1])
	return guidebook
	

def shift_element(numbers, i, j):
	numbers.pop(numbers.index(j))
	numbers.insert(numbers.index(i), j)
	return numbers


def check_previous(num, numbers, guidebook):
	control = True
	if(not num in guidebook):
		return numbers,control

	for i in guidebook[num]:
		for j in range(len(numbers)):
			if(numbers[j] == num):
				break
			if(numbers[j] == i):
				control = False
				numbers = shift_element(numbers, numbers[j], num)
				break
				#print(f'wrong at {num}, because of {j}')
	return numbers,control


def check_page(page, guidebook):
	if(len(page) <= 0):
		#print('wrong because of len')
		return None, False
	numbers = page.split(',')
	condition = True
	for num in numbers:
		results = check_previous(num, numbers, guidebook)
		numbers = results[0]
		condition = condition and results[1] 
	return numbers,condition


def check_pages(pages, guidebook, control):
	valid_pages = []
	for page in pages:
		#print(f'next page: {page}')
		check, valid = check_page(page, guidebook)
		#print(f'result is {check}')
		if(valid == control and check != None):
			valid_pages.append(check)
	return valid_pages


if(len(sys.argv) < 3):
	print(f'Usage: {sys.argv[0]} <filename> <filter>')

lines = read_input(sys.argv[1])
guidebook = create_rules(lines[0].split('\n'))
check_for_correct = True
if(sys.argv[2].lower() == 'false'):
	check_for_correct = False
valid_pages = check_pages(lines[1].split('\n'), guidebook, check_for_correct)
result = 0
for i in valid_pages:
	result+=int(i[(len(i)-1)//2])
print(result)
