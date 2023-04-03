import 'package:dev_task/presentation/screens/webview.dart';
import 'package:flutter/material.dart';

import '../../data/github/git_hub_repo_model.dart';

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
    content:
        Text("Would you like to continue learning how to use Flutter alerts?"),
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
