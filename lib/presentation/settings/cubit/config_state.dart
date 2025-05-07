part of 'config_cubit.dart';

@immutable
class ConfigState {
  final bool isLoading;
  final bool isSaving;
  final String? selectedModel;
  final String? error;

  const ConfigState({
    this.isLoading = false,
    this.isSaving = false,
    this.selectedModel,
    this.error,
  });

  ConfigState copyWith({
    bool? isLoading,
    bool? isSaving,
    String? selectedModel,
    String? error,
  }) {
    return ConfigState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      selectedModel: selectedModel ?? this.selectedModel,
      error: error,
    );
  }
}
