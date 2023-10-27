import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:netflix/domain/core/api_end_points.dart';
import 'package:netflix/domain/core/main_failures/main_failure.dart';
import 'package:netflix/domain/downloads/i_downloads_repo.dart';
import 'package:netflix/domain/downloads/models/download.dart';

@LazySingleton(as: IDownloadsRepo)
class DownloadsRepository implements IDownloadsRepo {
  @override
  Future<Either<MainFailure, List<Downloads>>> getDownloadsImage() async {
    try {
      final Response response = await Dio().get(ApiEndPoints.downloads);

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<Downloads> downloadList = [];
        downloadList = (response.data['results'] as List).map((e) {
          return Downloads.fromJson(e);
        }).toList();

        return Right(downloadList);
      } else {
        return const Left(MainFailure.serverFailure());
      }
    } catch (_) {
      debugPrint(_.toString());
    }
    return const Left(MainFailure.clientFailure());
  }
}
