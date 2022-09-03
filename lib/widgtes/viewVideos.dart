import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ta_pago/login/login.dart';
import 'package:ta_pago/service/auth_service.dart';

class ViewVideos extends StatefulWidget {
  const ViewVideos({Key? key}) : super(key: key);

  @override
  State<ViewVideos> createState() => _ViewVideosState();
}

class _ViewVideosState extends State<ViewVideos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Row(
            children: [
              Text('Sair', textDirection: TextDirection.rtl),
              IconButton(
                onPressed: () {
                  exitApp();
                },
                icon: Icon(Icons.exit_to_app),
              ),
            ],
          ),
        ],
      ),
      body: Container(),
    );
  }

  exitApp() {
    Provider.of<AuthService>(context, listen: false).logout();
    Navigator.pop(context);
  }
}
