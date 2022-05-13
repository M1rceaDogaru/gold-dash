extends Node

const ROUND_TIME = 60

var coins = 0
var round_in_progress = false
var current_time = ROUND_TIME
	
func _process(delta):
	if !round_in_progress:
		return
		
	current_time -= delta	
	if current_time < 0:
		end_bad()

func collect_coin():
	coins += 1
	
func start():
	round_in_progress = true

func end_bad():
	round_in_progress = false
	call_deferred("_deferred_end_bad")
func _deferred_end_bad():
	load_new("EndBad")
	
func end_good():
	round_in_progress = false
	call_deferred("_deferred_end_good")
func _deferred_end_good():
	load_new("EndGood")

func begin_round():
	current_time = ROUND_TIME
	coins = 0
	round_in_progress = false	
	call_deferred("_deferred_begin_round")
	
func _deferred_begin_round():
	load_new("Room")
	
func load_new(name):
	var root = get_tree().get_root()
	clear_current(root)
	
	var path = "res://1Minute/%s.tscn" % name
	var s = ResourceLoader.load(path)
	var room = s.instance()
	root.add_child(room)
	
func clear_current(root):
	for scene_name in ["Menu", "End", "Room"]:
		var scene = root.get_node_or_null(scene_name)
		if scene != null:
			scene.free()
