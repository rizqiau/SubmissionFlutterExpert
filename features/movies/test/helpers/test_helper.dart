import '../../lib/data/datasources/movie_local_data_source.dart';
import '../../lib/data/datasources/movie_remote_data_source.dart';
import '../../lib/domain/repositories/movie_repository.dart';
import 'package:core/core.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [
    MovieRepository,
    MovieRemoteDataSource,
    MovieLocalDataSource,
    DatabaseHelper,
  ],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
