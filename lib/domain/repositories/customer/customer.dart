import 'package:admin_panel/core/failure/failure.dart';
import 'package:admin_panel/domain/entities/user.dart';
import 'package:dartz/dartz.dart';

abstract class CustomerRepository {
  Future<Either<Failure, List<UserEntity>>> getCustomers({required int limit});
  
  }
