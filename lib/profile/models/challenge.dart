class Challenge {
  final String name;
  final int points;
  final ChallengeType type;
  final int level;
  final int value;

  const Challenge(
      {required this.name,
      required this.points,
      required this.type,
      required this.level,
      required this.value});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['name'] = name;
    json['points'] = points;
    json['challengeType'] = type.name;
    json['level'] = level;
    json['value'] = value;
    return json;
  }

  Challenge.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        points = json['points'],
        type = json['challengeType'] != null
            ? ChallengeType.values
                .firstWhere((element) => element.name == json["challengeType"])
            : ChallengeType.STEP,
        value = json['value']!=null?json['value']??-1:-1,
        level = json['level'];

  @override
  String toString() {
    return 'Challenge{name: $name, points: $points, type: $type, level: $level, value: $value}';
  }
}

enum ChallengeType { STEP, WALK, TRAINING, FUN }
