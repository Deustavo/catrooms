extends CanvasLayer
## Tela de vitória: exibida quando o jogador termina o último nível.
## process_mode ALWAYS para continuar recebendo input com a árvore pausada.

@onready var _main_menu_button: Button = %MainMenuButton


func _ready() -> void:
	hide()
	Events.game_completed.connect(_on_game_completed)
	_main_menu_button.pressed.connect(_on_main_menu_pressed)


func _on_game_completed() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/ui/menu/main_menu.tscn")
