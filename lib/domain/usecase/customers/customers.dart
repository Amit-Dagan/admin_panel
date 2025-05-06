import 'package:admin_panel/core/failure/failure.dart';
import 'package:admin_panel/core/usecase/usecase.dart';
import 'package:admin_panel/domain/entities/user.dart';
import 'package:admin_panel/domain/repositories/customer/customer.dart';
import 'package:admin_panel/service_locator.dart';
import 'package:dartz/dartz.dart';


class GetCustomersListUseCase implements UseCase<Either<Failure, List<UserEntity>>, GetCustomersParams> {

  @override
  Future<Either<Failure, List<UserEntity>>> call({
    required GetCustomersParams params,
  }) {
    return sl<CustomerRepository>().getCustomers(limit: params.limit);
  }
}


// class GetCustomerChatsUseCase implements UseCase<Either, AddCustomerParams> {
//   @override
//   Future<Either> call({required AddCustomerParams params}) {
//     return sl<CustomerRepository>().addCustomers(newCustomer: params.customer, clinicId: params.clinicId);
//   }
// }

// class GetCustomerChatUseCase implements UseCase<Either, AddCustomerParams> {
//   @override
//   Future<Either> call({required AddCustomerParams params}) {
//     return sl<CustomerRepository>().addCustomers(
//       newCustomer: params.customer,
//       clinicId: params.clinicId,
//     );
//   }
// }

// class GetCustomerChatsListUseCase implements UseCase<Either, AddCustomerParams> {
//   @override
//   Future<Either> call({required AddCustomerParams params}) {
//     return sl<CustomerRepository>().addCustomers(
//       newCustomer: params.customer,
//       clinicId: params.clinicId,
//     );
//   }
// }


class GetCustomersParams {
  final int limit ;
  const GetCustomersParams(this.limit);
}
