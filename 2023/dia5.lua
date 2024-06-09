function criarAlcancesNegativos(tr_table)
	
	alcance1 = tr_table[1]
	alcance2 = tr_table[2]
	
	idx = 2
	idx_max = #tr_table
	while idx <= idx_max do
		v1 = alcance1[2] + alcance1[3]
		v2 = alcance2[2] - v1
		if v2 > 0 then 
			table.insert(tr_table, {v1, v1, v2})
		end
		alcance1 = tr_table[idx]
		idx = idx + 1
		alcance2 = tr_table[idx]
	end
	
	return tr_table
	
end


function sortingTranslate(tr1, tr2)
	return tr1[2] < tr2[2]
end

function sortingFunction(semente1, semente2)
	return semente1.inicio < semente2.inicio
end


function translate(source, translationTable)
	-- retorna a tradução do primeiro e o ultimo a ter sido traduzido
	

	for _,v in ipairs(translationTable) do
		if source.inicio >= v[2] and source.inicio < v[2] + v[3] then
			return v[1] + (source.inicio - v[2]), v[2] + v[3] - 1
		end
	end

	return source.inicio,source.inicio

end


function agrupar(item1, item2, range)

	if item1 == nil or item2 == nil then return range end

	if item1.inicio + range >= item2.inicio then
		return range + item2.range
	end
	
	return range

end


function agruparTodos(mesa)
	
	nova = {}
	
	idx = 1
	idj = idx + 1
	
	rng = mesa[1].range
	while idx <= #mesa do
		item1 = mesa[idx]
		item2 = mesa[idj]

		new_range = agrupar(item1, item2, rng)
		if rng == new_range then
			table.insert(nova, {inicio=item1.inicio, range=rng})
			idx = idj
			idj = idx + 1
			if mesa[idx] ~= nil then
				rng = mesa[idx].range
			end
		else
			if item2.range > 1 then 
				new_range = new_range - 1
			end

			rng = new_range
			idj = idj + 1
		end	
	end
	
	return nova

end

--[[
	Traduzir o número inicial, olhar o ultimo da tradução "inicial + range - 1", se for maior ou igual a ultima seed, parte pra proxima,
	se menor, calcula quantas traduções faltam "seeds - ultimo traducao", econtra em q numero começa "ultimo traducao"
	traduz a partir daí, com o range sendo o as q faltam ^
	Repete até nao faltar mais
]]--


function translateWithRange(numbers, tr_table)

	translation = {}

	for idx=1,#numbers do
		
		rang = numbers[idx].range
		tr_first,tr_last = translate(numbers[idx], tr_table)
		
		if rang > tr_last - numbers[idx].inicio + 1 then
			rang = tr_last - numbers[idx].inicio + 1
		end
		table.insert(translation, {inicio=tr_first, range=rang})		
		if translation[#translation].range <= 0 then
			translation[#translation].range = 1
		end
		
		while tr_last < numbers[idx].inicio + numbers[idx].range- 1 do
			
			inc = tr_last + 1
			tr_first,tr_last = translate({inicio=inc, range=inc-numbers[idx].inicio}, tr_table)
			
			table.insert(translation, {inicio=tr_first, range=tr_last-inc})		
			if translation[#translation].range <= 0 then
				translation[#translation].range = 1
			end
		end
		
	end
	
	table.sort(translation, sortingFunction)
	translation = agruparTodos(translation)

	return translation

end


function translateAll(numbers, tr_table)

	translation = {}
	for _,number in ipairs(numbers) do
		translated = translate(number, tr_table)
		table.insert(translation, translated)
	end
	
	return translation

end


function writeTrTable(translationTable)

	for k,v in ipairs(translationTable) do
		for l,m in ipairs(v) do
			io.write(m .. " ")
		end
		print("")
	end
end

function findStart(to_soil, line, str, idx)
		
	if to_soil == -1 then
		if line == str then
			return idx
		end

		return -1
	end
	
	return to_soil
	
end


function buildTranslate(lines, start, finish)
	
	translationTable = {}

	for i=start,finish do
		first_num,str_new = readNum(lines[i])
		if first_num == nil then return translationTable end
		second_num,str_new = readNum(str_new)
		if second_num == nil then return translationTable end
		third_num,str_new = readNum(str_new)
		if third_num == nil then return translationTable end

		table.insert(translationTable, {first_num, second_num, third_num})			
	end
	
	return translationTable

end


function readPairs(str)
	
	first_num,second_str = readNum(str)
	if first_num == nil then return nil,str end
	second_num,str_left = readNum(second_str)
	if second_num == nil then return nil,str end
	
	return {first_num, second_num},str_left

end


function readNum(str)

	num_i,num_j = string.find(str, "%d+")
	if num_i == nil then return nil,str end 
	return tonumber(string.sub(str, num_i, num_j)), string.sub(str, num_j + 1)
	
end

function readAllPairs(str, mesa)
	
	par,nova_str = readPairs(str)
	
	while par ~= nil do
		table.insert(mesa, {inicio=par[1], range=par[2]})
		if nova_str == nil then break end
		par,nova_str = readPairs(nova_str) 
	end

	return mesa
end


lines = {}

to_soil = -1
to_fertilizer = -1
to_water = -1
to_light = -1
to_temperature = -1
to_humidity = -1
to_location = -1

for line in io.lines() do
	table.insert(lines, line)
		
	to_soil = findStart(to_soil, line, "seed-to-soil map:", #lines)
	to_fertilizer = findStart(to_fertilizer, line, "soil-to-fertilizer map:", #lines) 
	to_water = findStart(to_water, line, "fertilizer-to-water map:", #lines)
	to_light = findStart(to_light, line, "water-to-light map:", #lines)
	to_temperature = findStart(to_temperature, line, "light-to-temperature map:", #lines)
	to_humidity = findStart(to_humidity, line, "temperature-to-humidity map:", #lines)
	to_location = findStart(to_location, line, "humidity-to-location map:", #lines)

end

seeds = {}
for i=1,to_soil do
	seeds = readAllPairs(lines[i], seeds)
end

--seeds = findSeeds(seeds)

tr_soil = buildTranslate(lines, to_soil+1, to_fertilizer)
tr_fert = buildTranslate(lines, to_fertilizer+1, to_water)
tr_water = buildTranslate(lines, to_water+1, to_light)
tr_light = buildTranslate(lines, to_light+1, to_temperature)
tr_temp = buildTranslate(lines, to_temperature+1, to_humidity)
tr_hum = buildTranslate(lines, to_humidity+1, to_location)
tr_local = buildTranslate(lines, to_location+1, #lines)


soils = translateWithRange(seeds, tr_soil)
ferts = translateWithRange(soils, tr_fert)
waters = translateWithRange(ferts, tr_water)
lights = translateWithRange(waters, tr_light)
temps = translateWithRange(lights, tr_temp)
hums = translateWithRange(temps, tr_hum)
locals = translateWithRange(hums, tr_local)
menor = locals[1].inicio
for idx=1,#locals,2 do
	if locals[idx].inicio < menor then
		menor = locals[idx].inicio
	end
end

print(menor)
