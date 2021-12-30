import 'package:flutter/material.dart';
import '../data/sembast_db.dart';
import './passwords.dart';
import '../models/password.dart';
//Ekraani kasutatakse kaheks toiminguks,
//uue parooliobjekti lisamiseks või olemasoleva redigeerimiseks
//kuvatakse paroolide loendi ekraanilt.
class PasswordDetailDialog extends StatefulWidget {
  final Password password;
  final bool isNew;
//Vaja kahte parameetrit:
//parooliobjekti, mis võib uuena olla tühi, ja tõeväärtust, mis annab teada
//kas peame lisama uue üksuse (tõene või redigeerima olemasolevat, false)
  PasswordDetailDialog(this.password, this.isNew);

  @override
  _PasswordDetailDialogState createState() => _PasswordDetailDialogState();
}

class _PasswordDetailDialogState extends State<PasswordDetailDialog> {
//Kasutame kahte TextEditingControlleri vidinat, lugeda ja kirjutada ekraanile
//kahe TextField vidina sisu.
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    String title = (widget.isNew) ? 'Insert new Password' : 'Edit Password';
    txtName.text = widget.password.name;
    txtPassword.text = widget.password.password;
    return AlertDialog(
      title: Text(title),
      content: Column(
        children: [
          TextField(
            controller: txtName,
            decoration: InputDecoration(
              hintText: 'Description',
            ),
          ),
          TextField(
            controller: txtPassword,
            obscureText: hidePassword,
            decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: hidePassword
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off))),
          ),
        ],
      ),
      actions: [
        FlatButton(
          child: Text('Save'),
          onPressed: () {
            widget.password.name = txtName.text;
            widget.password.password = txtPassword.text;
            SembastDb db = SembastDb();
            (widget.isNew)
                ? db.addPassword(widget.password)
                : db.updatePassword(widget.password);

            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PasswordsScreen()));
          },
        ),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel')),
      ],
    );
  }
}
