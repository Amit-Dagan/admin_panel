
import 'package:admin_panel/core/failure/failure.dart';
import 'package:admin_panel/data/models/storage/customer.dart';
import 'package:admin_panel/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class StorageService {
  Future<Either<Failure, List<UserEntity>>> getCustomers(int limit);
  //Future<Either> addCustomer(CustomerEntity newCustomer, String clinicId);
}

// class MockStorageServiceImpl extends StorageService {
//   @override
//   Future<Either> getCustomers(String clinicId) {
//     // TODO: implement getcustomers
//     throw UnimplementedError();
//   }

//   @override
//   Future<Either> addCustomer(CustomerEntity newCustomer, String clinicId) {
//     // TODO: implement addCostumer
//     throw UnimplementedError();
//   }
// }

class FirebaseStorageServiceImpl extends StorageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either<Failure, List<UserEntity>>> getCustomers(int limit) async {
    try {
      // Query for customers by clinicId (assuming your Firestore field name is "clinicId")
      final querySnapshot =
          await _firestore
              .collection('users')
              .where({'role': UserRole.patient})
              .limit(limit)
              .get();
      // Convert snapshot to list of CustomerEntity objects

      final customers =
          querySnapshot.docs.map((doc) {
            // Assuming you have a fromJson or similar constructor in CustomerEntity
            return UserModel.fromJson(doc.data()).toEntity();
          }).toList();

      return Right(customers);
    } catch (e) {
      print(e);
      return Left(ValidationFailure(e.toString()));
    }
  }
}
