part of 'system_cubit.dart';

enum Languages { english, hebrew }

@immutable
class SystemState {
  final Languages language;
  final String? userId;

  const SystemState({this.language = Languages.english, this.userId});

  SystemState copyWith({Languages? language, String? userId}) {
    return SystemState(
      language: language ?? this.language,
      userId: userId ?? userId
      );

  }
}
