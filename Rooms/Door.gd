extends Area2D

export var Door_Id = 0
export var Room_Id = 0
export(Door.SIDE) var Door_Side

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func body_entered(_body:Node):
	Map.move_from(Door_Id, Room_Id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
