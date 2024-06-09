function readNext(str)

	local i,j = string.find(str, ".")
	if i == nil then return nil,str end 
	return string.sub(str, i, j), string.sub(str, j + 1)
	
end


function readPos(str)

	local i,j = string.find(str, "[A-Z0-9]+")
	if i == nil then return nil,str end 
	return string.sub(str, i, j), string.sub(str, j + 1)
	
end


function readInput()
	local lines = {}
	for line in io.lines() do
		table.insert(lines, line)
	end
	
	lines[1],_ = string.gsub(lines[1], "R", "2")
	lines[1],_ = string.gsub(lines[1], "L", "1")

	local games = {}
	local str = ""
	for i=3,#lines do
		str = lines[i]
		posicao,str = readPos(str)
		vizinho1,str = readPos(str)
		vizinho2,str = readPos(str)

		if posicao == nil or vizinho1 == nil or vizinho2 == nil then break end
		
		table.insert(games, {pos=posicao, viz={vizinho1, vizinho2}})
	end

	return lines[1],games
end


function encontrarPosicao(chave, mapa)
	
	local i = nil
	
	for k,v in ipairs(mapa) do
		i,_ = string.find(v.pos, chave)
		if i ~= nil and i == 1 then return v,k end
	end
	
	return nil,0
end


function andar(passo, posicao, mapa)

	return encontrarPosicao(posicao.viz[tonumber(passo)], mapa)

end


function copiarMapa(mapa)

	copia = {}

	for _,v in ipairs(mapa) do
		table.insert(copia, {pos=v.pos, viz={v.viz[1], v.viz[2]}})
	end

	return copia

end

function encontrarInicio(mapa)
	
	local posicoes = copiarMapa(mapa)
	local inicios = {}
	local novo_inicio,i = encontrarPosicao(".+A", posicoes)
	
	while novo_inicio ~= nil do
		table.insert(inicios, novo_inicio)
		table.remove(posicoes, i)
		novo_inicio,i = encontrarPosicao(".+A", posicoes)
	end

	return inicios
	 
end


function percorrerCaminho(inicio, caminho, mapa, caminhoRestante)
	
	local str = caminhoRestante .. caminho
	local proximo_passo,str = readNext(str) 
	local posicao_atual = inicio
	local passos = 0
	local novaPos = encontrarPosicao(posicao_atual.viz[tonumber(proximo_passo)], mapa)
	local i = nil
	local j = nil
				
	while i == nil do
		
		passos = passos + 1
		posicao_atual = novaPos
 		i,j = string.find(posicao_atual.pos, ".+Z")
		if i ~= nil then break end
		repeat
			proximo_passo,str = readNext(str)
			if string.len(str) == 0 then str = caminho end
		until proximo_passo ~= nil
		novaPos = andar(proximo_passo, posicao_atual, mapa)
	end

	return passos,posicao_atual,str

end



function percorrerCaminhoCompleto(inicio, caminho, mapa)

	local start_end,pos,resto = percorrerCaminho(inicio, caminho, mapa, "")
	return start_end
end


function checarDivisao(array, num)
	
	for _,v in ipairs(array) do
		if num % v ~= 0 then return false end
	end

	return true
end


function mmc(array)
	
	local maior = array[1]
	local min = array[1]
	for i=2,#array do
		if array[i] > maior then maior = array[i] end
		min = min * array[i]
	end

	local mmc = maior

	repeat
		local encontrado = true
		for k,v in ipairs(array) do
			if mmc % v ~= 0 then 
				encontrado = false 
				print(mmc .. " nao é o suficiente, min = " .. min)
				break
			end
		end
		if not encontrado then mmc = mmc + maior end
	until encontrado or mmc + maior > min
	
	return mmc

end

function calcularPassos(inicios)
	
	local start_points = {}
	for i=1,#inicios do
		start_points[i] = inicios[i].cicle
	end
	
	-- Menor numero em q todas as retas se intersectam, cada reta começa em start_end e cresce no ritmo de end_end	
	
	local passos = mmc(start_points)
			
	return passos	
end


caminho,mapa = readInput()
start_points = encontrarInicio(mapa)
for k,v in ipairs(start_points) do 
	s,e = percorrerCaminhoCompleto(v, caminho, mapa)
	start_points[k].cicle = s
end
print("+++++++++++++++")
print(calcularPassos(start_points))
--print(percorrerCaminhos(start_points, caminho, mapa))

