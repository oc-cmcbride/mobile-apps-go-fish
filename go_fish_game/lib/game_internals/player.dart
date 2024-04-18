import 'package:flutter/foundation.dart';

import 'playing_card.dart';

class Player extends ChangeNotifier {
  final Map<PlayingCard, bool> selectedCards = { };

  late final int number;

  Player(this.number);

  List<PlayingCard> get hand => selectedCards.keys.toList();

  void addCard(PlayingCard card) {
    selectedCards.addAll({card: false});
    notifyListeners();
  }

  void addCards(Iterable<PlayingCard> cards) {
    cards.forEach(addCard);
  }

  void removeCard(PlayingCard card) {
    selectedCards.remove(card);
    notifyListeners();
  }

  void removeCards(Iterable<PlayingCard> cards) {
    cards.forEach(removeCard);
  }
}
