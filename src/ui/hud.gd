extends CanvasLayer
## HUD mínimo: mostra o nível atual. Só escuta o signal bus — não conhece
## nenhum outro nó do jogo.

@onready var _level_label: Label = %LevelLabel


func _ready() -> void:
	Events.level_started.connect(_on_level_started)


func _on_level_started(level: int) -> void:
	_level_label.text = "Nível %d — encontre a saída" % level
