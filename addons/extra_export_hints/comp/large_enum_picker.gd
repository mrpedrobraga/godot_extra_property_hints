@tool
extends HBoxContainer

var items : Array
var item_pointers : Array
var target_object : Object
var target_property : StringName

@onready var button = %Button
@onready var item_list : ItemList = %ItemList
@onready var window = %Window
@onready var search_bar = %search_bar

func _ready():
	update_button_text()

func update_button_text():
	var value = target_object.get(target_property)
	if value is String:
		button.text = "\"%s\"" % value
	else:
		button.text = str(value)

func _on_button_pressed():
	item_list_populate()
	
	window.title = "Select section to replace '%s'." % target_object.get(target_property)
	window.popup_centered(Vector2i(300, 400))
	search_bar.grab_focus()

func _on_window_close_requested():
	window.visible = false

func _on_window_confirmed():
	if item_list.is_anything_selected():
		_on_item_list_item_activated(item_list.get_selected_items()[0])

func _on_item_list_item_activated(index):
	var prop = get_parent().get_edited_property()
	if get_parent().get_edited_object().get(prop) == null:
		get_parent().get_edited_object().set(prop, item_pointers[index])
	else:
		get_parent().get_edited_object().set(prop, item_pointers[index])
	get_parent().emit_changed(
		get_parent().get_edited_property(),
		item_pointers[index],
		&"",
		true
	)
	window.hide()
	update_button_text()

func _on_search_bar_text_submitted(new_text):
	_on_item_list_item_activated(0)

func item_list_populate():
	item_list.clear()
	item_pointers = items.duplicate()
	
	for item in items:
		var index = item_list.add_item(str(item))
		if is_same(target_object.get(target_property), item):
			item_list.select(index)
	item_list.ensure_current_is_visible()

func item_list_populate_matching(query : String):
	item_list.clear()
	item_pointers = items.duplicate()
	
	item_pointers.sort_custom(
		func (a, b):
			return _word_distance(str(a), query) < _word_distance(str(b), query)
	)
	for item in item_pointers:
		item_list.add_item(str(item))
	item_list.select(0)
	item_list.ensure_current_is_visible()

func _on_search_bar_text_changed(new_text):
	if new_text:
		item_list_populate_matching(new_text)
	else:
		item_list_populate()

func _word_distance(str1:String, str2:String)->int:
	str1 = str1.to_lower()
	str2 = str2.to_lower()
	var m:int = len(str1)
	var n:int = len(str2)
	var d: Array = []
	for i in range(1, m+1):
		d.append([i])
	d.insert(0, range(0, n+1))
	for j in range(1, n+1):
		for i in range(1, m+1):
			var substitution_cost: int
			if str1[i-1] == str2[j-1]:
				substitution_cost = 0
			else:
				substitution_cost = 1
			d[i].insert(j, min(min(
				d[i-1][j]+1,
				d[i][j-1]+1),
				d[i-1][j-1]+substitution_cost))
	return d[-1][-1]

