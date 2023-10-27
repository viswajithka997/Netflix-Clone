import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:netflix/domain/core/main_failures/main_failure.dart';
import 'package:netflix/domain/downloads/i_downloads_repo.dart';
import 'package:netflix/domain/downloads/models/download.dart';
import 'package:injectable/injectable.dart';

part 'downloads_event.dart';
part 'downloads_state.dart';
part 'downloads_bloc.freezed.dart';

@injectable
class DownloadsBloc extends Bloc<DownloadsEvent, DownloadsState> {
  final IDownloadsRepo _downloadsRepo;

  DownloadsBloc(this._downloadsRepo) : super(DownloadsState.initial()) {
    on<_GetDownloadsImage>((event, emit) async {
      emit(
        state.copyWith(
          isLoading: true,
          downloadFailureOrSuccess: none(),
        ),
      );

      final Either<MainFailure, List<Downloads>> downloadOptions =
          await _downloadsRepo.getDownloadsImage();

      emit(
        downloadOptions.fold(
          (failure) => state.copyWith(
              isLoading: true, downloadFailureOrSuccess: Some(Left(failure))),
          (success) => state.copyWith(
            isLoading: false,
            downloadFailureOrSuccess: Some(
              Right(success),
            ),
            downloads: success,
          ),
        ),
      );
    });
  }
}
