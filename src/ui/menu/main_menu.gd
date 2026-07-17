extends Control
## Menu inicial: título do jogo e navegação para jogar ou configurar.

@onready var _play_button: Button = %PlayButton
@onready var _settings_button: Button = %SettingsButton


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_play_button.pressed.connect(_on_play_pressed)
	_settings_button.pressed.connect(_on_settings_pressed)


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://src/levels/main.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://src/ui/menu/settings_menu.tscn")
