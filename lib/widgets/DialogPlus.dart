import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum DialogType {
  alert,
  confirm,
}

class DialogPlus extends StatelessWidget {
  final DialogType type;
  final String title, messages, okName, cancelName;
  final Function ok, cancel;

  DialogPlus({
    Key key,
    this.type = DialogType.alert,
    this.title = "",
    this.messages = "",
    this.okName = "确定",
    this.cancelName = "取消",
    this.ok,
    this.cancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [
      CupertinoDialogAction(
        child: Text(okName),
        onPressed: () {
          Navigator.of(context).pop(true);
          if (ok != null) {
            ok();
          }
        },
      )
    ];
    if (type == DialogType.confirm) {
      actions.insert(
        0,
        CupertinoDialogAction(
          child: Text(cancelName),
          onPressed: () {
            Navigator.of(context).pop(false);
            if (ok != null) {
              ok();
            }
          },
        ),
      );
    }

    return CupertinoAlertDialog(
      title: title != '' ? Text(title, style: TextStyle(fontSize: 15)) : Container(),
      content: Text(messages),
      actions: actions,
    );
  }
}

Future<T> showDialogConfirm<T>({
  @required BuildContext context,
  String title = "",
  String messages = "",
  String okName = "确定",
  String cancelName = "取消",
  Function ok,
  Function cancel,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return DialogPlus(
        type: DialogType.confirm,
        title: title,
        messages: messages,
        okName: okName,
        cancelName: cancelName,
        ok: ok,
      );
    },
  );
}

showDialogAlert({
  @required BuildContext context,
  String title = "",
  String messages = "",
  String okName = "确定",
  Function ok,
  Function cancel,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return DialogPlus(
        type: DialogType.alert,
        title: title,
        messages: messages,
        okName: okName,
        ok: ok,
      );
    },
  );
}
