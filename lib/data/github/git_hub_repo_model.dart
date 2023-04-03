import 'package:dev_task/constants/json_keys.dart';
import 'package:dev_task/utils/null_checkers.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class GitHubRepoModel extends Equatable {
  int id;
  String name;
  String description;
  String authorName;
  String repoUrl;
  String ownerUrl;
  bool isPrivate;
  bool isForked;

  GitHubRepoModel({
    required this.id,
    required this.name,
    required this.description,
    required this.authorName,
    required this.isPrivate,
    required this.isForked,
    required this.repoUrl,
    required this.ownerUrl,
  });

  static GitHubRepoModel fromJson(Map<dynamic, dynamic> json) {
    int? id = json[Jsonkey.id] as int?;
    String? name = json[Jsonkey.name] as String?;
    String? description = json[Jsonkey.description] as String?;
    String? repoUrl = json[Jsonkey.htmlUrl] as String?;
    String? ownerrUrl = json[Jsonkey.owner][Jsonkey.htmlUrl] as String?;
    bool? isPrivate = json[Jsonkey.private] as bool?;
    bool? isForked = json[Jsonkey.fork] as bool?;
    String? authorName = json[Jsonkey.owner][Jsonkey.login] as String?;

    return GitHubRepoModel(
      id: id.ifNullReturn(-1),
      name: name.ifNullOrEmptyReturn('Un Named'),
      description: description.ifNullOrEmptyReturn('no description found'),
      authorName: authorName.ifNullOrEmptyReturn('UnKnown Author'),
      isPrivate: isPrivate.ifNullReturn(false),
      isForked: isForked.ifNullReturn(false),
      repoUrl: repoUrl.ifNullOrEmptyReturn(''),
      ownerUrl: ownerrUrl.ifNullOrEmptyReturn(''),
    );
  }

  toJson() {
    return {
      Jsonkey.id: id,
      Jsonkey.name: name,
      Jsonkey.description: description,
      Jsonkey.private: isPrivate,
      Jsonkey.fork: isForked,
      Jsonkey.htmlUrl: repoUrl,
      Jsonkey.owner: {Jsonkey.login: authorName, Jsonkey.htmlUrl: ownerUrl}
    };
  }

  @override
  List<Object?> get props => [id];
}
