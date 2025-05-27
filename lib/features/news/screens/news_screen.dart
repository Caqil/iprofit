// lib/features/news/screens/news_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/news_provider.dart';
import '../../../shared/widgets/error_widget.dart';
import '../widgets/news_card.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsListState = ref.watch(newsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('News & Updates')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(newsListProvider.notifier).refresh(),
        child: newsListState.when(
          data: (newsList) {
            if (newsList.isEmpty) {
              return const Center(child: Text('No news available'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return NewsCard(
                  news: news,
                  onTap: () => context.push('/news/${news.id}'),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => CustomErrorWidget(
            error: error.toString(),
            onRetry: () => ref.refresh(newsListProvider),
          ),
        ),
      ),
    );
  }
}
