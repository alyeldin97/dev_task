import 'package:dartz/dartz.dart';
import 'package:dev_task/data/github/git_hub_local_datasource.dart';

import 'package:dev_task/data/github/git_hub_remote_datasource_impl.dart';
import 'package:dev_task/data/github/git_hub_repo_model.dart';

import '../utils/failure.dart';

abstract class GithubRepo {
  Future<Either<Failure, List<GitHubRepoModel>>> getAllPublicRepos(page,
      {bool clearCache = false});
}

class GithubRepoImpl implements GithubRepo {
  List<GitHubRepoModel> repos = [];

  GitHubRemoteDataSource gitHubRemoteDataSource;
  GitHubLocalDataSource gitHubLocalDataSource;
  GithubRepoImpl(
    this.gitHubRemoteDataSource,
    this.gitHubLocalDataSource,
  );
  @override
  Future<Either<Failure, List<GitHubRepoModel>>> getAllPublicRepos(page,
      {bool clearCache = false}) async {
    try {
      clearCache ? gitHubLocalDataSource.clearCache() : null;
      repos = await fillReposFromCache();
      repos = await gitHubRemoteDataSource.getAllPublicRepos(page);
      await gitHubLocalDataSource.cacheRepos(repos);
      repos.forEach((repo) {
        if (repo.isPrivate) {
          repos.remove(repo);
        }
      });

      return right(repos);
    } on Failure catch (failure) {
      return left(failure);
    }
  }

  Future<List<GitHubRepoModel>> fillReposFromCache() async {
    if (repos.isEmpty) {
      List<GitHubRepoModel> cachedRepos =
          await gitHubLocalDataSource.getCachedRepos();

      return cachedRepos;
    } else {
      return repos;
    }
  }
}
