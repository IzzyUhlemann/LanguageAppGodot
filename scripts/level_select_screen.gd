extends Control

const LEVEL_BTN = preload("res://gui/lvl_btn.tscn")
@export_dir var dir_path

@onready var grid = $MarginContainer/VBoxContainer/GridContainer
var selected_level:int = 0
var level_array:Array

func _ready() -> void:
	get_levels(dir_path)

func get_levels(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			print(file_name)
			create_level_btn('%s/%s' % [dir.get_current_dir(), file_name], file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")
	
	level_array = grid.get_children()
	level_array[selected_level]._on_lvl_btn_mouse_entered()
		
func create_level_btn(lvl_path, lvl_name):
	var btn = LEVEL_BTN.instantiate()
	btn.text = lvl_name.trim_suffix('.tscn').replace("_", " ")
	btn.level_path = lvl_path
	grid.add_child(btn)


func select_next_level() -> void:
	if (selected_level >= 0 && selected_level < level_array.size()-1):
		level_array[selected_level]._on_lvl_btn_mouse_exited()
		selected_level += 1
		level_array[selected_level]._on_lvl_btn_mouse_entered()


func select_prev_level() -> void:
	if (selected_level > 0 && selected_level < level_array.size()):
		level_array[selected_level]._on_lvl_btn_mouse_exited()
		selected_level -= 1
		level_array[selected_level]._on_lvl_btn_mouse_entered()


func load_new_level() -> void:
	level_array[selected_level]._on_lvl_btn_pressed()
