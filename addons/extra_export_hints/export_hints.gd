tool
extends EditorInspectorPlugin

func can_handle(object):
	return true

func parse_property(object, type, path, hint_type, hint_string, usage_flags):
	var extra_hints : Dictionary
	if object.has_method("_get_extra_hints"):
		var value = object._get_extra_hints(path)
		if not value:
			return
		extra_hints = value
	
	if not extra_hints.has("editor"):
		return
	
	match extra_hints.editor:
		'direction':
			return add_direction_editor(object, path, extra_hints)

func add_direction_editor(object, path, hints):
	var ep := EditorProperty.new()
	var editor := EditorAnglePicker.new()
	
	if hints.has("segments"):
		editor.segments = hints["segments"]
	if hints.has("max"):
		editor.maximum_angle_value = hints["max"]
	if hints.has("color"):
		editor._set_color(hints["color"])
	
	editor.mmouse = Vector2.RIGHT.rotated(object.get(path))
	editor.rect_min_size.x = 64
	editor.rect_min_size.y = 64
	editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ep.keying = true
	
	ep.add_child(editor)
	add_property_editor(path, ep)
	return true
