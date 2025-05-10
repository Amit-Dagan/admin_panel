import 'package:admin_panel/domain/entities/chat_config.dart';
import 'package:admin_panel/domain/usecase/chat/get_chat_config.dart';
import 'package:admin_panel/domain/usecase/chat/get_chat_models.dart';
import 'package:admin_panel/domain/usecase/chat/set_chat_config.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'config_state.dart';

class ConfigCubit extends Cubit<ConfigState> {
  final GetChatConfigUseCase _getConfig;
  final SetChatConfigUseCase _setConfig;
  static late List<String> availableModels;

  ConfigCubit(this._getConfig, this._setConfig)
    : super(const ConfigState(isLoading: true)) {
    loadConfig();
  }

  Future<void> loadConfig() async {
    availableModels = await getChatModelsUseCase().call();

    emit(state.copyWith(isLoading: true, error: null));
    try {
      final cfg = await _getConfig.call();
      emit(
        state.copyWith(
          isLoading: false,
          selectedModel: cfg.model,
          temperature: cfg.temperature,
          systemPrompt: cfg.systemPrompt,
          pdfContent: cfg.pdfContent,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void selectModel(String? model) {
    emit(state.copyWith(selectedModel: model));
  }
  
  /// Updates the temperature in the state.
  void selectTemperature(double? temperature) {
    emit(state.copyWith(temperature: temperature));
  }

  void selectSystemPrompt(String? prompt) =>
      emit(state.copyWith(systemPrompt: prompt));

  void selectPdfContent(String? pdf) => emit(state.copyWith(pdfContent: pdf));

  Future<void> saveConfig() async {
    if (state.selectedModel == null) return;
    try {
      emit(state.copyWith(isSaving: true));
      final cfg = ChatConfig(
        model: state.selectedModel!,
        temperature: state.temperature,
        systemPrompt: state.systemPrompt,
        pdfContent: state.pdfContent,
      );
      await _setConfig.call(cfg);
      emit(state.copyWith(isSaving: false));
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: 'Error saving: $e'));
    }
  }
}
