// features/movies/test/presentation/bloc/search_movies/search_movies_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/core.dart'; // Untuk Failure
import 'package:movies/movies.dart'; // Untuk BLoC, Event, State, dan UseCase

import '../../../dummy_data/dummy_objects.dart'; // Untuk testMovieList

import 'search_movies_bloc_test.mocks.dart'; // File mock yang akan digenerate

@GenerateMocks([SearchMovies])
void main() {
  late SearchMoviesBloc searchMoviesBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchMoviesBloc = SearchMoviesBloc(mockSearchMovies);
  });

  // Test case: Initial state
  test('initial state should be Empty', () {
    expect(searchMoviesBloc.state, const SearchMoviesInitial());
  });

  // Test case: Search Movies - Query is empty
  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'Should emit [Initial] when query is empty',
    build: () {
      return searchMoviesBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged('')),
    expect: () => <SearchMoviesState>[const SearchMoviesInitial()],
    verify: (_) {
      verifyZeroInteractions(
        mockSearchMovies,
      ); // Pastikan usecase tidak dipanggil
    },
  );

  // Test case: Search Movies - Success
  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'Should emit [Loading, Loaded] when data is fetched successfully',
    build: () {
      when(
        mockSearchMovies.execute('spiderman'),
      ).thenAnswer((_) async => Right(testMovieList));
      return searchMoviesBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged('spiderman')),
    wait: const Duration(milliseconds: 500), // Menunggu debounce selesai
    expect:
        () => <SearchMoviesState>[
          const SearchMoviesLoading(),
          SearchMoviesLoaded(testMovieList),
        ],
    verify: (bloc) {
      verify(mockSearchMovies.execute('spiderman'));
    },
  );

  // Test case: Search Movies - Error
  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'Should emit [Loading, Error] when fetching data fails',
    build: () {
      when(mockSearchMovies.execute('spiderman')).thenAnswer(
        (_) async => Left(ServerFailure('Server Failure')),
      ); // Hapus const jika ServerFailure tidak const
      return searchMoviesBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged('spiderman')),
    wait: const Duration(milliseconds: 500), // Menunggu debounce selesai
    expect:
        () => <SearchMoviesState>[
          const SearchMoviesLoading(),
          const SearchMoviesError('Server Failure'),
        ],
    verify: (bloc) {
      verify(mockSearchMovies.execute('spiderman'));
    },
  );
}
