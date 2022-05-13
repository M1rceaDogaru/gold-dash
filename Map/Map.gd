extends Node

var connections = [
	connection(1, 1, 2, 1),
	connection(1, 2, 3, 1),
	connection(3, 2, 5, 1),
	connection(3, 3, 4, 1),
	connection(3, 4, 6, 1)	
]

func connection(left_room: int, left_door: int, right_room: int, right_door: int):
	return {
		left_room = left_room,
		left_door = left_door,
		right_room = right_room,
		right_door = right_door
	}

var current_room = null

# Called when the node enters the scene tree for the first time.
#func _ready():
#	goto_room({
#		to_room = 1,
#		to_door = 1
#	})

# Room movement infrastructure
func goto_room(room_transition):
	call_deferred("_deferred_goto_room", room_transition)

func _deferred_goto_room(room_transition):	
	var current_door_data = null
	if current_room != null:	
		current_door_data = get_current_door_data(room_transition.from_door)
		current_room.free()
		
	var path = "res://Rooms/Room%s.tscn" % room_transition.to_room

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_room = s.instance()

	var root_scene = get_tree().get_root().get_node("Main");
	var start_position = current_room.get_node("Doors/Door%s" % room_transition.to_door).position
	root_scene.get_node("Player").move_to(start_position)
	root_scene.add_child(current_room)
	
	var new_door_data = get_current_door_data(room_transition.to_door)
	update_map(root_scene, current_door_data, new_door_data)
	
func get_current_door_data(door_id):
	var current_door = current_room.get_node("Doors/Door%s" % door_id)
	var play_area = current_room.get_node("PlayArea")
	return {
		room = current_door.Room_Id,
		door = door_id,
		side = current_door.Door_Side,
		position = play_area.position - current_door.position
	}
	
func update_map(root_scene, from_door, to_door):
	var map = root_scene.get_node("Player/Map")
	var to_room_block = map.get_node_or_null("Room%s" % to_door.room)
	if to_room_block != null:
		return
	
	var new_room_position = Vector2.ZERO
	if from_door != null:
		var from_room_block = map.get_node("Room%s" % from_door.room)
		match from_door.side:
			Door.SIDE.LEFT:
				new_room_position = Vector2(from_room_block.position.x - 10, from_room_block.position.y)
			Door.SIDE.TOP:
				new_room_position = Vector2(from_room_block.position.x, from_room_block.position.y - 10)
			Door.SIDE.RIGHT: 
				new_room_position = Vector2(from_room_block.position.x + 10, from_room_block.position.y)
			Door.SIDE.BOTTOM:
				new_room_position = Vector2(from_room_block.position.x, from_room_block.position.y + 10)
	
	to_room_block = map.get_node("RoomBlock").duplicate()
	map.add_child(to_room_block)
	
	to_room_block.name = "Room%s" % to_door.room
	to_room_block.position = new_room_position
	to_room_block.visible = true

# Room movement logic
func move_from(door_id, room_id):
	var room_transition = get_room_transition(door_id, room_id)
	goto_room(room_transition)

func get_room_transition(door_id, room_id):
	for c in connections:
		if c.left_room == room_id and c.left_door == door_id:
			return {
				from_room = room_id,
				from_door = door_id,
				to_room = c.right_room,
				to_door = c.right_door
			}
		elif c.right_room == room_id and c.right_door == door_id:
			return {
				from_room = room_id,
				from_door = door_id,
				to_room = c.left_room,
				to_door = c.left_door
			}

# Map render
# room_id
# x
# y
# width
# height
# doors
#	door_id
#	x
#	y
#

const ROOM_BLOCK_SIZE = 250
const MAP_BLOCK_SIZE = 20

var roomMapColor = Color(0, 1, 0)
var playerMapColor = Color(1, 0, 0)

var mapData = {
	rooms = [{
		x = 50,
		y = 50
	}]
}

func draw_map():
	for room in mapData.rooms:
		var map_block = ColorRect.new()
		map_block.set_position(Vector2(room.x, room.y))		
		map_block.color = roomMapColor
	
