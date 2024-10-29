import 'package:lms/cache/cache_helper.dart';
import 'package:lms/core/Server/Api_Dio.dart';
import 'package:lms/features/courses_page/data/models/mcq_model.dart';
import 'package:lms/features/courses_page/data/models/question_model.dart';
import 'package:lms/features/courses_page/data/models/question_result_model.dart';

abstract class McqRemotDataSource {
  Future<List<QuestionResult>> getQuestionResults({required String questionId});
  Future<List<McqQuestion>> getQuestions({required String id});
  Future<List<McqCategory>> getCategories();
}

class McqRemotDataSourceImpl extends McqRemotDataSource {
  final ApiService apiService;

  McqRemotDataSourceImpl({required this.apiService});
  @override
  Future<List<QuestionResult>> getQuestionResults(
      {required String questionId}) async {
    String? token = CacheHelper().getData(key: 'saveToken') as String?;
    // Prepare the request body
    final data = {
      'id': questionId, // Send the ID as part of the body
    };
    // Change the request method to POST and send the body
    final response = await apiService.post(
      '/api/show_result_question',
      data: data,
      token: token,
    );
    final List<QuestionResult> results = (response.data['result'] as List)
        .map((json) => QuestionResult.fromJson(json))
        .toList();
    return results;
  }

  @override
  Future<List<McqQuestion>> getQuestions({required String id}) async {
    String? token = CacheHelper().getData(key: 'saveToken') as String?;
    final response =
        await apiService.get('/api/get_question?category_id=$id', token: token);
    final List<McqQuestion> questions = (response.data['result'] as List)
        .map((json) => McqQuestion.fromJson(json))
        .toList();

    return questions;
  }

  @override
  Future<List<McqCategory>> getCategories() async {
    String? token = CacheHelper().getData(key: 'saveToken') as String?;
    final response =
        await apiService.get('/api/get_categories_question', token: token);
    final List<McqCategory> categories = (response.data['result'] as List)
        .map((json) => McqCategory.fromJson(json))
        .toList();

    return categories;
  }
}
