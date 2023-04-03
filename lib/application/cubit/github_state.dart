part of 'github_cubit.dart';

@immutable
abstract class GithubState {
  List<GitHubRepoModel> repos;
  GithubState({
    required this.repos,
  });
}

class GithubInitial extends GithubState {
  GithubInitial({required super.repos});
}

class GithubSearchvalueChanged extends GithubState {
  String searchValue;
  GithubSearchvalueChanged({required this.searchValue, required super.repos});
}

class GithubGetAllReposLoading extends GithubState {
  GithubGetAllReposLoading({required super.repos});
}

class GithubGetAllReposSuccess extends GithubState {
  GithubGetAllReposSuccess({
    required super.repos,
  });
}

class GithubGetAllReposFailure extends GithubState {
  Failure failure;
  GithubGetAllReposFailure({
    required this.failure,
    required super.repos,
  });
}
