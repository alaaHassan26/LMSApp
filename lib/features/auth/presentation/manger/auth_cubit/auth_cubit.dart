import 'package:bloc/bloc.dart';

import '../../../../../cache/cache_helper.dart';
import '../../../Data/Repos/LoginRepo.dart';
import 'auth_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginRepository loginRepository = LoginRepository();
  CacheHelper cacheHelper = CacheHelper();

  LoginCubit() : super(LoginInitial());

  Future<void> loginEmailUser(String email, String password) async {
    emit(LoginLoading());
    final eitherResponse = await loginRepository.loginUser(email, password);

    print(eitherResponse);

    eitherResponse.fold(
      (failure) {
        print('Error: ${failure.err}'); // Print the error message
        emit(LoginFailure(failure.err));
      },
      (loginResponse) async {
        await cacheHelper.saveData(key: 'token', value: loginResponse.token);
        emit(LoginSuccess(loginResponse));
      },
    );
  }
}
