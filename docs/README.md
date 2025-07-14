# Histrio - A Balatro Clone TLA+ Specification

**Histrio** (Latin for buffoon/actor/jester) is a formal specification of the popular poker-inspired roguelike deck-building game Balatro, written in TLA+. This project provides a mathematical model for understanding and verifying the game's complex mechanics.

## About Balatro

Balatro is a singleplayer roguelike deck-building game that combines poker hand evaluation with strategic card enhancement mechanics. Players progress through 8 antes, each containing 3 blinds of increasing difficulty, using poker hands enhanced by Jokers, Planet cards, Tarot cards, and other modifiers to achieve target scores.

### Core Game Mechanics

- **Antes & Blinds**: Progress through 8 antes, each with Small Blind, Big Blind, and Boss Blind
- **Poker Hands**: Traditional poker hands plus enhanced variants (Five of a Kind, Flush House, etc.)
- **Scoring**: Chip-based scoring system with multiplicative bonuses
- **Jokers**: Strategic modifier cards that create powerful synergies (up to 5 slots)
- **Enhancements**: Planet cards (upgrade hands), Tarot cards (modify deck), Spectral cards (high-risk/high-reward)
- **Economy**: Shop system with money management and voucher upgrades

## Project Structure

```
histrio/
├── specs/                      # TLA+ Specifications
│   ├── Histrio.tla            # Main specification module
│   ├── GameState.tla          # Core game state definitions
│   ├── ChipCalculation.tla    # Scoring logic and poker hand evaluation
│   ├── BlindSystem.tla        # Blind mechanics and progression
│   ├── Economy.tla            # Money system and shop interactions
│   ├── Enhancements.tla       # Jokers, Planet cards, Tarot cards, etc.
│   └── DeckManagement.tla     # Card operations and deck modifications
├── models/                     # Model Checker Configurations
│   ├── Histrio.cfg           # Main TLC model checker configuration
│   ├── SmallModel.cfg        # Reduced state space for faster testing
│   └── Properties.tla        # Invariants and properties to verify
├── tests/                      # Specification Tests
│   ├── ChipTests.tla         # Unit tests for scoring calculations
│   └── GameLoopTests.tla     # Integration tests for game flow
└── docs/                       # Documentation
    ├── README.md             # This file
    └── specification_notes.md # Technical specification notes
```

## Key Properties to Verify

This TLA+ specification aims to verify critical game properties:

1. **Score Consistency**: Poker hand scoring is deterministic and correct
2. **Economy Balance**: Money flow maintains game progression without breaking
3. **Blind Progression**: Difficulty scaling follows intended curves
4. **Joker Interactions**: Complex modifier interactions behave correctly
5. **Game Termination**: All game runs eventually terminate (win/lose)
6. **State Integrity**: Game state transitions are valid and consistent

## Getting Started

### Prerequisites

- [TLA+](https://lamport.azurewebsites.net/tla/tla.html) specification language
- [TLC](https://lamport.azurewebsites.net/tla/tools.html) model checker

### Running the Model

1. Open the main specification: `specs/Histrio.tla`
2. Configure the model checker with `models/Histrio.cfg`
3. Run TLC to verify properties and explore the state space

### Testing

Run unit tests with the configurations in the `tests/` directory to verify specific components in isolation.

## Contributing

When modifying specifications:

1. Maintain mathematical rigor in all definitions
2. Update corresponding test files for any changes
3. Verify all properties still hold after modifications
4. Document any new constants or assumptions

## Key Balatro Mechanics Modeled

- **Chip Calculation**: Base chips + card values, multiplied by mult values
- **Joker Order**: Additive mult jokers processed before multiplicative ones
- **Boss Blind Effects**: Special mechanics that modify gameplay rules
- **Planet Card Upgrades**: Permanent improvements to poker hand levels
- **Deck Modifications**: Tarot cards that change card properties permanently
- **Economic Flow**: Money earned from blinds, spent in shops, managed across runs

## Goals

This specification serves multiple purposes:

- **Educational**: Understanding Balatro's intricate rule interactions
- **Verification**: Ensuring game mechanics work as intended
- **Balance Analysis**: Mathematical analysis of game difficulty and progression
- **Implementation Guide**: Reference for creating faithful Balatro clones

## License

This is a specification of game mechanics for educational and analytical purposes.