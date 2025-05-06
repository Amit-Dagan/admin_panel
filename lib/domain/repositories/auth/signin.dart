import 'package:admin_panel/core/failure/failure.dart';
import 'package:admin_panel/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import '/data/models/auth/create_user_req.dart';

import '../../../data/models/auth/signin_user_req.dart';

abstract class AuthRepository {

  Future<Either> signup(CreateUserReq createUserReq);
  Future<Either<Failure, String>> signin(SigninUserReq signinUserReq);

}