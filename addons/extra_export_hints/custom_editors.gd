@tool
extends ExtraEditorInspectorPlugin

func _handle_custom_editor(object : Object, property_name : String, property_info : Dictionary):
	if not property_info.has("editor"):
		return false
	
	match property_info.editor:
		'direction':
			return add_direction_editor(object, property_name, property_info)

func add_direction_editor(object : Object, property_name : String, property_info : Dictionary):
	var ep := EditorProperty.new()
	var initial_value = get_current_value(object, property_name)
	var editor := EditorDirectionPicker.new()
	
	if initial_value:
		if initial_value is Vector2:
			editor.mmouse = initial_value
		else:
			editor.mmouse = Vector2.RIGHT.rotated(initial_value)
	if property_info.has("segments"):
		editor.segments = property_info["segments"]
	if property_info.has("maximum_value"):
		editor.maximum_value = property_info["maximum_value"]
	if property_info.has("return_type"):
		match property_info.return_type:
			TYPE_VECTOR2:
				editor.return_vector = true
	if property_info.has("color"):
		editor._set_color(property_info["color"])
	
	editor.custom_minimum_size.x = 64
	editor.custom_minimum_size.y = 64
	editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ep.keying = true
	ep.label = property_name
	
	ep.add_child(editor)
	add_property_editor(property_name, ep)
	return true
