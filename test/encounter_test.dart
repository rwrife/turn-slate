import 'package:flutter_test/flutter_test.dart';
import 'package:turn_slate/encounter.dart';

void main() {
  group('Participant validation', () {
    test('rejects blank identifier or blank name', () {
      expect(
        () => Participant(id: '  ', name: 'Rogue', initiative: 12),
        throwsArgumentError,
      );
      expect(
        () => Participant(id: 'p1', name: '', initiative: 12),
        throwsArgumentError,
      );
      expect(
        () => Participant(id: 'p1', name: ' \t\n ', initiative: 12),
        throwsArgumentError,
      );
    });

    test('accepts negative initiative', () {
      final p = Participant(id: 'zombie', name: 'Slow Zombie', initiative: -2);
      expect(p.initiative, -2);
      expect(p.name, 'Slow Zombie');
    });
  });

  group('Encounter initialization and ordering', () {
    test(
      'empty encounter has round 0, null active participant, empty history',
      () {
        final encounter = Encounter(participants: const []);
        expect(encounter.participants, isEmpty);
        expect(encounter.round, 0);
        expect(encounter.active, isNull);
        expect(encounter.history, isEmpty);
        expect(encounter.next(), same(encounter));
        expect(encounter.previous(), same(encounter));
      },
    );

    test('rejects duplicate participant IDs', () {
      expect(
        () => Encounter(
          participants: [
            Participant(id: 'same', name: 'Goblin 1', initiative: 10),
            Participant(id: 'same', name: 'Goblin 2', initiative: 5),
          ],
        ),
        throwsArgumentError,
      );
    });

    test('sorts by descending initiative and keeps entry order on ties', () {
      final encounter = Encounter(
        participants: [
          Participant(id: 'b', name: 'Bard', initiative: 15),
          Participant(id: 'w', name: 'Wizard', initiative: 20),
          Participant(id: 'f1', name: 'Fighter 1', initiative: 15),
          Participant(id: 'c', name: 'Cleric', initiative: 8),
          Participant(id: 'f2', name: 'Fighter 2', initiative: 15),
        ],
      );

      final orderIds = encounter.participants.map((p) => p.id).toList();
      expect(orderIds, ['w', 'b', 'f1', 'f2', 'c']);
      expect(encounter.round, 1);
      expect(encounter.active!.id, 'w');
      expect(encounter.history, isEmpty);
    });
  });

  group('Turn progression, rollover, and undo', () {
    test('single participant round advancement and undo boundary', () {
      final p = Participant(id: 'solo', name: 'Solo Hero', initiative: 10);
      var enc = Encounter(participants: [p]);

      expect(enc.round, 1);
      expect(enc.active!.id, 'solo');

      // Undo at start is a no-op
      expect(enc.previous(), same(enc));

      enc = enc.next();
      expect(enc.round, 2);
      expect(enc.active!.id, 'solo');
      expect(enc.history.length, 1);
      expect(enc.history.first.action, TurnAction.advance);
      expect(enc.history.first.fromRound, 1);
      expect(enc.history.first.toRound, 2);
      expect(enc.history.first.fromId, 'solo');
      expect(enc.history.first.toId, 'solo');

      enc = enc.previous();
      expect(enc.round, 1);
      expect(enc.history.length, 2);
      expect(enc.history.last.action, TurnAction.undo);
      expect(enc.history.last.fromRound, 2);
      expect(enc.history.last.toRound, 1);
    });

    test('advances across participants and rolls over round', () {
      final enc0 = Encounter(
        participants: [
          Participant(id: 'a', name: 'Hero A', initiative: 20),
          Participant(id: 'b', name: 'Hero B', initiative: 10),
        ],
      );

      final enc1 = enc0.next();
      expect(enc1.round, 1);
      expect(enc1.active!.id, 'b');

      final enc2 = enc1.next(); // Rollover to round 2
      expect(enc2.round, 2);
      expect(enc2.active!.id, 'a');

      expect(enc2.history.length, 2);
      expect(enc2.history[0].action, TurnAction.advance);
      expect(enc2.history[0].fromId, 'a');
      expect(enc2.history[0].toId, 'b');
      expect(enc2.history[0].fromRound, 1);
      expect(enc2.history[0].toRound, 1);

      expect(enc2.history[1].action, TurnAction.advance);
      expect(enc2.history[1].fromId, 'b');
      expect(enc2.history[1].toId, 'a');
      expect(enc2.history[1].fromRound, 1);
      expect(enc2.history[1].toRound, 2);

      // Undo back across round boundary
      final enc3 = enc2.previous();
      expect(enc3.round, 1);
      expect(enc3.active!.id, 'b');
      expect(enc3.history.length, 3);
      expect(enc3.history.last.action, TurnAction.undo);
      expect(enc3.history.last.fromRound, 2);
      expect(enc3.history.last.toRound, 1);
      expect(enc3.history.last.fromId, 'a');
      expect(enc3.history.last.toId, 'b');
    });

    test('history is unmodifiable and preserved across steps', () {
      final enc = Encounter(
        participants: [Participant(id: 'a', name: 'A', initiative: 2)],
      );
      final next = enc.next();
      expect(
        () => next.history.add(next.history.first),
        throwsUnsupportedError,
      );
      expect(() => next.participants.clear(), throwsUnsupportedError);
    });
  });
}
