extends Node2D

const CAMERA_ZOOM_SPEED = 3
const CAMERA_POSITION_SPEED = 50
const CAMERA_ZOOM_LIMIT = 0.4

onready var score_label = get_node("Canvas/Score")
onready var time_label = get_node("Canvas/Timer")
onready var camera = $Player/Camera

func _ready():
	begin()

func _process(delta):
	update_camera(delta)
	update_time()
	update_score()

func update_time():
	if !GameData.round_in_progress or time_label == null:
		return
	time_label.text = "%2.1f" % GameData.current_time
	if GameData.current_time < 10:
		time_label.add_color_override("font_color", Color(1, 0, 0))
	
func update_score():
	if !GameData.round_in_progress or score_label == null:
		return
	score_label.text = str(GameData.coins)
	
func begin():
	$Labels/GetReady.visible = true
	yield(get_tree().create_timer(2.0), "timeout")
	$Labels/GetReady.visible = false
	$Labels/Go.visible = true
	GameData.start()
	setup_camera()
	yield(get_tree().create_timer(2.0), "timeout")
	$Labels/Go.visible = false
	
func setup_camera():
	camera.position = Vector2.ZERO
	camera.smoothing_enabled = true	

func update_camera(delta):
	if !GameData.round_in_progress:
		return
	
	var new_zoom = clamp(camera.zoom.x - CAMERA_ZOOM_SPEED * delta, CAMERA_ZOOM_LIMIT, 1)	
	camera.zoom = Vector2(new_zoom, new_zoom)
