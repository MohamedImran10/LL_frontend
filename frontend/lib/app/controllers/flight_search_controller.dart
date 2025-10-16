import 'package:get/get.dart';
import '../models/flight.dart';
import '../services/flight_agent_service.dart';

class FlightSearchController extends GetxController {
  final FlightAgentService _agentService = Get.find<FlightAgentService>();
  
  // Reactive variables
  RxList<ChatMessage> get chatHistory => _agentService.chatHistory;
  RxList<FlightSearchQuery> get searchHistory => _agentService.searchHistory;
  RxBool get isLoading => _agentService.isLoading;

  @override
  void onInit() {
    super.onInit();
    _agentService.initializeChat();
  }

  /// Send message to flight agent
  Future<void> sendMessage(String message) async {
    await _agentService.sendMessage(message);
  }

  /// Get relevant search history
  List<FlightSearchQuery> getRelevantHistory(String query) {
    return _agentService.getRelevantHistory(query);
  }

  /// Clear chat history
  void clearChatHistory() {
    _agentService.clearChatHistory();
  }

  /// Clear search history
  void clearSearchHistory() {
    _agentService.clearSearchHistory();
  }

  /// Get quick search suggestions
  List<String> getQuickSearchSuggestions() {
    return [
      'Find flights from Delhi to Mumbai tomorrow',
      'Show me flights from Bangalore to Chennai next Monday',
      'NYC to London next week',
      'Dubai to Singapore this Friday',
      'Bangkok to Tokyo next Tuesday',
    ];
  }

  /// Process voice input (future feature)
  Future<void> processVoiceInput(String voiceText) async {
    await sendMessage(voiceText);
  }

  /// Book flight (placeholder for future implementation)
  Future<void> bookFlight(Flight flight) async {
    Get.snackbar(
      'Booking',
      'Booking flight ${flight.flightNumber} for ${flight.price}',
      snackPosition: SnackPosition.BOTTOM,
    );
    
    // TODO: Implement actual booking logic
    // This would integrate with payment gateway, booking APIs, etc.
  }

  /// Share flight details
  void shareFlight(Flight flight) {
    final shareText = '''
🛫 Flight Details:
${flight.airline} ${flight.flightNumber}
${flight.origin} → ${flight.destination}
🕐 ${flight.departureTime} - ${flight.arrivalTime}
⏱️ Duration: ${flight.duration}
💰 Price: ${flight.price}

Booked via LetzLevitate ✈️
    ''';
    
    // TODO: Implement actual sharing (platform specific)
    print('Sharing: $shareText'); // For now, just print to console
    Get.snackbar(
      'Share',
      'Flight details copied to share',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Save flight to favorites
  void saveFlight(Flight flight) {
    // TODO: Implement favorites functionality
    Get.snackbar(
      'Saved',
      'Flight saved to favorites',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
