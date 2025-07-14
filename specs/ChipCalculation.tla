---- MODULE ChipCalculation ----
EXTENDS Naturals, Sequences, FiniteSets, TLC

CONSTANTS
    SUITS,      \* {"Hearts", "Diamonds", "Clubs", "Spades"}
    RANKS,      \* {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14} where 11=J, 12=Q, 13=K, 14=A
    MAX_LEVEL   \* Maximum hand level to check (e.g., 10 for testing, 40 for full verification)

\* Card representation
Card == [suit: SUITS, rank: RANKS]

\* Hand types in ascending order of strength
HandTypes == {
    "HighCard", "Pair", "TwoPair", "ThreeOfAKind", "Straight",
    "Flush", "FullHouse", "FourOfAKind", "StraightFlush"
}

\* Card chip values (rank is the chip value)
CardChips(card) == card.rank

\* Count occurrences of each rank in a hand
RankCounts(cards) ==
    [rank \in RANKS |-> Cardinality({c \in cards : c.rank = rank})]

\* Check if all cards have the same suit
IsFlush(cards) == 
    Cardinality({c.suit : c \in cards}) = 1

\* Check if ranks form a consecutive sequence
IsStraight(cards) ==
    LET ranks == {c.rank : c \in cards}
    IN /\ Cardinality(ranks) = 5
       /\ \E start \in ranks : 
            \A i \in 0..4 : (start + i) \in ranks

\* Determine poker hand type for 5 cards
HandType(cards) ==
    LET counts == RankCounts(cards)
        maxCount == CHOOSE n \in {counts[r] : r \in RANKS} : \A m \in {counts[r] : r \in RANKS} : n >= m
        countValues == {counts[r] : r \in RANKS}
        isFlush == IsFlush(cards)
        isStraight == IsStraight(cards)
    IN CASE isFlush /\ isStraight -> "StraightFlush"
         [] maxCount = 4 -> "FourOfAKind"
         [] maxCount = 3 /\ 2 \in countValues -> "FullHouse"
         [] isFlush -> "Flush"
         [] isStraight -> "Straight"
         [] maxCount = 3 -> "ThreeOfAKind"
         [] Cardinality({r \in RANKS : counts[r] = 2}) = 2 -> "TwoPair"
         [] maxCount = 2 -> "Pair"
         [] OTHER -> "HighCard"

\* Base chips for each hand type at level 1
BaseChips(handType) ==
    CASE handType = "HighCard" -> 5
      [] handType = "Pair" -> 10
      [] handType = "TwoPair" -> 20
      [] handType = "ThreeOfAKind" -> 30
      [] handType = "Straight" -> 30
      [] handType = "Flush" -> 35
      [] handType = "FullHouse" -> 40
      [] handType = "FourOfAKind" -> 60
      [] handType = "StraightFlush" -> 100

\* Base multiplier for each hand type at level 1
BaseMult(handType) ==
    CASE handType = "HighCard" -> 1
      [] handType = "Pair" -> 2
      [] handType = "TwoPair" -> 2
      [] handType = "ThreeOfAKind" -> 3
      [] handType = "Straight" -> 4
      [] handType = "Flush" -> 4
      [] handType = "FullHouse" -> 4
      [] handType = "FourOfAKind" -> 7
      [] handType = "StraightFlush" -> 8

\* Calculate total chip value of cards in hand
RECURSIVE SumCardChips(_)
SumCardChips(cardSet) ==
    IF cardSet = {} 
    THEN 0
    ELSE LET c == CHOOSE card \in cardSet : TRUE
         IN CardChips(c) + SumCardChips(cardSet \ {c})

TotalCardChips(cards) == SumCardChips(cards)

\* Calculate score for a hand at a given level
CalculateScore(cards, level) ==
    LET handType == HandType(cards)
        baseChips == BaseChips(handType) * level
        cardChips == TotalCardChips(cards)
        totalChips == baseChips + cardChips
        multiplier == BaseMult(handType) * level
    IN totalChips * multiplier

\* Properties to verify

\* Same hand always produces same score at same level
Determinism ==
    \A cards1, cards2 \in SUBSET Card, level \in 1..MAX_LEVEL :
        /\ Cardinality(cards1) = 5
        /\ Cardinality(cards2) = 5  
        /\ cards1 = cards2
        => CalculateScore(cards1, level) = CalculateScore(cards2, level)

\* Higher levels always produce higher scores for same hand
LevelConsistency ==
    \A cards \in SUBSET Card, level1, level2 \in 1..MAX_LEVEL :
        /\ Cardinality(cards) = 5
        /\ level1 < level2
        => CalculateScore(cards, level1) < CalculateScore(cards, level2)

\* All scores are natural numbers
ScoreValidity ==
    \A cards \in SUBSET Card, level \in 1..MAX_LEVEL :
        Cardinality(cards) = 5 => CalculateScore(cards, level) \in Nat

\* REMOVED: Monotonicity property 
\* Counter-example: High card with face cards can outscore low pairs
\* This is correct Balatro behavior - card values matter significantly

\* Dummy temporal behavior for TLC (this is a pure mathematical module)
VARIABLE dummy

Init == dummy = 0
Next == dummy' = dummy
Spec == Init /\ [][Next]_dummy

====