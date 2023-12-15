extends Resource
class_name Universal

var datapath = "res://assets/gamedata.cdb"

func load_json(filePath: String):
    if FileAccess.file_exists(filePath):
        print("data exists!")
