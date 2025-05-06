import 'package:admin_panel/domain/entities/user.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

part 'system_state.dart';

class SystemCubit extends Cubit<SystemState> {
  SystemCubit() : super(const SystemState());

  void changeLanguage(Languages language) {
    emit(state.copyWith(language: language));
  }

  void toggleLanguage() {
    if (state.language == Languages.english) {
      emit(state.copyWith(language: Languages.hebrew));
    } else {
      emit(state.copyWith(language: Languages.english));
    }
  }

  /// Expose the current locale for MaterialApp
  Locale get currentLocale {
    switch (state.language) {
      case Languages.hebrew:
        return const Locale('he');
      case Languages.english:
      default:
        return const Locale('en');
    }
  }

  void saveCurrentUser(String userId) {
    emit(state.copyWith(userId: userId));
  }

}
