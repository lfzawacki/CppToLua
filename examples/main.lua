print("Let's make a kitteh")

local i = 0
local k = nil

while (true) do
	k = Cat:new()

	--k:query()
	--k:sleep()

	--print( "Cat made " .. k:makeCake() .. " with his pancake mix!")

	print(i .. ": " .. tostring(k) )

	i = i + 1
end
