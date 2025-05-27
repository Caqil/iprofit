// lib/features/news/repositories/news_repository.dart
import 'package:app/core/services/api_client.dart';

import '../../../core/services/api_client.dart';
import '../../../models/news.dart';
import '../../../repositories/base_repository.dart';

class NewsRepository extends BaseRepository {
  final ApiClient _apiClient;

  NewsRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<News>> getNews({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    return safeApiCall(() async {
      final Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      final response = await _apiClient.get('/news', queryParams: queryParams);

      final newsList = (response['news'] as List)
          .map((json) => News.fromJson(json))
          .toList();

      return newsList;
    });
  }

  Future<News> getNewsById(int id) async {
    return safeApiCall(() async {
      final response = await _apiClient.get('/news/$id');
      return News.fromJson(response['news']);
    });
  }

  Future<List<News>> getFeaturedNews() async {
    return safeApiCall(() async {
      final response = await _apiClient.get('/news/featured');

      final newsList = (response['news'] as List)
          .map((json) => News.fromJson(json))
          .toList();

      return newsList;
    });
  }

  Future<Map<String, dynamic>> getNewsCategories() async {
    return safeApiCall(() async {
      final response = await _apiClient.get('/news/categories');
      return response;
    });
  }

  Future<List<News>> getNewsByCategory(
    String category, {
    int page = 1,
    int limit = 10,
  }) async {
    return safeApiCall(() async {
      final response = await _apiClient.get(
        '/news/category/$category',
        queryParams: {'page': page.toString(), 'limit': limit.toString()},
      );

      final newsList = (response['news'] as List)
          .map((json) => News.fromJson(json))
          .toList();

      return newsList;
    });
  }

  Future<void> markNewsAsRead(int id) async {
    return safeApiCall(() async {
      await _apiClient.post('/news/$id/read', {});
    });
  }

  Future<Map<String, dynamic>> getNewsStatistics() async {
    return safeApiCall(() async {
      final response = await _apiClient.get('/news/statistics');
      return response;
    });
  }
}
