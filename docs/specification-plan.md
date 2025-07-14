# Specification plan

## First specification: ChipCalculation.tla

### Scope

**Include:**
- Basic poker hands (High Card → Straight Flush)
- Chip calculation: `(base_chips + card_values) × multiplier`
- Card values: Face cards (J=11, Q=12, K=13, A=14), number cards (2-10)
- Level progression: Each hand type has levels that increase base chips/mult

**Defer:**
- Jokers/modifiers (complex, build on basic scoring)
- Deck modifications (Tarot cards)
- Enhanced card types (Steel, Glass, etc.)
- Wild cards and suits

### Properties to verify

1. **Monotonicity**: Higher poker hands score more than lower ones (at same level)
2. **Determinism**: Same input always produces same score
3. **Level consistency**: Higher levels always increase score
4. **Score validity**: All scores are natural numbers ≥ 0

### Rationale

Core scoring is the mathematical foundation of Balatro - everything else builds on it. Starting here gives us a solid base to verify before adding complexity.