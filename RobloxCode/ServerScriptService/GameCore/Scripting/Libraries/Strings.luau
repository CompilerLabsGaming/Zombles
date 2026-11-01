local module = {}

-- string search in list
function module.list_has_string(list, searching_for)
	for name, value in ipairs(list) do
		if type(value) == "string" and value == searching_for then
			return true
		end
	end
	
	return false
end

return module
