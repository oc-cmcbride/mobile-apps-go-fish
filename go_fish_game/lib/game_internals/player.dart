import 'package:flutter/foundation.dart';

import 'playing_card.dart';

class Player extends ChangeNotifier {
  static const maxCards = 5;

  // Technically this implementation doesn't allow for multiple cards of the 
  // same type, but that's not really a concern for us *shrug*
  final Map<PlayingCard, bool> selectedCards = {
    for (var card in List.generate(maxCards, (int i) => PlayingCard.random()))
      card: false
  };

  List<PlayingCard> get hand => selectedCards.keys.toList();

  void addCard(PlayingCard card) {
    selectedCards.addAll({card: false});
    notifyListeners();
  }

  void removeCard(PlayingCard card) {
    selectedCards.remove(card);
    notifyListeners();
  }
}
