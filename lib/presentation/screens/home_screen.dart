import 'package:dev_task/application/cubit/github_cubit.dart';
import 'package:dev_task/data/github/git_hub_remote_datasource_impl.dart';
import 'package:dev_task/data/github/git_hub_repo_model.dart';
import 'package:dev_task/presentation/screens/webview.dart';
import 'package:dev_task/repo/github.dart';
import 'package:dev_task/utils/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late GithubCubit githubCubit;
    TextEditingController controller = TextEditingController();
    return BlocProvider(
      create: (context) => GithubCubit(
          GithubRepoImpl(GitHubRemoteDataSourceImpl(HttpNetworkServiceImpl())))
        ..getAllRepos(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Repos'),
        ),
        body: BlocBuilder<GithubCubit, GithubState>(builder: (context, state) {
          githubCubit = BlocProvider.of<GithubCubit>(context);

          bool isSuccess = state is GithubGetAllReposSuccess ||
              state is GithubSearchvalueChanged;
          bool isLoading = state is GithubGetAllReposLoading;
          bool isFailure = state is GithubGetAllReposFailure;
          return isLoading
              ? Center(child: CircularProgressIndicator())
              : isFailure
                  ? Center(child: Text(state.failure.message))
                  : isSuccess
                      ? RefreshIndicator(
                          onRefresh: () async {
                            githubCubit.getAllRepos();
                            controller.text = '';
                            githubCubit.resetSearchValue();
                          },
                          child: Column(
                            children: [
                              TextFormField(
                                controller: controller,
                                decoration:
                                    InputDecoration(hintText: 'Type Something'),
                                onChanged: (value) {
                                  githubCubit.changeSearchvalue(value);
                                },
                              ),
                              Container(
                                height: 650,
                                child: ListView.builder(
                                  itemCount: state.repos.length,
                                  itemBuilder: (context, index) {
                                    GitHubRepoModel repo = state.repos[index];
                                    return repo.name.toLowerCase().contains(
                                                githubCubit.searchValue
                                                    .toLowerCase()) ||
                                            githubCubit.searchValue == ''
                                        ? GestureDetector(
                                            onLongPress: () {
                                              showAlertDialog(context, repo);
                                            },
                                            child: Container(
                                              width: 200,
                                              height: 300,
                                              color: repo.isForked
                                                  ? Colors.white
                                                  : Colors.greenAccent,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(repo.name),
                                                  Text(repo.description),
                                                  Text(repo.authorName),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container();
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container();
        }),
      ),
    );
  }

  showAlertDialog(BuildContext context, GitHubRepoModel repo) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Repo Page"),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AppWebView(url: repo.repoUrl);
        }));
      },
    );
    Widget continueButton = TextButton(
      child: Text("Owner Page"),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AppWebView(url: repo.ownerUrl);
        }));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text(
          "Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
