@tool
extends EditorPlugin

var plugin = preload("res://addons/extra_export_hints/custom_editors.gd")

func _enter_tree():
	plugin = plugin.new()
	plugin._EditorInterface = get_editor_interface()
	add_inspector_plugin(plugin)

func _exit_tree():
	remove_inspector_plugin(plugin)
