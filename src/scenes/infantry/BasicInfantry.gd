extends TowersGeneral


#var upgrade_path = load("res://src/scenes/towers/CannonT2.tscn")
var buy_value = 0
var muzzle_count = 1
var upgrade_value
var sell_value
var damage = 1
var tower_type = "Infantry"
var weapon_type = "cannon"

var command_position = Vector2()
var velocity = Vector2()
var speed = 250
export var orig_speed = 250
var path = PoolVector2Array()

func _ready():
	built = true
	ready = true
	type = "infantry"

func incoming_movement_command(inc_position):
	command_position = inc_position

func _physics_process(delta):
	speed = orig_speed*temporal_momentum
	
	if command_position:
		look_at(command_position)
		var target_vector = global_position.direction_to(command_position)
		velocity = move_and_slide(target_vector * self.speed) * delta
		var path_distance = global_position.distance_to(command_position)
		if path_distance <= 16:
			path.remove(0)
			command_position = null
