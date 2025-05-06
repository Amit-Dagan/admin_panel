import 'package:dartz/dartz.dart';
import 'package:vet_care/core/failure/failure.dart';
import 'package:vet_care/domain/entities/appointment.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, List<AppointmentEntity>>> getCustomerAppointments(
    String customerId,
    String clinicId,
  );
  Future<Either<Failure, List<AppointmentEntity>>> getTodayAppointments(
    String clinicId,
  );
  Future<Either<Failure, AppointmentEntity>> updateAppointment(
    String appointmentId,
    String customerId,
    String clinicId,
  );
}
