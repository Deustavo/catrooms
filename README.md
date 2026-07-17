# Catrooms

Jogo 3D em primeira pessoa com gameplay de labirinto, feito em **Godot 4.3+**.

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

Objetivo: encontre o pilar verde brilhante (a saída). Cada nível gera um
labirinto novo e maior.

## Arquitetura

```
src/
  autoload/        Singletons globais (registrados em project.godot)
    events.gd        Signal bus — sinais de interesse cruzado entre sistemas
    game_manager.gd  Progressão de níveis e RNG compartilhado
  player/          Controlador FPS (cena + script autocontidos)
  maze/
    maze_data.gd     Geração do labirinto — lógica PURA, sem árvore de cena
    maze_builder.gd  Converte MazeData em geometria 3D (apresentação)
  levels/
    main.tscn/.gd    Cena principal — só orquestra, não tem lógica de jogo
  ui/
    hud.gd           HUD — escuta apenas o signal bus
```

Princípios aplicados:

- **Dados separados da apresentação**: `MazeData` gera e armazena o labirinto
  sem tocar em nós 3D; `MazeBuilder` só desenha. Dá para testar a geração de
  forma isolada e trocar a representação visual sem tocar no algoritmo.
- **Signal bus para desacoplamento**: player, labirinto, HUD e GameManager não
  se referenciam diretamente — comunicam-se por `Events`. "Signal up, call down".
- **RNG injetado**: `MazeData.generate()` recebe o `RandomNumberGenerator`,
  permitindo seeds fixas para níveis reproduzíveis e testes determinísticos.
- **Cenas autocontidas**: `player.tscn` funciona solto em qualquer cena.
- **Recursos compartilhados**: todas as paredes reutilizam as mesmas malhas e
  shapes de colisão.

## Próximos passos sugeridos

- Minimapa (renderizar `MazeData` num `TextureRect`)
- Inimigos/objetivos dentro do labirinto
- Substituir caixas por `GridMap` + MeshLibrary com texturas
- Áudio ambiente e passos
