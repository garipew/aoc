
function lerNum(line)
	
	padroes = { 
	["one"] = "o1e",
	["two"] = "t2o",
	["three"] = "t3e",
	["four"] = "f4r",
	["five"] = "f5e",
	["six"] = "s6x",
	["seven"] = "s7n",
	["eight"] = "e8t",
	["nine"] = "n9e"
	}
	
	for padrao,valor in pairs(padroes) do
		
		line,_ = string.gsub(line, padrao, valor)
	
	end

	return line

end

calibration = 0
for line in io.lines() do

	if line == nil then
		goto continue
	end
	
	line = lerNum(line)
	numbers,_ = string.gsub(line, "%a+", "")
	cal = tonumber(string.sub(numbers, 1, 1) .. string.sub(numbers, -1)) 
	
	calibration = calibration + cal

	::continue::
end

print(calibration)
