import 'package:dartz/dartz.dart';
import '/core/usecase/usecase.dart';
import '/data/models/auth/create_user_req.dart';
import '/domain/repositories/auth/signin.dart';

import '../../../service_locator.dart';

class SignupUseCase implements UseCase<Either, CreateUserReq> {
  @override
  Future<Either> call({CreateUserReq? params}) async {
    return sl<AuthRepository>().signup(params!);
  }
}
