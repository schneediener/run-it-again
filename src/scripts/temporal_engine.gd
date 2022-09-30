extends KinematicBody2D

var effect_dict = {}
var temporal_momentum = 1

func _physics_process(delta):

	calc_temporal_momentum()

func calc_temporal_momentum():
	var value_array = effect_dict.values()
	var temp_modifier = 0
	for value in value_array:
		assert(value != null, "null value in temp momentum value array")
		temp_modifier += value
	
	temporal_momentum = 1+temp_modifier
	if temporal_momentum<0:
		temporal_momentum = 0
