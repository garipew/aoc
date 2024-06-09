function escreverSeq(sequencia)
	for _,v in ipairs(sequencia) do
		io.write(v .. " ")
	end
	print("")
end


function escreverSequencias(sequencias)
	for _,v in ipairs(sequencias) do
		escreverSeq(v)
	end
end


function readNext(str)

	local i,j = string.find(str, " ")
	if i == nil then return nil,str end 
	return string.sub(str, 0, i-1), string.sub(str, j + 1)
	
end


function readInput()
	local lines = {}
	for line in io.lines() do
		table.insert(lines, line)
	end
	
	local seqs = {}
	
	for _,line in ipairs(lines) do
		local str = line
		local num = 0
		local seq = {}
		num,str = readNext(str)
		repeat
			table.insert(seq, tonumber(num))
			num,str = readNext(str)
		until num == nil
		table.insert(seq, tonumber(str))
		table.insert(seqs, seq)
	end	
	
	return seqs

end


function newSequence(sequence)
	new = {}

	for i=2,#sequence do
		table.insert(new, sequence[i] - sequence[i-1])
	end
	return new		
end


function checarSequencia(seq)
	
	for _,v in ipairs(seq) do
		if v ~= 0 then return false end
	end
	return true
end


function somarSequencias(a, b)

	for i=1,#a do 
		b[i+1] = a[i] + b[i]
	end

	return b

end


function quebrarSequencia(sequencia)

	local proximasSeq = {}
	local ultimaSeq = sequencia
	table.insert(proximasSeq, sequencia)
	repeat
		ultimaSeq = newSequence(ultimaSeq)
		table.insert(proximasSeq, ultimaSeq)	
	until checarSequencia(ultimaSeq)

	return proximasSeq
end


function preverProximo(sequencia)
	
	local proximasSeq = quebrarSequencia(sequencia)
	local previsao = 0
		
	table.insert(proximasSeq[#proximasSeq], 0) 

	for i=#proximasSeq,2,-1 do
		proximasSeq[i-1] = somarSequencias(proximasSeq[i], proximasSeq[i-1])
		previsao = proximasSeq[i-1][#(proximasSeq[i-1])]
	end

	return previsao	
end


function encontrarAnterior(sequencia)
	
	local sequencias = quebrarSequencia(sequencia)
	local anterior = 0
	
	for i=#sequencias-1,1,-1 do
		anterior = sequencias[i][1] - anterior
	end

	return anterior

end


sequencias = readInput()
somaPrevisoes = 0
somaAnteriores = 0
for _,v in ipairs(sequencias) do
	--somaPrevisoes = somaPrevisoes + preverProximo(v)
	somaAnteriores = somaAnteriores + encontrarAnterior(v)
end

print(somaAnteriores)
