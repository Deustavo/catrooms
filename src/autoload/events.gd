extends Node
## Signal bus global: sinais de interesse cruzado entre sistemas.
## Mantenha enxuto — sinais locais são preferíveis quando os nós se conhecem.

## Emitido quando um novo nível deve começar (o labirinto deve ser reconstruído).
signal level_started(level: int)

## Emitido quando o jogador alcança a saída do labirinto.
signal exit_reached
