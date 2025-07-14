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

1. ~~**Monotonicity**: Higher poker hands score more than lower ones (at same level)~~ 
   **REMOVED**: Counter-example found - high card with face cards (J,Q,K,A,10) can outscore low pair (2,2,3,4,5) due to card chip contributions. This is correct Balatro behavior.
2. **Determinism**: Same input always produces same score
3. **Level consistency**: Higher levels always increase score
4. **Score validity**: All scores are natural numbers ≥ 0

### Key finding

**Hand type alone does not determine score in Balatro.** Card values significantly impact final score:
- High Card (J,Q,K,A,10): (5 + 48) × 1 = 53 points
- Pair (2,2,3,4,5): (10 + 16) × 2 = 52 points

Hand rankings apply when card values are approximately equal, but individual card quality can override hand type hierarchy.

### Future monotonicity properties to explore

1. **Card Value Monotonicity**: Replacing any card with a higher-value card of same suit (without changing hand type) should increase score
   ```tla
   CardValueMonotonicity ==
       \A cards \in SUBSET Card, level \in 1..MAX_LEVEL :
           /\ Cardinality(cards) = 5
           => \A c1, c2 \in Card :
               /\ c1 \in cards
               /\ c2 \notin cards  
               /\ c1.suit = c2.suit
               /\ c1.rank < c2.rank
               /\ HandType(cards) = HandType((cards \ {c1}) \union {c2})
               => CalculateScore(cards, level) < CalculateScore((cards \ {c1}) \union {c2}, level)
   ```

2. **Same Value Monotonicity**: Higher-ranked hands should score more when total card values are equal
   ```tla
   SameValueMonotonicity ==
       \A cards1, cards2 \in SUBSET Card, level \in 1..MAX_LEVEL :
           /\ TotalCardChips(cards1) = TotalCardChips(cards2)
           /\ HandRanking[HandType(cards1)] < HandRanking[HandType(cards2)]
           => CalculateScore(cards1, level) < CalculateScore(cards2, level)
   ```

3. **Multiplier Dominance**: At sufficiently high levels, multiplier differences should dominate card value differences
   ```tla
   MultiplierDominance ==
       \A cards1, cards2 \in SUBSET Card :
           /\ HandRanking[HandType(cards1)] < HandRanking[HandType(cards2)]
           => \E threshold \in 1..MAX_LEVEL :
               \A level \in threshold..MAX_LEVEL :
                   CalculateScore(cards1, level) < CalculateScore(cards2, level)
   ```

**Note**: These properties explore different aspects of Balatro's scoring system and may reveal additional insights about the game's mechanics.
### Rationale

Core scoring is the mathematical foundation of Balatro - everything else builds on it. Starting here gives us a solid base to verify before adding complexity.