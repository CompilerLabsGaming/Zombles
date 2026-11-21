local Module = {}

-- string search in list
function Module.ListHasString(list, searchingFor)
	for name, value in ipairs(list) do
		if type(value) == "string" and value == searchingFor then
			return true
		end
	end
	
	return false
end

return Module
