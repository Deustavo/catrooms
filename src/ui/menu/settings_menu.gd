extends Control
## Tela de configurações: ajusta a sensibilidade da câmera do jogador.

@onready var _sensitivity_label: Label = %SensitivityLabel
@onready var _sensitivity_slider: HSlider = %SensitivitySlider
@onready var _back_button: Button = %BackButton


func _ready() -> void:
	_sensitivity_slider.value = GameManager.mouse_sensitivity
	_update_label(GameManager.mouse_sensitivity)
	_sensitivity_slider.value_changed.connect(_on_sensitivity_changed)
	_back_button.pressed.connect(_on_back_pressed)


func _on_sensitivity_changed(value: float) -> void:
	GameManager.set_mouse_sensitivity(value)
	_update_label(value)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://src/ui/menu/main_menu.tscn")


func _update_label(value: float) -> void:
	_sensitivity_label.text = "Sensibilidade da câmera: %.4f" % value
