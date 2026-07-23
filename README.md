# Catrooms

Jogo 3D em primeira pessoa feito em **Godot 4.3+**. Cada nível é uma sala
quadrada aberta — sem paredes internas, só as 4 paredes externas.

## Como rodar

1. Instale o [Godot 4.3 ou superior](https://godotengine.org/download) (versão padrão, sem .NET).
2. Abra o Godot → **Import** → selecione o arquivo `project.godot` desta pasta.
3. Pressione **F5** (ou o botão ▶) para rodar.

Ou pela linha de comando: `godot --path .`

## Controles

| Ação | Tecla |
|---|---|
| Mover | W A S D |
| Correr | Shift |
| Pular | Espaço |
| Olhar | Mouse |
| Soltar/capturar mouse | Esc / clique |

Objetivo: encontre o pilar verde brilhante (a saída), no canto oposto ao
ponto de partida. Cada nível gera uma sala nova e maior, até o nível 10 —
ao completá-lo o jogo volta ao menu inicial.

## Arquitetura

```
src/
  autoload/        Singletons globais (registrados em project.godot)
    events.gd        Signal bus — sinais de interesse cruzado entre sistemas
    game_manager.gd  Progressão de níveis e RNG compartilhado
  player/          Controlador FPS (cena + script autocontidos)
  room/
    room_builder.gd  Constrói a sala quadrada em geometria 3D (chão, teto,
                      4 paredes externas, saída) — sem paredes internas
  levels/
    main.tscn/.gd    Cena principal — só orquestra, não tem lógica de jogo
  ui/
    hud.gd           HUD — escuta apenas o signal bus
```

Princípios aplicados:

- **Sala aberta, sem geração de labirinto**: `RoomBuilder` recebe apenas o
  tamanho do lado e desenha uma sala quadrada — chão, teto e as 4 paredes
  externas. Não há paredes internas nem algoritmo de geração.
- **Signal bus para desacoplamento**: player, sala, HUD e GameManager não se
  referenciam diretamente — comunicam-se por `Events`. "Signal up, call down".
- **Cenas autocontidas**: `player.tscn` funciona solto em qualquer cena.
- **Recursos compartilhados**: todas as paredes reutilizam as mesmas malhas e
  shapes de colisão.

## Próximos passos sugeridos

- Inimigos/objetivos dentro da sala
- Substituir caixas por `GridMap` + MeshLibrary com texturas
- Áudio ambiente e passos
