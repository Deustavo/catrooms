extends CanvasLayer
## Menu de pausa: ESC alterna a pausa; oferece continuar ou voltar ao menu inicial.
## process_mode ALWAYS para continuar recebendo input com a árvore pausada.

@onready var _resume_button: Button = %ResumeButton
@onready var _main_menu_button: Button = %MainMenuButton

var _game_over := false


func _ready() -> void:
	hide()
	_resume_button.pressed.connect(_resume)
	_main_menu_button.pressed.connect(_on_main_menu_pressed)
	Events.game_over.connect(_on_game_over)
	Events.level_started.connect(_on_level_started)


func _unhandled_input(event: InputEvent) -> void:
	if _game_over:
		return
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			_resume()
		else:
			_pause()


func _on_game_over() -> void:
	_game_over = true
	hide()


func _on_level_started(level: int) -> void:
	if level == 1:
		_game_over = false


func _pause() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()


func _resume() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/ui/menu/main_menu.tscn")
