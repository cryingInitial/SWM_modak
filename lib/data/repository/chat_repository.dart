import 'package:modak_flutter_app/data/datasource/local_datasource.dart';
import 'package:modak_flutter_app/data/datasource/remote_datasource.dart';

class ChatRepository {
  ChatRepository._create();

  static Future<ChatRepository> create() async {
    ChatRepository albumRepository = ChatRepository._create();
    localDataSource ??= await LocalDataSource.create();
    remoteDataSource ??= RemoteDataSource();
    return albumRepository;
  }

  static LocalDataSource? localDataSource;
  static RemoteDataSource? remoteDataSource;
}