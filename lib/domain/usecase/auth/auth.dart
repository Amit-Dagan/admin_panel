import 'package:admin_panel/core/failure/failure.dart';
import 'package:admin_panel/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import '/data/models/auth/create_user_req.dart';

import '../../../core/usecase/usecase.dart';
import '../../../data/models/auth/signin_user_req.dart';
import '../../../service_locator.dart';
import '../../repositories/auth/signin.dart';

class SigninUseCase implements UseCase<Either<Failure, String>, SigninUserReq> {
  @override
  Future<Either<Failure, String>> call({SigninUserReq? params}) async {
    return sl<AuthRepository>().signin(params!);
  }
}


class SignupUseCase implements UseCase<Either, CreateUserReq> {
  @override
  Future<Either> call({CreateUserReq? params}) async {
    return sl<AuthRepository>().signup(params!);
  }
}
