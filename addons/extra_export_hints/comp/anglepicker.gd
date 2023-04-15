@tool
extends Control
class_name EditorDirectionPicker

var mouse_down : bool = false
var mmouse : Vector2 = Vector2.RIGHT

var maximum_value = TAU
var return_vector : bool = false

var segments : int = 0

var colorbg = Color(0.41598045825958, 0.41598042845726, 0.41598039865494)
var colorfg = Color.WHITE

signal changed

func _set_color(c : Color):
	colorfg = c
	colorbg = c.darkened(0.6)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			mouse_down = event.pressed
	if event is InputEventMouseMotion:
		if mouse_down:
			mmouse = (event.position - size/2).normalized()
			var angle : float = mmouse.angle()
			if segments > 0:
				angle = snappedf(angle, TAU/segments)
			var new_value
			if return_vector:
				new_value = Vector2.RIGHT.rotated(angle) * maximum_value
			else:
				new_value = angle/TAU * maximum_value
			get_parent().get_edited_object().set(get_parent().get_edited_property(), new_value)
			get_parent().emit_changed(get_parent().get_edited_property(), new_value, &"", true)
			changed.emit()
			queue_redraw()

func _draw():
	var midpoint = size/2
	var min_axis = min(size.x, size.y) * 0.7
	
	var angle : float = mmouse.angle()
	if segments > 0:
		angle = snappedf(angle, TAU/segments)
	var vector := Vector2.RIGHT.rotated(angle)
	
	draw_arc(midpoint, min_axis/2, 0, TAU, 32, colorbg, 2.0, true)
	for i in segments:
		var l_ang := i * TAU/segments
		draw_line(midpoint, midpoint + Vector2.RIGHT.rotated(l_ang) * min_axis / 2, colorbg, -1.0, true)
	draw_line(midpoint, midpoint + vector * min_axis / 2, colorfg, 2.0, true)
	draw_circle(midpoint, 4.0, colorfg)
	draw_circle(midpoint + vector * min_axis / 2, 8.0, colorfg)
