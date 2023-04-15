@tool
extends EditorInspectorPlugin
class_name ExtraEditorInspectorPlugin

var _EditorInterface : EditorInterface

func _can_handle(object):
	if object.has_method("_get_property_info")and object.get_script():
		if not object.get_script().is_tool():
			push_warning("Script must be 'tool' for _get_property_info to have any effect.")
	return true

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	var extra_hints : Dictionary
	if object.has_method("_get_property_info"):
		var value = object._get_property_info(name)
		if not value is Dictionary:
			# Try getting hints from @export_enum instead.
			if not hint_type == PROPERTY_HINT_ENUM:
				return false
			value = get_hints_from_string(hint_string)
		extra_hints = value
	
	# Add buttons before a property.
	if extra_hints.has('buttons'):
		for button_info in extra_hints.buttons:
			if not button_info.has("callback"):
				continue
			var button_callback = button_info.callback
			var btn := Button.new()
			btn.text = name.capitalize()
			if button_callback.is_standard():
				var methodname = button_callback.get_method()
				if methodname: btn.text = methodname.capitalize()
			btn.pressed.connect(
				func ():
					var result = button_info.callback.call(btn)
					if result:
						btn.text = str(result)
					return result
			)
			if button_info.has("label"):
				btn.text = str(button_info.label)
			if button_info.has("color"):
				btn.modulate = button_info.color
			if button_info.has("visible"):
				if button_info["visible"]:
					add_custom_control(btn)
			else:
				add_custom_control(btn)

	# Add warnings before a property.
	if extra_hints.has('warnings'):
		for warning_info in extra_hints.warnings:
			var lbl := Label.new()
			if not warning_info.has("label"):
				continue
			lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			lbl.add_theme_stylebox_override(&"normal", preload("res://addons/extra_export_hints/comp/simple_outline.stylebox"))
			lbl.custom_minimum_size.y = 32
			lbl.text = warning_info.label
			lbl.modulate = Color(1, 0.81666666269302, 0)
			if warning_info.has("color"):
				lbl.modulate = warning_info.color
			if warning_info.has("visible"):
				if warning_info["visible"]:
					add_custom_control(lbl)
			else:
				add_custom_control(lbl)
	
	# Add Rich warnings, using RichTextLabels;
	if extra_hints.has('rich_warnings'):
		for warning_info in extra_hints.rich_warnings:
			var lbl := RichTextLabel.new()
			if not warning_info.has("label"):
				continue
			lbl.bbcode_enabled = true
			lbl.text = "[center]" + str(warning_info.label)
			lbl.add_theme_stylebox_override(&"normal", preload("res://addons/extra_export_hints/comp/simple_outline.stylebox"))
			lbl.fit_content = true
			lbl.custom_minimum_size.y = 32
			lbl.modulate = Color(1, 0.81666666269302, 0)
			if warning_info.has("color"):
				lbl.modulate = warning_info.color
			if warning_info.has("visible"):
				if warning_info["visible"]:
					add_custom_control(lbl)
			else:
				add_custom_control(lbl)

	# Make properties hidden!
	if extra_hints.has("visible"):
		if not extra_hints["visible"]:
			return true
	
	# Make some properties update the inspector;
	var insp := _EditorInterface.get_inspector()
	if extra_hints.has("update_inspector"):
		insp.property_edited.connect(
			func(prop):
				object.notify_property_list_changed()
		)
	
	var custom_editor_result = _handle_custom_editor(object, name, extra_hints)
	return custom_editor_result
	
	return false

func _handle_custom_editor(object : Object, property_name : String, property_info : Dictionary):
	pass

func get_hints_from_string(hint_string):
	var hints : PackedStringArray = hint_string.split(",")
	var result := {}
	
	result.editor = hints[0]
	hints.remove_at(0)
	
	for hint in hints:
		match result.editor:
			'direction':
				if hint.is_valid_int():
					result.segments = hint.to_int()
	
	return result

func get_current_value(object : Object, property_name : String):
	var initial_value = object.get(property_name)
	if initial_value == null and object.script:
		initial_value = object.get_script().get_property_default_value(property_name)
	return initial_value
