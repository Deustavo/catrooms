extends CanvasLayer
## Menu de pausa: ESC alterna a pausa; oferece continuar ou voltar ao menu inicial.
## process_mode ALWAYS para continuar recebendo input com a árvore pausada.

@onready var _resume_button: Button = %ResumeButton
@onready var _main_menu_button: Button = %MainMenuButton


func _ready() -> void:
	hide()
	_resume_button.pressed.connect(_resume)
	_main_menu_button.pressed.connect(_on_main_menu_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			_resume()
		else:
			_pause()


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
