import 'package:another_flushbar/flushbar_helper.dart';
import 'package:dev_task/application/cubit/github_cubit.dart';
import 'package:dev_task/constants/hive_keys.dart';
import 'package:dev_task/data/github/git_hub_local_datasource.dart';
import 'package:dev_task/data/github/git_hub_remote_datasource_impl.dart';
import 'package:dev_task/data/github/git_hub_repo_model.dart';
import 'package:dev_task/repo/github.dart';
import 'package:dev_task/utils/hive_helper.dart';
import 'package:dev_task/utils/network_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late GithubCubit githubCubit;
    TextEditingController controller = TextEditingController();
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        githubCubit.nextPage();
        githubCubit.getAllRepos();
      }
    });
    return BlocProvider(
      create: (context) => GithubCubit(GithubRepoImpl(
          GitHubRemoteDataSourceImpl(HttpNetworkServiceImpl()),
          GitHubLocalDataSourceImpl(HiveHelper(HiveKeys.githubRepo))))
        ..getAllRepos(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Repos'),
        ),
        body: BlocListener<GithubCubit, GithubState>(
          listener: (context, state) {
            bool isFailure = state is GithubGetAllReposFailure;
            if (isFailure) {
              FlushbarHelper.createError(message: state.failure.message)
                  .show(context);
            }
          },
          child:
              BlocBuilder<GithubCubit, GithubState>(builder: (context, state) {
            githubCubit = BlocProvider.of<GithubCubit>(context);

            bool isSuccess = state is GithubGetAllReposSuccess ||
                state is GithubSearchvalueChanged;
            bool isLoading = state is GithubGetAllReposLoading;

            return isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async {
                      githubCubit.clearCache();
                      githubCubit.getAllRepos(clearCache: true);
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
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: scrollController,
                            itemCount: state.repos.length,
                            itemBuilder: (context, index) {
                              GitHubRepoModel repo = state.repos[index];

                              if (index == state.repos.length - 1) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

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
                  );
          }),
        ),
      ),
    );
  }
}
