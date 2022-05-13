extends Area2D

var collected = false

func _ready():
	$AnimationPlayer.playback_speed = rand_range(1, 5)

func body_entered(body):
	if collected:
		return
	
	collected = true
	GameData.collect_coin()
	body.play_clink()
	queue_free()
