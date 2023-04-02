class Log {
  int time;
  int type;

  Log({required this.time, required this.type});

  factory Log.fromJson(Map json) {
    return Log(
      time: json['time'],
      type: json['type'],
    );
  }

  Map toJson() {
    return {
      'time': time,
      'type': type,
    };
  }
}
