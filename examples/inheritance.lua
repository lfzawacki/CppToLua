-- demonstrating inheritance


function treatKitteh(cat)
	print(cat)
	cat:magic()
	cat:sleep()
end


k = Cat:new()
l = Lynx:new()

print("Cat sleeping")
k:sleep()
print("Lynx sleeping")
l:sleep()

print("Passing both to a function expecting a cat")
treatKitteh(k)
treatKitteh(l)

print("Function unique to Lynx")
l:checkFightPower()
