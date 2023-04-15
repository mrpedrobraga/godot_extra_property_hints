# Extra Export Hints

## Description

Add your own custom export editors using `_get_property_info(property_name : String) -> Dictionary`. 

It's quicker than `_get_property_list` for simple cases, but both can be combined;

```gdscript
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
``

## Features

- Use some of the builtin custom editors.
- Add your own editors.
- Make properties conditionally visible.
- Make properties update the inspector when edited.

## Hints

- "visible": If false, the property won't show in the inspector.

- "update_inspector": If present, the property will update the inspector when edited.
	Useful if this property updates the visibility status of another.

## Custom Editors

To make a property be handled by a custom editor.

```gdscript
return {
	"editor": <editor_name>
}
```

- "direction"
	Will add a spinny slider you can use to edit angles.
	
	Under this editor, you can also specify:
		- return_type = TYPE_VECTOR2 or TYPE_FLOAT;
		- maximum_value = The length of your vector, or the maximum value of your float value;
		- segments = If bigger than 0, the editor will snaps to <segments> fractions of a whole turn;
