import 'package:dev_task/constants/hive_keys.dart';
import 'package:dev_task/data/github/git_hub_repo_model.dart';
import 'package:dev_task/utils/failure.dart';
import 'package:dev_task/utils/hive_helper.dart';

abstract class GitHubLocalDataSource {
  void cacheRepos(List<GitHubRepoModel> repos);
  Future<List<GitHubRepoModel>> getCachedRepos();
}

class GitHubLocalDataSourceImpl implements GitHubLocalDataSource {
  HiveHelper hiveHelper;
  GitHubLocalDataSourceImpl(
    this.hiveHelper,
  );

  @override
  void cacheRepos(List<GitHubRepoModel> repos) async {
    try {
      repos.forEach((repo) async {
        await hiveHelper.add(
          repo.toJson(),
          key: repo.id,
        );
      });
    } catch (e) {
      throw AppFailures.defaultFailure;
    }
  }

  @override
  Future<List<GitHubRepoModel>> getCachedRepos() async {
    try {
      dynamic repos = await hiveHelper.getAll();
      return repos.map((repoJson) {
        return GitHubRepoModel.fromJson(repoJson);
      }).toList();
    } catch (e) {
      throw AppFailures.defaultFailure;
    }
  }
}
