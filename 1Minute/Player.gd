extends KinematicBody2D

export (int) var speed = 180
export (int) var jump_speed = -550
export (int) var gravity = 2000
export (float, 0, 1.0) var drag = 0.5
export (float, 0, 1.0) var acceleration = 0.75

var velocity = Vector2.ZERO
onready var sprite = $Sprite

var can_double_jump = false
var has_double_jumped = false

var hurry_message_shown = false

func _physics_process(delta):
	if !GameData.round_in_progress:
		return
		
	move()
	var on_floor = is_on_floor()
	if on_floor and can_double_jump:
		has_double_jumped = false
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("jump"):
		if on_floor:
			velocity.y = jump_speed
			play_jump()
		if can_double_jump and !has_double_jumped:
			velocity.y = jump_speed
			has_double_jumped = true
			play_jump()	
	
	if GameData.current_time < 10 and !hurry_message_shown:
		show_message("HURRY!", 2)
		hurry_message_shown = true

func move():
	var direction = 0
	if Input.is_action_pressed("walk_right"):
		direction += 1
	if Input.is_action_pressed("walk_left"):
		direction -= 1
		
	if direction != 0:
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, drag)
		
	animate(direction)

# Animation
func animate(look_towards):
	if is_on_floor():
		if look_towards == 0:
			sprite.animation = "idle"
		else:
			sprite.animation = "walk"
	else:
		if velocity.y < 0:
			sprite.animation = "jump"
			sprite.frame = 2
		else:
			sprite.animation = "jump"
			sprite.frame = 3
	
	if look_towards != 0:	
		sprite.flip_h = look_towards < 0
		
func enable_double_jump(value):
	can_double_jump = value
	
func show_message(message, duration):
	$Notification.text = message
	$Notification.visible = true
	yield(get_tree().create_timer(duration), "timeout")
	$Notification.visible = false

func play_jump():
	$Audio/Jump.play()
	
func play_powerup():
	$Audio/Powerup.play()
	
func play_clink():
	$Audio/Coin.play()
