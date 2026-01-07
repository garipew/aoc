function readNext(str)

	local i,j = string.find(str, ".")
	if i == nil then return nil,str end 
	return string.sub(str, i, j), string.sub(str, j + 1)
	
end

function findStart(lines)

	local line = 1
	local i, j = 0, 0
	
	repeat
		i, j = string.find(lines[line], "S")
		if i == nil then line = line + 1 end	
				
	until i ~= nil
	
	return {line,i}

end


function findNext(line, col, lines)

	local cima = "" 
	if line - 1 >= 1 then cima = string.sub(lines[line-1], col, col) end
	local baixo = ""
	if line+1 <= #lines then baixo = string.sub(lines[line+1], col, col) end
	local esq = "" 
	if col - 1 >= 1 then esq = string.sub(lines[line], col-1, col-1) end
	local dir = ""
	if col + 1 <= string.len(lines[line]) then dir = string.sub(lines[line], col+1, col+1) end
	local atual = string.sub(lines[line], col, col)

	nextStep = {}
	if atual == "S" or atual == "|" or atual == "L" or atual == "J" then
		if cima == "S" or cima == "|" or cima == "F" or cima == "7" then table.insert(nextStep, {line-1, col}) end
	end
	if atual == "S" or atual == "|" or atual == "F" or atual == "7" then
		if baixo == "S" or baixo == "L" or baixo == "|" or baixo == "J" then table.insert(nextStep, {line+1, col}) end
	end
	if atual == "-" or atual == "S" or atual == "7" or atual == "J" then
		if esq == "S" or esq == "F" or esq == "-" or esq == "L" then table.insert(nextStep, {line, col-1}) end
	end
	if atual == "-" or atual == "S" or atual == "L" or atual == "F" then
		 if dir == "S" or dir == "-" or dir == "7" or dir == "J" then table.insert(nextStep, {line, col+1}) end
	end
	
	return nextStep
	
end

function encontrar(procurado, mesa)

	for _,v in ipairs(mesa) do
		if v[1] == procurado[1] and v[2] == procurado[2] then return true end
	end

	return false
end


function findPath(startPoint, lines)
	
	local graph = {}
	local line = startPoint[1]
	local col = startPoint[2]
	local i = 1
	local layer = 0
	local nextSteps = {}
	local vizinhos = findNext(line,col,lines)
	for _,v in ipairs(vizinhos) do
		if not encontrar(v, graph) then table.insert(nextSteps, v) end
	end
	
	table.insert(graph, {line, col, vizinhos})
	
	while #nextSteps ~= 0 do
		line = nextSteps[1][1]
		col = nextSteps[1][2]
		table.remove(nextSteps, 1)
		vizinhos = findNext(line,col,lines)
		for _,v in ipairs(vizinhos) do
			if not encontrar(v, graph) and not encontrar(v, nextSteps) then table.insert(nextSteps, v) end
		end
		table.insert(graph, {line, col, vizinhos})
		layer = layer + (i%2)
		i = i + 1
	end	
	
	return graph, layer

end


function escreverGrafo(grafo)
	
	for k,v in ipairs(grafo) do 
		io.write(v[1] .. " " .. v[2] .. " -> ")
		for _,r in ipairs(v[3]) do
			io.write(r[1] .. " " .. r[2] .. ", ")
		end
		print("")
	end
		
end


function readInput()
	local lines = {}
	for line in io.lines() do
		table.insert(lines, line)
	end
	
	return findPath(findStart(lines), lines)	

end


function encontrarVizinhos(line, col, grafo)
	
	for _,v in ipairs(grafo) do

		if v[1] == line and v[2] == col then return v[3] end

	end

	return nil

end


local start = os.clock()
grafo,layer = readInput()
--escreverGrafo(grafo)
print(layer)
print("End: " .. os.clock() - start .. "s")
