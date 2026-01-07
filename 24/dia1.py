import sys

def read_input(filename):
	f = open(filename, "r")
	lines = []
	for line in f:
		lines.append(line)
	f.close()
	return lines

def split_input(lines):
	left = []
	right = []
	listas = []
	for line in lines:
		pair = line.split('   ')
		pair[1] = pair[1].strip()
		left.append(pair[0])
		right.append(pair[1])
	listas.append(left)	
	listas.append(right)	
	return listas

def convert_lists(lists):
	for lista in lists:
		for i in range(len(lista)):
			lista[i] = int(lista[i])
		lista.sort()
	return lists

def find_distance(listas):
	dist = 0
	for i in range(len(listas[0])):
		dist += abs(listas[0][i] - listas[1][i])
	return dist	

def find_occurrences(listas):
	occurrences = {}
	for item in listas[0]:
		if not item in occurrences:
			occurrences.update({item: listas[1].count(item)})
	return occurrences

def calculate_similarity(listas):
	occurrences = find_occurrences(listas)
	similarity = 0
	for item in listas[0]:
		similarity += item * occurrences[item]	
	return similarity

lines = read_input(sys.argv[1])
listas = convert_lists(split_input(lines))
print(calculate_similarity(listas))
