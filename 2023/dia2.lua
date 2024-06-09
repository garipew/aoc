
function translateColors(line)

	padroes = {
	["red"] = "1",
	["green"] = "2",
	["blue"] = "3"
	}

	for padrao,valor in pairs(padroes) do
		line,_ = string.gsub(line, padrao, valor)
	end

	return line
end

max = { 12, 13, 14 }

total = 0
sumPow = 0
for line in io.lines() do
	
	if line == nil then
		goto continue
	end
	
	i,j = string.find(line, "%d+")
	gameID = string.sub(line, i, j)
	line = string.sub(line, j+1)

	rgb = {0, 0, 0}
	
	colors,_ = string.gsub(line, "%A", "")
	amount,_ = string.gsub(line, "%D", ".")
	
	colors = translateColors(colors)
	for char=1, string.len(colors) do

		k,l = string.find(amount, "%d+")
		
		if k == nil then
			break
		end
		
		if rgb[tonumber(string.sub(colors, char, char))] <  tonumber(string.sub(amount, k, l)) then
			rgb[tonumber(string.sub(colors, char, char))] =  tonumber(string.sub(amount, k, l))
		end

		amount = string.sub(amount, l+1)

	end
	
	power = 1
	for cor,valor in pairs(rgb) do
		power = power * valor
		if valor > max[cor] then
			gameID = "0"
		end
	end

	total = total + tonumber(gameID)
	sumPow = sumPow + power

	::continue::

end

print(sumPow)
