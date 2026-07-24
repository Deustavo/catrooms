extends Node3D
## Orquestra o nível: reage a Events.level_started reconstruindo a sala
## e reposicionando o jogador. Não contém lógica de jogo nem de geração.

@onready var _room_builder: RoomBuilder = $RoomBuilder
@onready var _player: Player = $Player
@onready var _enemy_spawner: EnemySpawner = $EnemySpawner


func _ready() -> void:
	Events.level_started.connect(_on_level_started)
	GameManager.start_game()


func _on_level_started(level: int) -> void:
	# Deferred: o sinal pode chegar durante um callback de física (Area3D da
	# saída), e reconstruir a sala libera corpos físicos.
	_rebuild_level.call_deferred(level)


func _rebuild_level(level: int) -> void:
	var size := GameManager.room_size_for_level(level)
	_room_builder.build(size)
	_player.teleport_to(_room_builder.get_spawn_position())
	_enemy_spawner.spawn_for_level(level, size, _room_builder, _player)
