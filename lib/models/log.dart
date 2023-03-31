class Log {
  int time;
  int type;

  Log({required this.time, required this.type});

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      time: json['time'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'type': type,
    };
  }
}
