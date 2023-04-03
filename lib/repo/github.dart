import 'package:dartz/dartz.dart';

import 'package:dev_task/data/github/git_hub_remote_datasource_impl.dart';
import 'package:dev_task/data/github/git_hub_repo_model.dart';

import '../utils/failure.dart';

abstract class GithubRepo {
  Future<Either<Failure, List<GitHubRepoModel>>> getAllPublicRepos(page);
}

class GithubRepoImpl implements GithubRepo {
  GitHubRemoteDataSource gitHubRemoteDataSource;
  GithubRepoImpl(
    this.gitHubRemoteDataSource,
  );
  @override
  Future<Either<Failure, List<GitHubRepoModel>>> getAllPublicRepos(page) async {
    try {
      List<GitHubRepoModel> repos =
          await gitHubRemoteDataSource.getAllPublicRepos(page);
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
}
