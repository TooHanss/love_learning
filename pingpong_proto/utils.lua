local utils = {}

function utils.float_eq(a, b, epsilon)
	epsilon = epsilon or 1e-6
	return math.abs(a - b) <= epsilon
end

function utils.clamp(val, lower, upper)
	return math.max(lower, math.min(upper, val))
end

return utils
