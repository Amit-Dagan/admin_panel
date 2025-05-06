import 'package:admin_panel/core/failure/failure.dart';
import 'package:admin_panel/data/sources/storage/storage_service.dart';
import 'package:admin_panel/domain/entities/user.dart';
import 'package:admin_panel/domain/repositories/customer/customer.dart';
import 'package:dartz/dartz.dart';

import '../../../service_locator.dart';


class CustomerRepositoryImpl extends CustomerRepository {
  @override
  Future<Either<Failure, List<UserEntity>>> getCustomers({required int limit}) async {
    return await sl<StorageService>().getCustomers(limit);
  }

//   @override
//   Future<Either> addCustomers({
//     required CustomerEntity newCustomer, required String clinicId,}
//   ) async {
//     return await sl<StorageService>().addCustomer(newCustomer, clinicId);
//   }
}
