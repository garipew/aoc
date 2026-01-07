
frases = {}
for line in io.lines() do
	table.insert(frases, line)
end

total = 0
for i=1, #frases do
	
	str = frases[i]
	inicio,fim = string.find(str, "%d+")
	

	while inicio ~= nil do

		num = string.sub(str, inicio, fim)
		piece_counter = 0	
		
		inicio_relativo = inicio + string.len(frases[i]) - string.len(str)
		fim_relativo = fim + string.len(frases[i]) - string.len(str)


		if i > 1 then
			cima = string.sub(frases[i-1], inicio_relativo, fim_relativo)

			cima_esq = ""
			cima_dir = ""
			
			if inicio > 1 then
				cima_esq = string.sub(frases[i - 1], inicio_relativo-1, inicio_relativo -1)
			end

			if fim < string.len(str) then
				cima_dir = string.sub(frases[i - 1], fim_relativo + 1, fim_relativo + 1)
			end
			
			cima = cima_esq .. cima .. cima_dir
			cima,_ = string.gsub(cima, '%.', "")
			cima,_ = string.gsub(cima, '[0-9]+', "")
			
			if string.len(cima) > 0 then
				piece_counter = 1
			end



		end

		if inicio > 1 then
			esq = string.sub(str, inicio - 1, inicio - 1)
			
			esq = string.gsub(esq, "%.", "")
			esq = string.gsub(esq, '[0-9]+', "")
			if string.len(esq) > 0 then
				piece_counter = 1
			end

		end


		if fim < string.len(str) then
			dir = string.sub(str, fim + 1, fim + 1)
			
			dir = string.gsub(dir, "%.", "")
			dir = string.gsub(dir, '[0-9]+', "")
			if string.len(dir) > 0 then
				piece_counter = 1
			end

		end

		
		
		if i < #frases then
			
			baixo = string.sub(frases[i+1], inicio_relativo, fim_relativo)
			
			baixo_esq = ""
			baixo_dir = ""
			
			if inicio > 1 then
				baixo_esq = string.sub(frases[i + 1], inicio_relativo-1, inicio_relativo -1)
			end

			if fim < string.len(str) then
				baixo_dir = string.sub(frases[i + 1], fim_relativo+1, fim_relativo + 1)
			end
			
			baixo = baixo_esq .. baixo .. baixo_dir
			baixo,_ = string.gsub(baixo, "%.", "")
			baixo,_ = string.gsub(baixo, '[0-9]+', "")

			if string.len(baixo) > 0 then
				piece_counter = 1
			end

		end


		total = total + (tonumber(num) * piece_counter)

		str = string.sub(str, fim + 1)
		inicio,fim = string.find(str, "%d+")

	end

end

print(total)
