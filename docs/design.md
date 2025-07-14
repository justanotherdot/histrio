# Design

This document outlines our approach to specifying Balatro mechanics in TLA+.

## Modeling philosophy

- **Start simple**: Begin with core mathematical foundations (scoring) before adding complexity
- **Incremental verification**: Each module should be verifiable independently
- **Defer complexity**: Jokers, modifiers, and card enhancements come after basic mechanics work
- **Mathematical purity**: Let TLA+ handle infinite state spaces; implementation concerns come later

## Module structure

- **ChipCalculation**: Core poker hand evaluation and scoring
- **GameState**: Overall game state and transitions
- **BlindSystem**: Ante/blind progression and targets
- **Economy**: Money flow and shop mechanics
- **Enhancements**: Jokers, Planet cards, Tarot cards
- **DeckManagement**: Card operations and deck modifications

## Verification strategy

Each module defines its own invariants and properties. Integration testing happens through composed specifications that import multiple modules.
