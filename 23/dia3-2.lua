
function calcularNum(line, valores, line_size)
	
	i,j = string.find(line, "%d+")

	while i ~= nil do

		absoluto_i = i + line_size - string.len(line)
		absoluto_j = j + line_size - string.len(line)
		
		if (absoluto_i > 2 and absoluto_i < 6) or (absoluto_j > 2 and absoluto_j < 6) then
			table.insert(valores, tonumber(string.sub(line, i, j)))
		end

		line = string.sub(line, j + 1)
		i,j = string.find(line, "%d+")
	end

	return valores
end


frases = {}
for line in io.lines() do
	table.insert(frases, line)
end

total = 0
for i=1, #frases do
	
	str = frases[i]
	inicio,fim = string.find(str, "%*")
	

	while inicio ~= nil do
		
		inicio_relativo = inicio + string.len(frases[1]) - string.len(str)
		fim_relativo = fim + string.len(frases[1]) - string.len(str)

		--[[
		-- Cima: letra de cima + ate 3 letras de cada lado
		-- Baixo: letra de baixo + ate 3 letras de cada lado
		-- Esquerda: até 3 letras antes do *
		-- Direita: até 3 letras após o *
		--]]
		
		cima = ""
		if i > 1 then
			cima = string.sub(frases[i-1], inicio_relativo, fim_relativo)

			cima_esq = ""
			cima_dir = ""
			
			for esquer=1, 3 do
				parte_esq = string.sub(frases[i - 1], inicio_relativo - esquer, inicio_relativo - esquer)
				if parte_esq == nil then
					break
				end
				cima_esq = parte_esq .. cima_esq
			end
			
			for dire=1, 3 do
				parte_dir = string.sub(frases[i - 1], fim_relativo + dire, fim_relativo + dire)
				if parte_dir == nil then
					break
				end
				cima_dir = cima_dir .. parte_dir
			end

			cima = cima_esq .. cima .. cima_dir

		end
		
		baixo = ""
		if i < #frases then
			baixo = string.sub(frases[i+1], inicio_relativo, fim_relativo)

			baixo_esq = ""
			baixo_dir = ""
			
			for esquer=1, 3 do
				parte_esq = string.sub(frases[i + 1], inicio_relativo - esquer, inicio_relativo - esquer)
				if parte_esq == nil then
					break
				end
				baixo_esq = parte_esq .. baixo_esq
			end
			
			for dire=1, 3 do
				parte_dir = string.sub(frases[i + 1], fim_relativo + dire, fim_relativo + dire)
				if parte_dir == nil then
					break
				end
				baixo_dir = baixo_dir .. parte_dir
			end

			baixo = baixo_esq .. baixo .. baixo_dir

		end
		
		esquerda = ""
		for esq=1, 3 do
			part_e = string.sub(frases[i], inicio_relativo - esq, inicio_relativo - esq)

			if part_e == nil then
				break
			end
			esquerda = part_e .. esquerda
		end

		direita = ""
		for dir=1, 3 do
			part_d = string.sub(frases[i], fim_relativo + dir, fim_relativo + dir)

			if part_d == nil then
				break
			end
			direita = direita .. part_d
		end
		
		--[[
		-- Com todo o entorno construido, contar quantos números tem em volta,
		-- caso 2, multiplica eles e soma com o total
		--]]
		
		vizinhos = calcularNum(cima, {}, string.len(cima))
		vizinhos = calcularNum(baixo, vizinhos, string.len(baixo))
		vizinhos = calcularNum(esquerda .. "." .. direita, vizinhos, string.len(esquerda) + string.len(direita) + 1)
		
		--[[
		print(cima)
		io.write(esquerda)
		print("*" .. direita .. " " .. #vizinhos)
		print(baixo .. "\n")
		for k,v in ipairs(vizinhos) do
			print(v)
		end
		print("-----")
		]]--
		if #vizinhos == 2 then

			total = total + (vizinhos[1] * vizinhos[2])
		end

		str = string.sub(str, fim + 1)
		inicio,fim = string.find(str, "%*")

	end

end

print(total)
