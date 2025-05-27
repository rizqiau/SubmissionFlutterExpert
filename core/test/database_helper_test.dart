import 'package:movies/movies.dart';
import 'package:core/core.dart';
import 'package:tv/tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group('Database Helper Movie Tests', () {
    late DatabaseHelper dbHelper;
    final testMovie = MovieTable(
      id: 1,
      title: 'Inception',
      overview: 'A thief who steals corporate secrets...',
      posterPath: '/inception.jpg',
    );

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    setUp(() async {
      DatabaseHelper.clearInstance(); // Reset singleton
      dbHelper = DatabaseHelper(useInMemoryDb: true);
      await dbHelper.database; // Init database tanpa close
    });

    tearDown(() async {
      final db = await dbHelper.database;
      await db?.close();
    });

    test('insertWatchlist should return inserted id', () async {
      final result = await dbHelper.insertWatchlist(testMovie);
      expect(result, 1);
    });

    test('getMovieById should return correct movie', () async {
      await dbHelper.insertWatchlist(testMovie);

      final result = await dbHelper.getMovieById(testMovie.id);
      expect(result?['id'], testMovie.id);
      expect(result?['title'], testMovie.title);
    });

    test('removeWatchlist should delete movie', () async {
      await dbHelper.insertWatchlist(testMovie);

      final deleteResult = await dbHelper.removeWatchlist(testMovie);
      expect(deleteResult, 1);

      final result = await dbHelper.getMovieById(testMovie.id);
      expect(result, isNull);
    });

    test('getWatchlistMovies should return all movies', () async {
      // Insert 2 movies
      await dbHelper.insertWatchlist(testMovie);
      await dbHelper.insertWatchlist(testMovie.copyWith(id: 2));

      final result = await dbHelper.getWatchlistMovies();
      expect(result.length, 2);
    });
  });

  group('Database Helper TV Tests', () {
    late DatabaseHelper dbHelper;
    final testTv = TvTable(
      id: 1,
      originalName: 'Breaking Bad',
      overview: 'A chemistry teacher diagnosed with cancer...',
      posterPath: '/breaking_bad.jpg',
    );

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    });

    setUp(() async {
      DatabaseHelper.clearInstance(); // Reset singleton
      dbHelper = DatabaseHelper(useInMemoryDb: true);
      await dbHelper.database; // Init database tanpa close
    });

    tearDown(() async {
      final db = await dbHelper.database;
      await db?.close();
    });

    test('insertWatchlistTv should return inserted id', () async {
      final result = await dbHelper.insertWatchlistTv(testTv);
      expect(result, 1);
    });

    test('getTvById should return correct tv', () async {
      await dbHelper.insertWatchlistTv(testTv);

      final result = await dbHelper.getTvById(testTv.id);
      expect(result?['id'], testTv.id);
      expect(result?['originalName'], testTv.originalName);
    });

    test('removeWatchlistTv should delete tv', () async {
      await dbHelper.insertWatchlistTv(testTv);

      final deleteResult = await dbHelper.removeWatchlistTv(testTv);
      expect(deleteResult, 1);

      final result = await dbHelper.getTvById(testTv.id);
      expect(result, isNull);
    });

    test('getWatchlistTv should return all tv shows', () async {
      await dbHelper.insertWatchlistTv(testTv);
      await dbHelper.insertWatchlistTv(testTv.copyWith(id: 2));

      final result = await dbHelper.getWatchlistTv();
      expect(result.length, 2);
    });
  });
}
