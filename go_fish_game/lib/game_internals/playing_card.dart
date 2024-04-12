import 'dart:math';

import 'package:flutter/foundation.dart';

import 'card_suit.dart';
import 'card_value.dart';

@immutable
class PlayingCard {
  static final _random = Random();

  static final List<PlayingCard> _randomCards = [];

  final CardSuit suit;

  final CardValue value;

  const PlayingCard(this.suit, this.value);

  factory PlayingCard.fromJson(Map<String, dynamic> json) {
    return PlayingCard(
      CardSuit.values
          .singleWhere((e) => e.internalRepresentation == json['suit']),
      CardValue.values
          .singleWhere((e) => e.internalRepresentation == json['value']),
    );
  }

  factory PlayingCard.random([Random? random]) {
    random ??= _random;
    if (_randomCards.isEmpty) {
      // List is empty; generate new set of random cards 
      _randomCards.addAll(List.generate(52, (int index) => PlayingCard(CardSuit.values[index % 4], CardValue.values[index % 13]))..shuffle(random));
    }
    return _randomCards.removeAt(0);
  }

  @override
  int get hashCode => Object.hash(suit, value);

  @override
  bool operator ==(Object other) {
    return other is PlayingCard && other.suit == suit && other.value == value;
  }

  Map<String, dynamic> toJson() => {
        'suit': suit.internalRepresentation,
        'value': value.internalRepresentation,
      };

  @override
  String toString() {
    return '$suit$value';
  }
}
