import 'package:admin_panel/core/failure/failure.dart';
import 'package:admin_panel/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import '/data/models/auth/create_user_req.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/auth/signin_user_req.dart';

abstract class AuthService {
  Future<Either<Failure, String>> signin(SigninUserReq signinUserReq);
  Future<Either> signup(CreateUserReq createUserReq);
}

// class MockAuthServiceImpl extends AuthService {
//   @override
//   Future<Either> signin(SigninUserReq signinUserReq) async {
//     return const Right('Success');
//   }

//   @override
//   Future<Either> signup(CreateUserReq createUserReq) async {
//     return const Right('Success');
//   }
// }

class AuthFirebaseServiceImpl extends AuthService {
  @override
  Future<Either<Failure, String>> signin(
    SigninUserReq signinUserReq,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signinUserReq.email,
        password: signinUserReq.password,
      );
      final userId = FirebaseAuth.instance.currentUser!.uid;

      return Right(userId);
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'invalid-email';
      }

      if (e.code == 'invalid-credential') {
        message = 'Wrong email or password';
      } else {
        message = e.code.toString();
      }
      return Left(ValidationFailure(message));
    }
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    try {
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: createUserReq.email,
        password: createUserReq.password,
      );

      FirebaseFirestore.instance.collection('users').doc(data.user?.uid).set({
        'name': createUserReq.fullName,
        'email': data.user?.email,
      });

      return const Right('Success');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'Password is to weak';
      }

      if (e.code == 'email-already-in-use') {
        message = 'Email already in use';
      } else {
        message = e.code.toString();
      }

      return Left(message);
    }
  }
}
