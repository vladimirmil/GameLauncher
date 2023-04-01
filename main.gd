extends CanvasLayer


const GameButton : PackedScene = preload("res://game_button.tscn")

@onready var grid : GridContainer = $Control/Panel/ScrollContainer/GridContainer
@onready var menuBar : HBoxContainer = $Control/Panel/HBoxContainer 

var mainDirectory : String = ""
var iconPath : String = ""
var artworkPath : String = ""
var pathsArray : Array = []
var iconArray : Array = []
var artworkArray : Array = []


func _ready():
	for i in range(0, menuBar.get_child_count(), 1):
		menuBar.get_child(i).pressed.connect(onMenuBarButtonPressed.bind(i))
	
	mainDirectory = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/GameLauncher"
	iconPath = mainDirectory + "/Icon"
	artworkPath = mainDirectory + "/Artwork"
	
	pathsArray = [mainDirectory, iconPath, artworkPath]
	
	for i in range(0, pathsArray.size(), 1):
		var dir = DirAccess.open(pathsArray[i])
		if !dir: 
			DirAccess.make_dir_absolute(pathsArray[i])
	
	readDirFiles(iconArray, iconPath)
	readDirFiles(artworkArray, artworkPath)
	addNewGames()


func removeFileType(s : String) -> String:
	var temp : Array = s.split(".")
	temp.remove_at(temp.size()-1)
	# if name contains no dot
	if temp.size() == 1:
		return temp[0]
	else:
		# if name contains a dot or multiple dots
		var tempString : String = ""
		for i in range(0, temp.size(), 1):
			if i != temp.size()-1:
				tempString += temp[i] + "."
			else:
				tempString += temp[i]
		return tempString


func readDirFiles(arr: Array, path : String) -> void:
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if !dir.current_is_dir():
			arr.append(file_name)
		file_name = dir.get_next()


func addNewGames() -> void:
	for i in iconArray:
		var gb = GameButton.instantiate()
		grid.add_child(gb)
		
		gb.connect("launchGame", onLaunchGamePressed)
		gb.setName(removeFileType(i))
		
		for y in range(0, artworkArray.size(), 1):
			if removeFileType(i) == removeFileType(artworkArray[y]):
				gb.setArtwork(artworkPath + "/" + artworkArray[y])


func onMenuBarButtonPressed(id : int) -> void:
	match id:
		0:
			OS.shell_open(artworkPath)
		1:
			OS.shell_open(iconPath)
		2:
			# Refresh games
			for i in grid.get_children():
				i.queue_free()
			
			iconArray.clear()
			artworkArray.clear()
			
			readDirFiles(iconArray, iconPath)
			readDirFiles(artworkArray, artworkPath)
			addNewGames()


func onLaunchGamePressed(game : String) -> void:
	for i in iconArray:
		if game == removeFileType(i):
			OS.shell_open(iconPath + "/" + i)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
