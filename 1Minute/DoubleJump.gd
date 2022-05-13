extends Area2D

func body_entered(body):
	body.enable_double_jump(true)
	body.play_powerup()
	body.show_message("Double jump unlocked", 2.0)
	queue_free()
