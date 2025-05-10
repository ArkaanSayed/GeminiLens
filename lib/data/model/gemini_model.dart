class GeminiModel {
  final String responseText;

  GeminiModel({required this.responseText});

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'responseText': responseText,
    };
  }

  // Create from JSON
  factory GeminiModel.fromJson(Map<String, dynamic> json) {
    return GeminiModel(
      responseText: json['responseText'],
    );
  }
}
