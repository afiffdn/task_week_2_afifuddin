import 'package:bloc/bloc.dart';
import 'package:fic11_starter_pos/data/datasource/auth_remote_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_event.dart';
part 'logout_state.dart';
part 'logout_bloc.freezed.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRemoteDataSource authRemoteDataSource;
  LogoutBloc(this.authRemoteDataSource) : super(_Initial()) {
    on<_Logout>((event, emit) async {
      emit(LogoutState.loading());
      final result = await authRemoteDataSource.logout();
      result.fold(
        (l) => emit(LogoutState.error(l)),
        (r) => emit(LogoutState.success()),
      );
    });
  }
}
