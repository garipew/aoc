function readNum(str)

	local num_i,num_j = string.find(str, "%d+")
	if num_i == nil then return nil,str end 
	return tonumber(string.sub(str, num_i, num_j)), string.sub(str, num_j + 1)
	
end


function readInput()
	local lines = {}
	for line in io.lines() do
		table.insert(lines, line)
	end

	
	local games = {}
	local tempo = 0
	local distancia = 0
	local tempo_str = lines[1]
	local distancia_str = lines[2]
	while tempo_str ~= nil and distancia_str ~= nil do
		tempo,tempo_str = readNum(tempo_str)
		distancia,distancia_str = readNum(distancia_str)
		if tempo == nil or distancia == nil then break end
		table.insert(games, {time=tempo, distance=distancia})
	end
	

	local bigTime = ""
	local bigDistance = ""
	for _,game in ipairs(games) do
		bigTime = bigTime .. game.time
		bigDistance = bigDistance .. game.distance
	end

	--return games
	return {{time=tonumber(bigTime), distance=tonumber(bigDistance)}}
end

function bruteForce(time, speed, game)

	greater_distances = 0

	while time > 0 do
		distance = speed * time
		if distance > game.distance then greater_distances = greater_distances + 1 end
		speed = speed + 1
		time = time - 1
	end
	
	return greater_distances

end

function border(inicio, fim, game)
	
	worst_distances = 0
	
	speed = inicio
	time = fim
	
	while time > 0 do

		distance = speed * time
		if distance > game.distance then break end
		worst_distances = worst_distances + 1
		speed = speed + 1
		time = time - 1

	end
	
	return worst_distances

end

function findGreaterDistances(game)
	
	local worst_distances = 2 * (border(0, game.time, game))
	
	return game.time + 1 - worst_distances 

end


game = readInput()

winning_games = 1
for _,g in ipairs(game) do
	winning_games = winning_games * findGreaterDistances(g)
end
print(winning_games)
