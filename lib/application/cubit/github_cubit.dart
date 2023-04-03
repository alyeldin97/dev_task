import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dev_task/data/github/git_hub_repo_model.dart';
import 'package:dev_task/repo/github.dart';
import 'package:dev_task/utils/failure.dart';
import 'package:meta/meta.dart';

part 'github_state.dart';

class GithubCubit extends Cubit<GithubState> {
  GithubRepo githubRepo;
  int currentPage = 1;
  String searchValue = '';
  List<GitHubRepoModel> repos = [];
  GithubCubit(this.githubRepo) : super(GithubInitial(repos: []));

  getAllRepos() async {
    emit(GithubGetAllReposLoading(repos: repos));
    Either<Failure, List<GitHubRepoModel>> successOrFailure =
        await githubRepo.getAllPublicRepos(currentPage);

    successOrFailure.fold((failure) {
      emit(GithubGetAllReposFailure(failure: failure, repos: repos));
    }, (repos) {
      this.repos = repos;
      emit(GithubGetAllReposSuccess(repos: repos));
    });
  }

  changeSearchvalue(value) {
    if (value.toString().trim().isNotEmpty) {
      searchValue = value;
      emit(GithubSearchvalueChanged(searchValue: searchValue, repos: repos));
    }
  }

  resetSearchValue() {
    searchValue = '';
  }
}
