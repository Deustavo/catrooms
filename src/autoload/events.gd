extends Node
## Signal bus global: sinais de interesse cruzado entre sistemas.
## Mantenha enxuto — sinais locais são preferíveis quando os nós se conhecem.

## Emitido quando um novo nível deve começar (a sala deve ser reconstruída).
signal level_started(level: int)

## Emitido quando o jogador alcança a saída da sala.
signal exit_reached

## Emitido quando o jogador termina o último nível.
signal game_completed

## Emitido quando um inimigo encosta no jogador.
signal player_caught

## Emitido quando o jogo termina por derrota (jogador foi pego).
signal game_over

## Emitido quando a sensibilidade da câmera é alterada nas configurações.
signal mouse_sensitivity_changed(value: float)
