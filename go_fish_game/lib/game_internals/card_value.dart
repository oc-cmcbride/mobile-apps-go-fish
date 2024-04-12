enum CardValue {
  ace(1),
  two(2),
  three(3),
  four(4),
  five(5),
  six(6),
  seven(7),
  eight(8),
  nine(9),
  ten(10),
  jack(11),
  queen(12),
  king(13);

  final int internalRepresentation;

  const CardValue(this.internalRepresentation);

  String get asCharacter {
    switch (this) {
      case CardValue.ace:
        return 'A';
      case CardValue.jack:
        return 'J';
      case CardValue.queen:
        return 'Q';
      case CardValue.king:
        return 'K';
      default:
        return "$internalRepresentation";
    }
  }

  @override
  String toString() => asCharacter;
}
