

function countNum(str)
	
	numbers = {}

	num_i,num_j = string.find(str, "%d+") 
	while num_i ~= nil do
		table.insert(numbers, tonumber(string.sub(str,num_i, num_j)))
		str = string.sub(str, num_j+1)
		num_i,num_j = string.find(str, "%d+") 
	end

	return numbers
	
end

function findWinning(card_numbers, winning_numbers)
	
	card_total = 0
	num_copies = 0

	for idx=1, #card_numbers do
		
		for idx_b=1, #winning_numbers do
			
			if card_numbers[idx] == winning_numbers[idx_b] then
				
				if card_total == 0 then
					card_total = 1
				else
					card_total = card_total * 2
				end
				num_copies = num_copies + 1

			end
		end

	end
	
	return card_total,num_copies

end

games = {}
for line in io.lines() do
	table.insert(games, line)
end

total = 0
copies = {}

for i=1, #games do
	copies[i] = 1
end

for game,card in ipairs(games) do

	card_total = 0
	num_copies = 0
	
	i,j = string.find(card, "|")
	k, l = string.find(card, ":")
	
	str = string.sub(card, k+1, i - 1)
	str_win = string.sub(card, j)
	
	card_numbers = countNum(str)
	winning_numbers = countNum(str_win)
	
	for cop=1, copies[game] do
		print("Game " .. game .. " copy " .. cop)		
		c_total,num_copies = findWinning(card_numbers, winning_numbers)
		card_total = card_total + c_total

		for c=1, num_copies do
			if copies[game+c] ~= nil then
				copies[game+c] = copies[game+c] + 1
			end
		end

	end


	total = total + card_total
	

end

cards = 0
for k,v in ipairs(copies) do
	cards = cards + v
end

print("Em " .. cards .. " cartoes, a pontuação foi " .. total)

