# Extra Export Hints

## Description

Add your own custom export editors using `_get_property_info(property_name : String) -> Dictionary`. 


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
```
It's quicker than `_get_property_list` for simple cases, but both can be combined;

And it even has the ability to edit builtin properties.
Try this:

```gdscript
func _get_property_info(prop : String):
	match prop:
		"rotation":
			return {
				"editor": "direction"
			}
```

## Features

- Use some of the builtin custom editors.
- Add your own editors.
- Make properties conditionally visible.
- Make properties update the inspector when edited.

## Builtin Hints

- "visible": If false, the property won't show in the inspector.

- "update_inspector": If present, the property will update the inspector when edited.
	Useful if this property updates the visibility status of another.

- "buttons": An array of `Dictionary`s that will be added as buttons.
	You must specify a property 'callback' for the button to work.
	This callback must take a single argument, which is the button you pressed.
	
	You can optionally specify 'label', 'visible' and 'color.'

- "warnings": An array of `Dictionary`s that will be added as labels.
	You must specify a property 'label' for the warning to work.
	
	You can optionally specify 'visible' and 'color.'
	
	An alternative to "warnings" is "rich_warnings", which will add a 
	BBCode-enabled `RichTextLabel`.
	

## Custom Editors

To make a property be handled by a custom editor.

```gdscript
return {
	"editor": <editor_name>
}
```

- "check_button"
	This editor will make so booleans display a check button
	instead of a checkbox.

- "direction"
	Will add a spinny slider you can use to edit angles.
	
	Under this editor, you can also specify:
		- return_type = TYPE_VECTOR2 or TYPE_FLOAT;
		- maximum_value = The length of your vector, or the maximum value of your float value;
		- segments = If bigger than 0, the editor will snaps to <segments> fractions of a whole turn;

- "fuzzy_search"
	Will add a button and a new Window for searching entries to a large enum.
	It's much better than a gigantic option menu popup.
	
	- If specified, "items" is an optional property it'll read from to determine the contents of the enum;
	- If specified, "editor_icon" will allow setting an icon to the picker's button;

## Tips

To change an editor for every property of an object, you can use the default case
of the match statement.

Additionally, you can do some type checking.

```gdscript:
# Display all boolean properties as check buttons.
func _get_property_info(prop : String):
	match prop:
		_:
			var plist := get_property_list()
			for i in plist:
				if i.name == prop and i.type == TYPE_BOOL:
					return {
						"editor": "check_button"
					}
```
