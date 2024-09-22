extends Node

 
const SAVEFILE:String = "user://savefile.save"
 
var highest_record:int = 0
 
func _ready():
	load_score()
 
func save_score():
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE_READ)
	file.store_32(highest_record)
	file = null
 
func load_score():
	var file = FileAccess.open(SAVEFILE, FileAccess.READ)
	if FileAccess.file_exists(SAVEFILE):
		highest_record = file.get_32()
 
