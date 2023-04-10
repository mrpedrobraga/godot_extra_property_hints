tool
extends Control
class_name EditorAnglePicker

var mouse_down : bool = false
var mmouse : Vector2 = Vector2.RIGHT
var maximum_angle_value = TAU
var return_vector : bool = false

var segments : int = 0

var colorbg = Color(0.41598045825958, 0.41598042845726, 0.41598039865494)
var colorfg = Color.white

func _set_color(c : Color):
	colorfg = c
	colorbg = c.darkened(0.6)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			mouse_down = event.pressed
	if event is InputEventMouseMotion:
		if mouse_down:
			mmouse = (event.position - rect_size/2).normalized()
			var angle : float = mmouse.angle()
			if segments > 0:
				var grid : float = TAU/segments
				angle = Vector2(angle, angle).snapped(Vector2(grid, grid)).x
			if return_vector:
				get_parent().emit_changed(get_parent().get_edited_property(), Vector2.RIGHT.rotated(angle))
			else:
				get_parent().emit_changed(get_parent().get_edited_property(), angle/TAU * maximum_angle_value)
			update()

func _draw():
	var midpoint = rect_size/2
	var min_axis = min(rect_size.x, rect_size.y) * 0.7
	
	var angle : float = mmouse.angle()
	if segments > 0:
		var grid = TAU/segments
		angle = Vector2(angle, angle).snapped(Vector2(grid, grid)).x
	var vector := Vector2.RIGHT.rotated(angle)
	
	draw_arc(midpoint, min_axis/2, 0, TAU, 32, colorbg, 2.0, true)
	for i in segments:
		var l_ang : float = i * TAU/segments
		draw_line(midpoint, midpoint + Vector2.RIGHT.rotated(l_ang) * min_axis / 2, colorbg, -1.0, true)
	draw_line(midpoint, midpoint + vector * min_axis / 2, colorfg, 2.0, true)
	draw_circle(midpoint, 4.0, colorfg)
	draw_circle(midpoint + vector * min_axis / 2, 8.0, colorfg)
