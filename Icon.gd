tool
extends Sprite

export var my_angle : int = 0.0

func _get_extra_hints(prop):
	match prop:
		'my_angle':
			return {
				'editor': 'direction',
				'segments': 8
			}
		'rotation_degrees':
			return {
				'editor': 'direction',
				'max': 360,
				'color': Color(0.992188, 0.694755, 0.182159)
			}
