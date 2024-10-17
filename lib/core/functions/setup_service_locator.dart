// // ignore_for_file: file_names


// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
// import 'package:lms/core/Server/Api_Dio.dart';

// final getIt = GetIt.instance;
// void setupServiceLocator() {
//   getIt.registerSingleton<ApiService>(
//     ApiService(
//       Dio(),
//     ),
//   );
//   getIt.registerSingleton<HomeRepoImpl>(
//     HomeRepoImpl(
//       homelocalDataSource: HomelocalDataSourceImpl(),
//       homeRemotDataSource: HomeRemotDataSourceImpl(
//         getIt.get<ApiService>(),
//       ),
//     ),
//   );
// }
