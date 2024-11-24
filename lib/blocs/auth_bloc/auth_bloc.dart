import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenbil_vendor_app/models/login_response.dart';
import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await authRepository.login(event.email, event.password);

      // Save tokens in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', result.accessToken);
      await prefs.setString('refreshToken', result.refreshToken);

      emit(AuthSuccess(vendorData: result.userInfo));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await authRepository.signup(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
      );

      emit(AuthSignupSuccess());
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
}
