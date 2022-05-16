extends Node

export (PackedScene) var fleche_scene

	
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FlecheTimer_timeout():
	var fleche = fleche_scene.instance()
	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var fleche_spawn_location = get_node("SpawnPath/SpawnLocation")
	# And give it a random offset.
	fleche_spawn_location.unit_offset = randf()
	var treadmill_position = $Treadmill.transform.origin
	fleche.initialize(fleche_spawn_location.translation, treadmill_position)
	add_child(fleche)
