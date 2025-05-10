part of 'config_cubit.dart';

@immutable
class ConfigState {
  final bool isLoading;
  final bool isSaving;
  final String? selectedModel;
  final double? temperature;

  /// Optional system‐role prompt text.
  final String? systemPrompt;

  /// Raw text extracted from a loaded PDF.
  final String? pdfContent;
  final String? error;

  const ConfigState({
    this.isLoading = false,
    this.isSaving = false,
    this.selectedModel,
    this.temperature,
    this.systemPrompt,
    this.pdfContent,
    this.error,
  });

  ConfigState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? selectedModel,
    double? temperature,
    String? systemPrompt,
    String? pdfContent,
    String? error,
  }) {
    return ConfigState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      selectedModel: selectedModel ?? this.selectedModel,
      temperature: temperature ?? this.temperature,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      pdfContent: pdfContent ?? this.pdfContent,
      error: error,
    );
  }
}
