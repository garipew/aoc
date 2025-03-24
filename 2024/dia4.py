#!/usr/bin/python3

import sys

def read_input(filename):
	f = open(filename, "r")
	lines = ["", None, 0]
	for line in f:
		lines[0]+=line
		if(lines[1] == None):
			lines[1]=len(lines[0])
		lines[2]+=1
	f.close()
	return lines


def horizontal_search(string, pattern):
	current = 0
	while((current < len(pattern)) and (current < len(string)) and pattern[current] == string[current]):
		current+=1
	return current == len(pattern)
				

def vertical_search(string, start, pattern, line_len, total_len):
	current = 0
	while((current < len(pattern)) and ((start+(current*line_len)) < (total_len*line_len)) and (pattern[current] == string[start+(current*line_len)])):
		current+=1
	return current == len(pattern)


def diagonal_search(string, start, pattern, line_len, total_len):
	current = 0
	while((current < len(pattern)) and ((start+current+(current*line_len)) < (total_len*line_len)) and (pattern[current] == string[start+current+(current*line_len)])):
		current+=1
	return current == len(pattern)


def reverse_diagonal_search(string, start, pattern, line_len, total_len):
	current = 0
	while((current < len(pattern)) and ((start-current+(current*line_len)) < (total_len*line_len)) and (pattern[current] == string[start-current+(current*line_len)])):
		current+=1
	return current == len(pattern)


def search_xmas(string, idx, pattern, str_len, total_len):
	xmas=0
	if(horizontal_search(string[idx:], pattern)):
		xmas+=1
	if(horizontal_search(string[idx:], pattern[::-1])):
		xmas+=1
	if(vertical_search(string, idx, pattern, str_len, total_len)):
		xmas+=1
	if(vertical_search(string, idx, pattern[::-1], str_len, total_len)):
		xmas+=1
	if(diagonal_search(string, idx, pattern, str_len, total_len)):
		xmas+=1
	if(diagonal_search(string, idx, pattern[::-1], str_len, total_len)):
		xmas+=1
	if(reverse_diagonal_search(string, idx, pattern, str_len, total_len)):
		xmas+=1
	if(reverse_diagonal_search(string, idx, pattern[::-1], str_len, total_len)):
		xmas+=1
	return xmas


def search_x_mas(string, idx, pattern, str_len, total_len):
	xmas = 0
	if(diagonal_search(string, idx, pattern, str_len, total_len)):
		if(reverse_diagonal_search(string, idx+2, pattern, str_len, total_len) or reverse_diagonal_search(string, idx+2, pattern[::-1], str_len, total_len)):
			xmas+=1
	return xmas


def search_all_xmas(string, str_len, total_len):
	idx = 0
	straight = False
	reverse = False
	pattern = "MAS"
	xmas = 0
	while(idx < len(string)):
		xmas+=search_x_mas(string, idx, pattern, str_len, total_len)
		xmas+=search_x_mas(string, idx, pattern[::-1], str_len, total_len)
		idx+=1
	return xmas

lines = read_input(sys.argv[1])
print(search_all_xmas(lines[0], lines[1], lines[2]))
