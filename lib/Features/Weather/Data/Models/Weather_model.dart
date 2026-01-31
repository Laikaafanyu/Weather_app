class Weather {
  final String city;
  final double temperature;
  final String description;
  final double wind;
  final int humidity;
  final String date; // raw string from API, e.g., "2026-02-01 14:30"

  Weather({
    required this.city,
    required this.temperature,
    required this.description,
    required this.wind,
    required this.humidity,
    required this.date,
  });

  // ✅ Add this getter to convert string to DateTime
  DateTime get dateTime {
    // API returns "YYYY-MM-DD HH:MM", we need "YYYY-MM-DDTHH:MM"
    return DateTime.parse(date.replaceFirst(' ', 'T'));
  }

  // Factory to create from API JSON
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['location']['name'],
      temperature: (json['current']['temp_c'] as num).toDouble(),
      description: json['current']['condition']['text'],
      wind: (json['current']['wind_kph'] as num).toDouble(),
      humidity: json['current']['humidity'],
      date: json['location']['localtime'],
    );
  }
}

