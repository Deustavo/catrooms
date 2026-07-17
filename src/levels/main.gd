extends Node3D
## Orquestra o nível: reage a Events.level_started reconstruindo o labirinto
## e reposicionando o jogador. Não contém lógica de jogo nem de geração.

@onready var _maze_builder: MazeBuilder = $MazeBuilder
@onready var _player: Player = $Player


func _ready() -> void:
	Events.level_started.connect(_on_level_started)
	GameManager.start_game()


func _on_level_started(level: int) -> void:
	# Deferred: o sinal pode chegar durante um callback de física (Area3D da
	# saída), e reconstruir o labirinto libera corpos físicos.
	_rebuild_level.call_deferred(level)


func _rebuild_level(level: int) -> void:
	var size := GameManager.maze_size_for_level(level)
	var maze := MazeData.new(size.x, size.y)
	maze.generate(GameManager.rng)
	_maze_builder.build(maze)
	_player.teleport_to(_maze_builder.get_spawn_position())
