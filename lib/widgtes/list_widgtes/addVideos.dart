import 'package:flutter/material.dart';

class AddVideos extends StatefulWidget {
  const AddVideos({Key? key}) : super(key: key);

  @override
  State<AddVideos> createState() => _AddVideosState();
}

class _AddVideosState extends State<AddVideos> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: ListWidgets(),
    );
  }
}

List<Widget> ListWidgets() {
  const List<Widget> listWidgets = [];
  for (var i = 0; i == 21; i++) {
    listWidgets.add(
      Column(
        children: [
          Row(
            children: [
              Container(
                child: Image.asset(
                  'assets/img/Medidas.jpeg',
                  width: 50,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.delete_forever),
              ),
            ],
          ),
          ElevatedButton(
            style: ButtonStyle(),
            onPressed: () {},
            child: Row(
              children: [Icon(Icons.add), Text('1°Video')],
            ),
          ),
        ],
      ),
    );
  }
  print(listWidgets.length);
  return listWidgets;
}
