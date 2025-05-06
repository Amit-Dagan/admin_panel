
import 'package:admin_panel/data/repositories/chat/chat_repo_impl.dart';
import 'package:admin_panel/data/repositories/customer/customer_repo_impl.dart';
import 'package:admin_panel/data/sources/chat/chat_service.dart';
import 'package:admin_panel/domain/repositories/chat/chat.dart';
import 'package:admin_panel/domain/repositories/customer/customer.dart';
import 'package:admin_panel/domain/usecase/chat/send_message.dart';

import '/data/sources/auth/auth_service.dart';
import 'package:get_it/get_it.dart';

import 'data/repositories/auth/auth_repo_impl.dart';
import 'domain/repositories/auth/signin.dart';
import 'domain/usecase/auth/auth.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<SigninUseCase>(SigninUseCase());
  sl.registerSingleton<AuthService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<CustomerRepository>(CustomerRepositoryImpl());
  sl.registerSingleton<SendMessageUseCase>(SendMessageUseCase());
  sl.registerSingleton<ChatRepository>(ChatRepositoryImpl());
  sl.registerSingleton<ChatService>(ChatServiceImpl());
}