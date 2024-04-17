import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../game_internals/card_suit.dart';
import '../game_internals/player.dart';
import '../game_internals/playing_card.dart';
import '../style/palette.dart';

class PlayingCardWidget extends StatelessWidget {
  // A standard playing card is 57.1mm x 88.9mm.
  static const double width = 57.1;

  static const double height = 88.9;

  final PlayingCard card;

  final Player? player;

  final bool isFaceDown;

  const PlayingCardWidget(this.card, {this.player, this.isFaceDown=false, super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final textColor =
        card.suit.color == CardSuitColor.red ? palette.redPen : palette.ink;

    final BoxDecoration cardDecoration = isFaceDown
        ? BoxDecoration(
          color: palette.darkPen,
          border: Border.all(color: palette.ink),
          borderRadius: BorderRadius.circular(5),
        )
        : BoxDecoration(
          color: palette.trueWhite,
          border: Border.all(color: palette.ink),
          borderRadius: BorderRadius.circular(5),
        );
    final String cardText = isFaceDown ? "" : "${card.suit.asCharacter}\n${card.value}";

    final cardWidget = DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!.apply(color: textColor),
      child: Container(
        width: width,
        height: height,
        decoration: cardDecoration,
        child: Center(
          child: Text(cardText,
              textAlign: TextAlign.center),
        ),
      ),
    );

    return cardWidget;

    /*
    /// Cards that aren't in a player's hand are not draggable.
    if (player == null) return cardWidget;

    
    return Draggable(
      feedback: Transform.rotate(
        angle: 0.1,
        child: cardWidget,
      ),
      data: PlayingCardDragData(card, player!),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: cardWidget,
      ),
      onDragStarted: () {
        final audioController = context.read<AudioController>();
        audioController.playSfx(SfxType.huhsh);
      },
      onDragEnd: (details) {
        final audioController = context.read<AudioController>();
        audioController.playSfx(SfxType.wssh);
      },
      child: cardWidget,
    );
    */
  }
}

@immutable
class PlayingCardDragData {
  final PlayingCard card;

  final Player holder;

  const PlayingCardDragData(this.card, this.holder);
}
