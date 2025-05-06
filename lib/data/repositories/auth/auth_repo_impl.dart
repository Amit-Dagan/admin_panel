import 'package:admin_panel/core/failure/failure.dart';
import 'package:admin_panel/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import '/data/models/auth/create_user_req.dart';

import '../../../domain/repositories/auth/signin.dart';
import '../../../service_locator.dart';
import '../../models/auth/signin_user_req.dart';
import '../../sources/auth/auth_service.dart';


class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either<Failure, String>> signin(SigninUserReq signinUserReq) async {
    return await sl<AuthService>().signin(signinUserReq) ;

  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    return await sl<AuthService>().signup(createUserReq) ;
  }

}

