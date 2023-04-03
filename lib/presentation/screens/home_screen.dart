import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cron/cron.dart';
import 'package:dev_task/application/cubit/github_cubit.dart';
import 'package:dev_task/data/github/git_hub_repo_model.dart';
import 'package:dev_task/utils/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GithubCubit githubCubit;
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  final cron = Cron();

  @override
  void initState() {
    updateCacheInBackGround();
    loadMoreReposOnScroll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GithubCubit>()..getAllRepos(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Repos'),
        ),
        body: BlocListener<GithubCubit, GithubState>(
          listener: (context, state) {
            bool isFailure = state is GithubGetAllReposFailure;
            bool cacheUpdated = state is GithubCacheUpdated;
            if (isFailure) {
              FlushbarHelper.createError(message: state.failure.message)
                  .show(context);
            } else if (cacheUpdated) {
              FlushbarHelper.createSuccess(
                      message:
                          'Added ${state.numberOfUnCachedRepos} More Repos')
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

                              if (index == state.repos.length - 1 &&
                                  controller.text == '') {
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

  updateCacheInBackGround() {
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      githubCubit.updateCache();
    });
  }

  loadMoreReposOnScroll() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        githubCubit.nextPage();
        githubCubit.getAllRepos();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    cron.close();
    super.dispose();
  }
}
