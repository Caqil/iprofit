// lib/features/news/screens/news_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/news_provider.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/error_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsDetailScreen extends ConsumerWidget {
  final int newsId;

  const NewsDetailScreen({super.key, required this.newsId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsDetailState = ref.watch(newsDetailProvider(newsId));

    return Scaffold(
      appBar: AppBar(title: const Text('News Detail')),
      body: newsDetailState.when(
        data: (news) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Featured image
                if (news.imageUrl != null)
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: CachedNetworkImage(
                      imageUrl: news.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        news.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Date
                      Text(
                        Formatters.formatDate(news.createdAt),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),

                      // Content
                      Text(
                        news.content,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => CustomErrorWidget(
          error: error.toString(),
          onRetry: () => ref.refresh(newsDetailProvider(newsId)),
        ),
      ),
    );
  }
}
