import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../style/palette.dart';
import '../game_internals/playing_card.dart';
import '../game_internals/board_state.dart';
import 'playing_card_widget.dart';

class PlayerHandWidget extends StatefulWidget {
  
  final Map<PlayingCard, bool> _handState = { };

  PlayerHandWidget({super.key});

  @override
  State<PlayerHandWidget> createState() => _PlayerHandWidgetState();
}

class _PlayerHandWidgetState extends State<PlayerHandWidget> {
  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final boardState = context.watch<BoardState>();

    // Check if hand state needs to be updated 
    if (widget._handState.isEmpty) {
      widget._handState.addAll({ for (var card in boardState.currentPlayer.hand) card : false });
    }
    else if (!Set.of(widget._handState.keys).containsAll(boardState.currentPlayer.hand)) {
      // Add new cards 
      widget._handState.addAll({ for (var card in boardState.currentPlayer.hand.where((element) => !widget._handState.keys.contains(element))) card : false });
    }
    else if (!Set.of(boardState.currentPlayer.hand).containsAll(widget._handState.keys)) {
      // Remove cards 
      widget._handState.removeWhere((key, value) => !boardState.currentPlayer.hand.contains(key));
    }
    
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: PlayingCardWidget.height),
        child: ListenableBuilder(
          // Make sure we rebuild every time there's an update
          // to the player's hand.
          listenable: boardState.currentPlayer,
          builder: (context, child) {
            // return ToggleButtons(
            //   direction: Axis.horizontal,
            //   onPressed: (int index) {
            //     _selectedCards[index] = !_selectedCards[index];
            //     print(_selectedCards);
            //   },
            //   isSelected: _selectedCards,
            //   fillColor: Colors.red,
            //   selectedBorderColor: Colors.green,
            //   selectedColor: Colors.teal,
            //   constraints: BoxConstraints(minHeight: 80.0, minWidth: 80.0),
            //   children: [...boardState.currentPlayer.hand.map((card) => PlayingCardWidget(card, player: boardState.currentPlayer))],
            // );
            return Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                ...boardState.currentPlayer.hand.map(
                  (card) => ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (widget._handState[card] != null) {
                          widget._handState[card] = !widget._handState[card]!;
                        }
                        print(widget._handState);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (widget._handState[card] ?? false) ? Colors.green : Colors.white,
                      ),
                    child: PlayingCardWidget(
                      card,
                      player: boardState.currentPlayer,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
