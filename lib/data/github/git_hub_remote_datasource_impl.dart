import 'package:dev_task/data/github/git_hub_repo_model.dart';
import 'package:dev_task/utils/network_service.dart';

import 'git_hub_local_datasource.dart';

abstract class GitHubRemoteDataSource {
  Future<List<GitHubRepoModel>> getAllPublicRepos(page);
}

class GitHubRemoteDataSourceImpl implements GitHubRemoteDataSource {
  NetWorkService netWorkService;
  GitHubRemoteDataSourceImpl(
    this.netWorkService,
  );
  @override
  Future<List<GitHubRepoModel>> getAllPublicRepos(page) async {
    try {
      List data = await netWorkService.getRequest(
              'https://api.github.com/users/square/repos?per_page=10&page=${page.toString()}')
          as List;

      return data.map((json) {
        return GitHubRepoModel.fromJson(json);
      }).toList();
    } catch (exception) {
      rethrow;
    }
  }
}
