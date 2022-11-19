import 'dart:convert';

/// Dataclass with game statistics
class Stats {
  Stats({
    this.highscore = 0,
    this.touchlessHighscore = 0,
    this.asteroidsDestroyed = 0,
    this.asteroidsMissed = 0,
  });
  int highscore = 0;
  int touchlessHighscore = 0;
  int asteroidsDestroyed = 0;
  int asteroidsMissed = 0;

  Stats copyWith({
    int? highscore,
    int? touchlessHighscore,
    int? asteroidsDestroyed,
    int? asteroidsMissed,
  }) {
    return Stats(
      highscore: highscore ?? this.highscore,
      touchlessHighscore: touchlessHighscore ?? this.touchlessHighscore,
      asteroidsDestroyed: asteroidsDestroyed ?? this.asteroidsDestroyed,
      asteroidsMissed: asteroidsMissed ?? this.asteroidsMissed,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'highscore': highscore,
      'touchlessHighscore': touchlessHighscore,
      'asteroidsDestroyed': asteroidsDestroyed,
      'asteroidsMissed': asteroidsMissed,
    };
  }

  factory Stats.fromMap(Map<String, dynamic> map) {
    return Stats(
      highscore: map['highscore']?.toInt() ?? 0,
      touchlessHighscore: map['touchlessHighscore']?.toInt() ?? 0,
      asteroidsDestroyed: map['asteroidsDestroyed']?.toInt() ?? 0,
      asteroidsMissed: map['asteroidsMissed']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Stats.fromJson(String source) => Stats.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Stats(highscore: $highscore, touchlessHighscore: $touchlessHighscore, asteroidsDestroyed: $asteroidsDestroyed, asteroidsMissed: $asteroidsMissed)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Stats &&
        other.highscore == highscore &&
        other.touchlessHighscore == touchlessHighscore &&
        other.asteroidsDestroyed == asteroidsDestroyed &&
        other.asteroidsMissed == asteroidsMissed;
  }

  @override
  int get hashCode {
    return highscore.hashCode ^
        touchlessHighscore.hashCode ^
        asteroidsDestroyed.hashCode ^
        asteroidsMissed.hashCode;
  }
}
