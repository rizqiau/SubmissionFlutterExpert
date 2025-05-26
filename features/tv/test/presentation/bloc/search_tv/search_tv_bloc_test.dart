import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:core/core.dart'; // Untuk Failure
import 'package:tv/tv.dart'; // Untuk BLoC, Event, State, dan UseCase

import '../../../dummy_data/dummy_objects.dart';

import 'search_tv_bloc_test.mocks.dart'; // File mock yang akan digenerate

@GenerateMocks([SearchTv])
void main() {
  late SearchTvBloc searchTvBloc;
  late MockSearchTv mockSearchTv;

  setUp(() {
    mockSearchTv = MockSearchTv();
    searchTvBloc = SearchTvBloc(mockSearchTv);
  });

  // Test case: Initial state
  test('initial state should be Empty', () {
    expect(searchTvBloc.state, const SearchTvInitial());
  });

  // Test case: Search Tv - Query is empty
  blocTest<SearchTvBloc, SearchTvState>(
    'Should emit [Initial] when query is empty',
    build: () {
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged('')),
    expect: () => <SearchTvState>[const SearchTvInitial()],
    verify: (_) {
      verifyZeroInteractions(mockSearchTv); // Pastikan usecase tidak dipanggil
    },
  );

  // Test case: Search Tv - Success
  blocTest<SearchTvBloc, SearchTvState>(
    'Should emit [Loading, Loaded] when data is fetched successfully',
    build: () {
      when(
        mockSearchTv.execute('the last of us'),
      ).thenAnswer((_) async => Right(testTvList));
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged('the last of us')),
    wait: const Duration(milliseconds: 500), // Menunggu debounce selesai
    expect:
        () => <SearchTvState>[
          const SearchTvLoading(),
          SearchTvLoaded(testTvList),
        ],
    verify: (bloc) {
      verify(mockSearchTv.execute('the last of us'));
    },
  );

  // Test case: Search Tv - Error
  blocTest<SearchTvBloc, SearchTvState>(
    'Should emit [Loading, Error] when fetching data fails',
    build: () {
      when(mockSearchTv.execute('the last of us')).thenAnswer(
        (_) async => Left(ServerFailure('Server Failure')),
      ); // Hapus const jika ServerFailure tidak const
      return searchTvBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged('the last of us')),
    wait: const Duration(milliseconds: 500), // Menunggu debounce selesai
    expect:
        () => <SearchTvState>[
          const SearchTvLoading(),
          const SearchTvError('Server Failure'),
        ],
    verify: (bloc) {
      verify(mockSearchTv.execute('the last of us'));
    },
  );
}
