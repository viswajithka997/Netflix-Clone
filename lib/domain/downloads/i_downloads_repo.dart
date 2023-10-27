import 'package:netflix/domain/core/main_failures/main_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:netflix/domain/downloads/models/download.dart';

abstract class IDownloadsRepo {
  Future<Either<MainFailure, List<Downloads>>> getDownloadsImage();
}
