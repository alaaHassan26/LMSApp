// import 'package:bloc/bloc.dart';
// import 'package:lms/core/utils/Constatns.dart';
// import 'package:pusher_client/pusher_client.dart';

// import '../../cache/cache_helper.dart';

// // WebSocket state, managing connection and errors
// class WebSocketState {
//   final String status;
//   final String? error;
//   final List<String> comments;

//   WebSocketState({
//     required this.status,
//     this.error,
//     this.comments = const [],
//   });
// }


// class WebSocketCubit extends Cubit<WebSocketState> {
//   late PusherClient _pusher;
//   late Channel _channel;

//   WebSocketCubit()
//       : super(WebSocketState(
//           status: "disconnected",
//         ));

//   void initializePusher(String newsId, String studentId) {
//           String? token = CacheHelper().getData(key: 'saveToken') as String?;

//     try {
//       PusherOptions options = PusherOptions(
//         wsPort: 6001,
//         wssPort: 6001,
//         encrypted: true,
//         host: 'efredgvrergv34345435.online',
//         cluster: 'mt1',
//         // auth: PusherAuth('/app'),           يمكن هيج ابو حسين


//         // auth: PusherAuth('${CS.Api}/app'),             // ويمكن هيج جرب شوف شيطلع 
        


//         auth: PusherAuth('${CS.Api}/app' ,   headers: token != null
//           ? {
//               'Authorization': 'Bearer $token',
//             }
//           : null,),       
          
          
           
//       );       // واعتقادي هو هيج   

//       _pusher = PusherClient(
//         "local", 
//         options,
//         autoConnect: true,
//       );

//       _pusher.onConnectionStateChange((state) {
//         emit(WebSocketState(
//           status: state?.currentState ?? "disconnected", 
//         ));
//       });

//       _pusher.onConnectionError((error) {
//         emit(WebSocketState(
//           status: "error",
//           error: "Connection Error: ${error?.message ?? 'Unknown error'}", 
//         ));
//       });

//       _channel = _pusher.subscribe('private-news.$newsId.$studentId');

//       _channel.bind('App\\Events\\CommentNews', (PusherEvent? event) {
//         final updatedComments = List<String>.from(state.comments);
//         updatedComments.add(event?.data ?? "No comment data"); 
//         emit(WebSocketState(
//           status: "connected",
//           comments: updatedComments,
//         ));
//       });
//     } catch (e) {
//       emit(WebSocketState(
//         status: "error",
//         error: "Error initializing Pusher: $e",
//       ));
//     }
//   }

//   // Unsubscribe when done
//   void closeConnection() {
//     try {
//       _pusher.unsubscribe('private-news');
//       _pusher.disconnect();
//       emit(WebSocketState(status: "disconnected"));
//     } catch (e) {
//       emit(WebSocketState(
//         status: "error",
//         error: "Error disconnecting: $e",
//       ));
//     }
//   }
// }
