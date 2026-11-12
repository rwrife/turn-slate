/// Pure encounter turn order. No ruleset effects or implicit time-based ticks.
class Participant {
  Participant({
    required this.id,
    required this.name,
    required this.initiative,
  }) {
    if (id.trim().isEmpty || name.trim().isEmpty) {
      throw ArgumentError('Participant id and name must not be blank');
    }
  }

  final String id;
  final String name;
  final int initiative;
}

enum TurnAction { advance, undo }

class TurnEvent {
  const TurnEvent({
    required this.action,
    required this.fromId,
    required this.toId,
    required this.fromRound,
    required this.toRound,
  });

  final TurnAction action;
  final String fromId;
  final String toId;
  final int fromRound;
  final int toRound;
}

class Encounter {
  factory Encounter({required List<Participant> participants}) {
    final ids = <String>{};
    for (final participant in participants) {
      if (!ids.add(participant.id)) {
        throw ArgumentError.value(
          participant.id,
          'id',
          'Duplicate participant',
        );
      }
    }
    // Stable sort by input position: ties keep GM-defined order.
    final order = List<int>.generate(participants.length, (index) => index)
      ..sort((a, b) {
        final byInitiative = participants[b].initiative.compareTo(
          participants[a].initiative,
        );
        return byInitiative != 0 ? byInitiative : a.compareTo(b);
      });
    return Encounter._(
      List<Participant>.unmodifiable([
        for (final index in order) participants[index],
      ]),
      0,
      const [],
    );
  }

  const Encounter._(this.participants, this._turns, this.history);

  final List<Participant> participants;
  final int _turns;

  /// Chronological record of successful moves, including undos.
  final List<TurnEvent> history;

  Participant? get active =>
      participants.isEmpty ? null : participants[_turns % participants.length];

  int get round => participants.isEmpty ? 0 : _turns ~/ participants.length + 1;

  Encounter next() {
    if (participants.isEmpty) return this;
    if (_turns == 0x7fffffffffffffff) {
      throw StateError('Encounter turn limit reached');
    }
    return _move(_turns + 1, TurnAction.advance);
  }

  Encounter previous() {
    if (participants.isEmpty || _turns == 0) return this;
    return _move(_turns - 1, TurnAction.undo);
  }

  Encounter _move(int turns, TurnAction action) {
    final count = participants.length;
    return Encounter._(
      participants,
      turns,
      List<TurnEvent>.unmodifiable([
        ...history,
        TurnEvent(
          action: action,
          fromId: participants[_turns % count].id,
          toId: participants[turns % count].id,
          fromRound: round,
          toRound: turns ~/ count + 1,
        ),
      ]),
    );
  }
}
