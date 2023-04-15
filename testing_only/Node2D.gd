@tool
extends Node2D

@export var my_int : int
@export var my_float2 : float
@export var my_float3 : float
@export var my_action3 : StringName
@export var my_boolean : bool = false

func _get_property_info(prop : String):
	match prop:
		"my_float2":
			return {
				"visible": my_int > 0,
				"editor": "direction",
				"buttons": [
					{"callback": (func increment(btn): my_int += 1; notify_property_list_changed()),
						"label": "Increment"},
					{"callback": (func decrement(btn): my_int -= 1; notify_property_list_changed()),
						"label": "Decrement"}
				]
			}
	pass
