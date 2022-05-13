extends Label

func _ready():
	var coins = GameData.coins
	if coins == 0:
		text = "You got no coins but at least you're alive"
		return
	
	var result
	if coins < 5:
		result = "A snail could do better"
	elif coins < 20:
		result = "Could buy a cardboard box"
	elif coins < 20:
		result = "Good for a burger and a fizzy drink"
	elif coins < 30:
		result = "Got a nice pouch there"
	elif coins < 50:
		result = "You got moves!"
	elif coins < 66:
		result = "Wow, you almost got all of them"
	else:
		result = "KERCHING! You got ALL of them" 
	
	text = "You fetched %s of 66 coins. %s" % [coins, result]
