@tool
extends Node2D

@export var my_int : int
@export var my_float2 : float
@export var my_float3 : float
@export var my_action3 : StringName
@export var my_boolean : bool = false

func _get_property_info(prop : String):
	match prop:
		"my_int":
			return {
				"update_inspector": true,
				"warnings": [
					{
						"label": "This value must be positive.",
						"visible": my_int <= 0
					},
					{
						"label": "I wuv you.",
						"color": Color(0.1171875, 0.68963623046875, 1)
					}
				]
			}
		"my_float2":
			return {
				"visible": my_int > 0,
				"editor": "direction",
				"buttons": [
					{"callback": (func increment(btn): my_int += 1; notify_property_list_changed()), "label": "Increment"},
					{"callback": (func decrement(btn): my_int -= 1; notify_property_list_changed()), "label": "Decrement"}
				]
			}
		"my_float3":
			return {
				"editor": "direction",
				"color": Color(1, 0, 0)
			}
		"rotation":
			return {
				"editor": "direction",
				"segments": 4
			}
		"my_action3":
			return {
				"editor": "fuzzy_search",
				"items": InputMap.get_actions(),
				"color": Color(0, 0.69999980926514, 1)
			}
		"my_boolean":
			return {
				"editor": "check_button",
				"color": Color(1, 0, 0.51666688919067)
			}
		
		_:
			var plist := get_property_list()
			for i in plist:
				if i.name == prop and i.type == TYPE_BOOL:
					return {
						"editor": "check_button"
					}
	pass
