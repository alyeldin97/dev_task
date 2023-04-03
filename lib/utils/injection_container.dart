import 'package:dev_task/application/cubit/github_cubit.dart';
import 'package:dev_task/constants/hive_keys.dart';
import 'package:dev_task/data/github/git_hub_local_datasource.dart';
import 'package:dev_task/data/github/git_hub_remote_datasource_impl.dart';
import 'package:dev_task/repo/github.dart';
import 'package:dev_task/utils/hive_helper.dart';
import 'package:dev_task/utils/network_service.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> initGetIt() async {
  //^Helpers
  sl.registerFactory<HiveHelper>(() => HiveHelper(HiveKeys.githubRepo));
  sl.registerFactory<NetWorkService>(() => HttpNetworkServiceImpl());

  //^Local DataSources
  sl.registerFactory<GitHubLocalDataSource>(
      () => GitHubLocalDataSourceImpl(sl()));

  //^Remote DataSources
  sl.registerFactory<GitHubRemoteDataSource>(
      () => GitHubRemoteDataSourceImpl(sl()));
  //^Repos
  sl.registerFactory<GithubRepo>(() => GithubRepoImpl(sl(), sl()));
  //^Cubits
  sl.registerFactory<GithubCubit>(() => GithubCubit(sl()));
}
