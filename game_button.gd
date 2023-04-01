extends VBoxContainer


signal launchGame 


@onready var gameName : Label = $Label
@onready var gameArtwork : TextureRect = $TextureRect
@onready var btn : Button = $Button


func _ready() -> void:
	btn.pressed.connect(onButtonPressed)


func setName(value : String) -> void:
	gameName.text = value


func setArtwork(value : String) -> void:
	var img = Image.new()
	var err = img.load(value)
	if err == OK:
		gameArtwork.texture = ImageTexture.create_from_image(img)


func onButtonPressed() -> void:
	emit_signal("launchGame", gameName.text)
