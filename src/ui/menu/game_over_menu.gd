extends CanvasLayer
## Tela de Game Over: exibida quando um inimigo encosta no jogador.
## Oferece recomeçar do nível 1 ou voltar ao menu inicial.
## process_mode ALWAYS para continuar recebendo input com a árvore pausada.

@onready var _restart_button: Button = %RestartButton
@onready var _main_menu_button: Button = %MainMenuButton


func _ready() -> void:
	hide()
	Events.game_over.connect(_on_game_over)
	_restart_button.pressed.connect(_on_restart_pressed)
	_main_menu_button.pressed.connect(_on_main_menu_pressed)


func _on_game_over() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()


func _on_restart_pressed() -> void:
	hide()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	GameManager.start_game()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/ui/menu/main_menu.tscn")
