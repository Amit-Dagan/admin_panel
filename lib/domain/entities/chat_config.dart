/// Represents configuration settings for the ChatGPT integration.
class ChatConfig {
  /// The model identifier, e.g. "gpt-3.5-turbo", "gpt-4".
  final String? model;
  final double? temperature;
  /// Optional system prompt to include for ChatGPT.
  final String? systemPrompt;
  /// Extracted PDF content to include in system prompt.
  final String? pdfContent;

  const ChatConfig({
    this.model,
    this.temperature,
    this.systemPrompt,
    this.pdfContent,
  });
}
