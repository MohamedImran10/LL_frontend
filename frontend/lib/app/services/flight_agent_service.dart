import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import '../models/flight.dart';
import 'storage_service.dart';

class FlightAgentService extends GetxService {
  static FlightAgentService get to => Get.find();
  
  // Backend URL - Replace with your actual backend URL
  static const String backendUrl = 'http://192.168.1.100:8000'; // Update this with your backend IP
  
  // Store chat history and search queries
  final RxList<ChatMessage> chatHistory = <ChatMessage>[].obs;
  final RxList<FlightSearchQuery> searchHistory = <FlightSearchQuery>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadChatHistory();
    _loadSearchHistory(); 
  }

  /// Initialize with welcome message
  void initializeChat() {
    if (chatHistory.isEmpty) {
      final welcomeMessage = ChatMessage(
        id: _generateId(),
        message: "🛫 Welcome to your AI Flight Assistant! I can help you find flights between any airports worldwide.\n\n💡 Try saying:\n• \"Find flights from NYC to London tomorrow\"\n• \"Show me flights from Delhi to Dubai next Monday\"\n• \"Bangkok to Singapore this Friday\"",
        isUser: false,
        timestamp: DateTime.now(),
      );
      chatHistory.add(welcomeMessage);
      _saveChatHistory();
    }
  }

  /// Send message to flight agent and get response
  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    isLoading.value = true;

    // Add user message to chat
    final userChatMessage = ChatMessage(
      id: _generateId(),
      message: userMessage,
      isUser: true,
      timestamp: DateTime.now(),
    );
    chatHistory.add(userChatMessage);

    try {
      // Generate flights first
      List<Flight> flights = _generateMockFlights(userMessage);
      
      // Create response message based on the generated flights
      String response;
      if (flights.isNotEmpty) {
        response = _buildResponseFromFlights(flights);
      } else {
        response = "❌ Sorry, I couldn't find any flights for that route and date. Please try different dates or destinations.";
      }
      
      // Add agent response to chat with the same flight data
      final agentMessage = ChatMessage(
        id: _generateId(),
        message: response,
        isUser: false,
        timestamp: DateTime.now(),
        flights: flights.isNotEmpty ? flights : null,
      );
      chatHistory.add(agentMessage);

      // Save search query if flights were found
      if (flights.isNotEmpty) {
        await _saveSearchQuery(userMessage, flights);
      }
    } catch (e) {
      print('Error in flight search: $e');
      // Add error message
      final errorMessage = ChatMessage(
        id: _generateId(),
        message: "⚠️ Sorry, I couldn't process your request right now. Please try again or check your connection.",
        isUser: false,
        timestamp: DateTime.now(),
      );
      chatHistory.add(errorMessage);
    } finally {
      isLoading.value = false;
      _saveChatHistory();
    }
  }

  /// Build response message from flight data
  String _buildResponseFromFlights(List<Flight> flights) {
    if (flights.isEmpty) {
      return "❌ Sorry, I couldn't find any flights for that route and date. Please try different dates or destinations.";
    }
    
    String response = "✈️ Here are the top flights I found for your travel:\n\n";
    response += "🎯 Perfect matches for your journey from ${flights.first.origin} to ${flights.first.destination}\n\n";
    response += "💡 Tap on any flight card below for booking details and more information!";
    return response;
  }

  /// Generate mock flights for development
  List<Flight> _generateMockFlights(String query) {
    final Random random = Random();
    final airlines = ['IndiGo', 'Air India', 'SpiceJet', 'Vistara', 'GoAir'];
    final prices = ['₹8,450', '₹12,300', '₹9,890', '₹15,670', '₹7,230'];
    
    return List.generate(3, (index) {
      final airline = airlines[random.nextInt(airlines.length)];
      final price = prices[random.nextInt(prices.length)];
      final depHour = 6 + random.nextInt(18);
      final depMinute = random.nextInt(60);
      final duration = 2 + random.nextInt(8);
      final arrHour = (depHour + duration) % 24;
      final arrMinute = depMinute + random.nextInt(60);
      
      return Flight(
        airline: airline,
        price: price,
        departureTime: '${depHour.toString().padLeft(2, '0')}:${depMinute.toString().padLeft(2, '0')}',
        arrivalTime: '${arrHour.toString().padLeft(2, '0')}:${(arrMinute % 60).toString().padLeft(2, '0')}',
        duration: '${duration}h ${random.nextInt(60)}m',
        flightNumber: '${airline.substring(0, 2).toUpperCase()} ${1000 + random.nextInt(9000)}',
        origin: _extractOrigin(query),
        destination: _extractDestination(query),
        date: _extractDate(query),
      );
    });
  }

  /// Extract origin from query (basic implementation)
  String _extractOrigin(String query) {
    // Basic regex to find "from X to Y" pattern
    final fromToPattern = RegExp(r'from\s+(\w+)', caseSensitive: false);
    final match = fromToPattern.firstMatch(query);
    return match?.group(1)?.toUpperCase() ?? 'DEL';
  }

  /// Extract destination from query (basic implementation)
  String _extractDestination(String query) {
    final toPattern = RegExp(r'to\s+(\w+)', caseSensitive: false);
    final match = toPattern.firstMatch(query);
    return match?.group(1)?.toUpperCase() ?? 'BOM';
  }

  /// Extract date from query (basic implementation)
  String _extractDate(String query) {
    final today = DateTime.now();
    if (query.toLowerCase().contains('tomorrow')) {
      final tomorrow = today.add(const Duration(days: 1));
      return '${tomorrow.day}/${tomorrow.month}/${tomorrow.year}';
    } else if (query.toLowerCase().contains('today')) {
      return '${today.day}/${today.month}/${today.year}';
    } else if (query.toLowerCase().contains('next monday')) {
      final nextMonday = today.add(Duration(days: (DateTime.monday - today.weekday + 7) % 7));
      return '${nextMonday.day}/${nextMonday.month}/${nextMonday.year}';
    } else if (query.toLowerCase().contains('next tuesday')) {
      final nextTuesday = today.add(Duration(days: (DateTime.tuesday - today.weekday + 7) % 7));
      return '${nextTuesday.day}/${nextTuesday.month}/${nextTuesday.year}';
    } else if (query.toLowerCase().contains('next friday')) {
      final nextFriday = today.add(Duration(days: (DateTime.friday - today.weekday + 7) % 7));
      return '${nextFriday.day}/${nextFriday.month}/${nextFriday.year}';
    }
    // Default to tomorrow
    final tomorrow = today.add(const Duration(days: 1));
    return '${tomorrow.day}/${tomorrow.month}/${tomorrow.year}';
  }

  /// Save search query to history
  Future<void> _saveSearchQuery(String query, List<Flight> flights) async {
    final searchQuery = FlightSearchQuery(
      id: _generateId(),
      query: query,
      origin: flights.isNotEmpty ? flights.first.origin : '',
      destination: flights.isNotEmpty ? flights.first.destination : '',
      date: flights.isNotEmpty ? flights.first.date : '',
      timestamp: DateTime.now(),
      results: flights,
    );

    searchHistory.add(searchQuery);
    _saveSearchHistory();
  }

  /// Get relevant past searches for context
  List<FlightSearchQuery> getRelevantHistory(String query) {
    // Simple relevance matching - can be improved with better NLP
    return searchHistory.where((search) {
      return query.toLowerCase().contains(search.origin.toLowerCase()) ||
             query.toLowerCase().contains(search.destination.toLowerCase()) ||
             search.query.toLowerCase().contains(query.toLowerCase());
    }).take(3).toList();
  }

  /// Clear chat history
  void clearChatHistory() {
    chatHistory.clear();
    _saveChatHistory();
    initializeChat();
  }

  /// Clear search history
  void clearSearchHistory() {
    searchHistory.clear();
    _saveSearchHistory();
  }

  /// Generate unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// Save chat history to local storage
  Future<void> _saveChatHistory() async {
    try {
      final chatData = chatHistory.map((msg) => msg.toJson()).toList();
      await StorageService.to.saveChatHistory(jsonEncode(chatData));
    } catch (e) {
      print('Error saving chat history: $e');
    }
  }

  /// Load chat history from local storage
  Future<void> _loadChatHistory() async {
    try {
      final chatData = StorageService.to.getChatHistory();
      if (chatData != null) {
        final List<dynamic> decoded = jsonDecode(chatData);
        chatHistory.value = decoded.map((json) => ChatMessage.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading chat history: $e');
    }
  }

  /// Save search history to local storage
  Future<void> _saveSearchHistory() async {
    try {
      final searchData = searchHistory.map((query) => query.toJson()).toList();
      await StorageService.to.saveSearchHistory(jsonEncode(searchData));
    } catch (e) {
      print('Error saving search history: $e');
    }
  }

  /// Load search history from local storage
  Future<void> _loadSearchHistory() async {
    try {
      final searchData = StorageService.to.getSearchHistory();
      if (searchData != null) {
        final List<dynamic> decoded = jsonDecode(searchData);
        searchHistory.value = decoded.map((json) => FlightSearchQuery.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading search history: $e');
    }
  }
}
