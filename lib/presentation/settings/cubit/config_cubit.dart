import 'package:admin_panel/domain/entities/chat_config.dart';
import 'package:admin_panel/domain/usecase/chat/get_chat_config.dart';
import 'package:admin_panel/domain/usecase/chat/set_chat_config.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'config_state.dart';

class ConfigCubit extends Cubit<ConfigState> {
  final GetChatConfigUseCase _getConfig;
  final SetChatConfigUseCase _setConfig;
  static const List<String> availableModels = [
    'gpt-3.5-turbo',
    'gpt-4',
    'gpt-4o',
  ];

  ConfigCubit(this._getConfig, this._setConfig)
    : super(const ConfigState(isLoading: true)) {
    loadConfig();
  }

  Future<void> loadConfig() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final cfg = await _getConfig.call();
      emit(state.copyWith(isLoading: false, selectedModel: cfg.model));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void selectModel(String? model) {
    emit(state.copyWith(selectedModel: model));
  }

  Future<void> saveConfig() async {
    if (state.selectedModel == null) return;
    try {
      emit(state.copyWith(isSaving: true));
      final cfg = ChatConfig(model: state.selectedModel!);
      await _setConfig.call(cfg);
      emit(state.copyWith(isSaving: false));
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: 'Error saving: $e'));
    }
  }
}
