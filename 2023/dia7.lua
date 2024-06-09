function readNext(str)

	local i,j = string.find(str, ".")
	if i == nil then return nil,str end 
	return string.sub(str, i, j), string.sub(str, j + 1)
	
end


function readInput()
	local lines = {}
	for line in io.lines() do
		table.insert(lines, line)
	end

	local games = {}
	for _,line in ipairs(lines) do 
		i,j = string.find(line, " ")
		if i == nil then break end
		table.insert(games, {hand=string.sub(line, 0, i-1), bid=tonumber(string.sub(line, j+1))})
		countCards(games[#games])
	end

	return games
end


function translateCard(card)
	
	local translations = {
		["J"] = 1,
		["2"] = 2,
		["3"] = 3,
		["4"] = 4,
		["5"] = 5,
		["6"] = 6,
		["7"] = 7,
		["8"] = 8,
		["9"] = 9,
		["T"] = 10,
		["Q"] = 11,
		["K"] = 12,
		["A"] = 13
		}

	return translations[card]

end


function findType(points)
	
	local maior = 0
	local idx = 0
	for k,v in ipairs(points) do
		if v > maior and k ~= translateCard("J") then
			maior = v
			idx = k
		end
	end

	maior = maior + points[translateCard("J")]
	points[translateCard("J")] = 0
	
	if maior > 3 then return maior*10 end

	points[idx] = 0 
	local novo_maior = 0
	for _,v in ipairs(points) do
		if v > novo_maior then
			novo_maior = v
		end	
	end
	
	return (maior * 10) + novo_maior
end


function countCards(game)

	local str = game.hand
	local points = {}

	for i=1,13 do points[i] = 0 end
	char,str = readNext(str)
	while char ~= nil do
		new_card = translateCard(char)
		points[new_card] = points[new_card] + 1
		char,str = readNext(str)
	end

	game.tipo = findType(points)
	if game.tipo < 10 then game.tipo = game.tipo * 10 end

end


function rank(hand1, hand2)
	
	if hand1.tipo ~= hand2.tipo then return hand1.tipo < hand2.tipo end
	
	cards1 = hand1.hand
	cards2 = hand2.hand
	repeat
		char1,cards1 = readNext(cards1)
		char2,cards2 = readNext(cards2)
		if char1 == nil or char2 == nil then break end
		card1 = translateCard(char1)
		card2 = translateCard(char2)
	until card1 ~= card2

	return card1 < card2
	
end


games = readInput()
table.sort(games, rank)

total = 0
for k,v in ipairs(games) do
--	print(v.hand .. " " .. v.bid .. " " .. v.tipo)
	total = total + (k * v.bid)
end

print(total)

