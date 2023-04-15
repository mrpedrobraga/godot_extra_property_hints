@tool
extends Node2D

@export var my_int : int
@export var my_float2 : float

func _get_property_info(prop : String):
	match prop:
		"my_int":
			return {
				"update_inspector": true
			}
		"my_float2":
			return {
				"visible": my_int > 0
			}
	pass
