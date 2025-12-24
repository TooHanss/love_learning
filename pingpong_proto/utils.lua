local utils = {}

function utils.float_eq(a, b, epsilon)
	epsilon = epsilon or 1e-6
	print("e = ", epsilon, "x = ", math.abs(a - b))
	return math.abs(a - b) <= epsilon
end

return utils
