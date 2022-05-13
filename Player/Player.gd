extends RigidBody2D

# Player settings
var speed = 180
var wallJumpLerp = 10
var jumpForce = 400

var canMove = true
var wallGrab = false
var wallJumped = false

# Collision state
onready var groundCheck = $GroundCheck
onready var groundCheckLeft = $GroundCheckLeft
onready var groundCheckRight = $GroundCheckRight
onready var collider = $CollisionShape
var onGround: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var x = -1 if Input.is_key_pressed(KEY_A) else (1 if Input.is_key_pressed(KEY_D) else 0)
	var y = -1 if Input.is_key_pressed(KEY_W) else (1 if Input.is_key_pressed(KEY_S) else 0)
	var direction = Vector2(x, y)
	onGround = groundCheck.is_colliding() or groundCheckLeft.is_colliding() or groundCheckRight.is_colliding()
	physics_material_override.friction = 1 if onGround else 0
	print(onGround)
	
	walk(direction, delta)
	
	if (Input.is_key_pressed(KEY_SPACE)):
		jump()	
		
	animate(x)

func walk(direction:Vector2, delta:float):
	if (!canMove or !direction):
		return
	
	if (wallGrab):
		return		
		
	var collisions = get_colliding_bodies()
	
	
	if (!wallJumped):
		set_axis_velocity(Vector2(direction.x * speed, 0))
	else:
		set_axis_velocity (linear_velocity.linear_interpolate(Vector2(direction.x * speed, 0), wallJumpLerp * delta))

func jump():
	if (!onGround):
		return
	
	set_axis_velocity(Vector2.UP * jumpForce)
	
func move_to(position: Vector2):
	global_position = position
	$Camera.reset_smoothing()
	
# Animation
func animate(look_towards):
	if (look_towards == 0):
		return
		
	$Sprite.flip_h = look_towards < 0

# Physics handlers	
#func _integrate_forces(state):
#	if move_position == null:
#		return
#
#	var t = state.get_transform()
#	t.origin.x = move_position.x
#	t.origin.y = move_position.y
#	state.set_transform(t)
#	move_position = null
#	mode = MODE_CHARACTER
