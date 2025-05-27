// lib/features/news/providers/news_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/news_repository.dart';
import '../../../models/news.dart';
import '../../../providers/global_providers.dart';

part 'news_provider.g.dart';

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepository(apiClient: ref.watch(apiClientProvider));
});

@riverpod
class NewsList extends _$NewsList {
  @override
  Future<List<News>> build() async {
    return ref.watch(newsRepositoryProvider).getNews();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    try {
      final news = await ref.read(newsRepositoryProvider).getNews();
      state = AsyncValue.data(news);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

@riverpod
Future<News> newsDetail(NewsDetailRef ref, int id) {
  return ref.watch(newsRepositoryProvider).getNewsById(id);
}
