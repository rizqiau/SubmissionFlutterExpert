import 'package:core/core.dart';
import 'package:tv/tv.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks(
  [TvRepository, TvRemoteDataSource, TvLocalDataSource, DatabaseHelper],
  customMocks: [MockSpec<http.Client>(as: #MockHttpClient)],
)
void main() {}
