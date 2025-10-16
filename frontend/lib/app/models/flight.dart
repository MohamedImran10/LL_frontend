class Flight {
  final String airline;
  final String price;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String flightNumber;
  final String origin;
  final String destination;
  final String date;

  Flight({
    required this.airline,
    required this.price,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.flightNumber,
    required this.origin,
    required this.destination,
    required this.date,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      airline: json['airline'] ?? '',
      price: json['price'] ?? '',
      departureTime: json['departure_time'] ?? '',
      arrivalTime: json['arrival_time'] ?? '',
      duration: json['duration'] ?? '',
      flightNumber: json['flight_number'] ?? '',
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'airline': airline,
      'price': price,
      'departure_time': departureTime,
      'arrival_time': arrivalTime,
      'duration': duration,
      'flight_number': flightNumber,
      'origin': origin,
      'destination': destination,
      'date': date,
    };
  }
}

class FlightSearchQuery {
  final String id;
  final String query;
  final String origin;
  final String destination;
  final String date;
  final DateTime timestamp;
  final List<Flight> results;

  FlightSearchQuery({
    required this.id,
    required this.query,
    required this.origin,
    required this.destination,
    required this.date,
    required this.timestamp,
    required this.results,
  });

  factory FlightSearchQuery.fromJson(Map<String, dynamic> json) {
    return FlightSearchQuery(
      id: json['id'] ?? '',
      query: json['query'] ?? '',
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      date: json['date'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      results: (json['results'] as List<dynamic>?)
          ?.map((flightJson) => Flight.fromJson(flightJson))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
      'origin': origin,
      'destination': destination,
      'date': date,
      'timestamp': timestamp.toIso8601String(),
      'results': results.map((flight) => flight.toJson()).toList(),
    };
  }
}

class ChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final List<Flight>? flights;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.flights,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      isUser: json['isUser'] ?? false,
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      flights: (json['flights'] as List<dynamic>?)
          ?.map((flightJson) => Flight.fromJson(flightJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'flights': flights?.map((flight) => flight.toJson()).toList(),
    };
  }
}
