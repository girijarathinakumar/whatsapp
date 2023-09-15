import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/data_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DataModel> _searchData = [];
  List<DataModel> _getData = [];
  final List<String> _profileImages = [
    "assets/img/boy.jpg",
    "assets/img/boy1.jpg",
    "assets/img/boy2.jpg",
    "assets/img/boy3.jpg",
    "assets/img/girl.jpg",
    "assets/img/girl2.jpg",
    "assets/img/girl3.jpg",
    "assets/img/girl4.jpg",
    "assets/img/girl5.jpg",
    "assets/img/girl6.jpg"
  ];

  Future<List<DataModel>> getResponse() async {
    String url = "https://jsonplaceholder.typicode.com/todos";
    final response = await http.get(Uri.parse(url));

    print('fffffffff');

    var responseData = json.decode(response.body);
    List<DataModel> dataInfo = [];
    var random = Random();
    for (var data in responseData) {
      print(responseData);
      DataModel model = DataModel(
          id: data["id"],
          title: data["title"],
          completed: data["completed"],
          profileUrl: _profileImages[random.nextInt(9)]);
      dataInfo.add(model);
    }
    dev.log("response=====${responseData}");
    setState(() {
      _getData = dataInfo;
      _searchData = List.from(_getData);
    });
    return dataInfo;
  }

  void search(String title) {
    setState(() {
      _searchData = _getData
          .where((element) =>
              element.title.toLowerCase().contains(title.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    getResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Edit",
                        style:
                            TextStyle(color: Color(0xff0d47a1), fontSize: 15),
                      ),
                      Icon(
                        Icons.edit_note_rounded,
                        color: Color(0xff0d47a1),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Chats",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    width: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.grey.withOpacity(0.8),
                            ),
                          ),
                          Expanded(
                              child: TextField(
                            onChanged: (value) {
                              search(value.toString());
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration.collapsed(
                              hintText: "Search",
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.8)),
                            ),
                            cursorColor: Colors.grey,
                            cursorHeight: 20,
                          ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Broadcast Lists",
                        style:
                            TextStyle(color: Color(0xff0d47a1), fontSize: 15),
                      ),
                      Text(
                        "New Group",
                        style:
                            TextStyle(color: Color(0xff0d47a1), fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                      indent: 1.0,
                      endIndent: 1.0,
                      color: Colors.grey.withOpacity(0.4)),
                  Expanded(
                    child: ListView.separated(
                        separatorBuilder: (ctx, index) => Divider(
                            indent: 5.0,
                            endIndent: 5.0,
                            color: Colors.grey.withOpacity(0.4)),
                        itemCount: _searchData.length,
                        itemBuilder: (ctx, index) {
                          return ListTile(
                            leading: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        _searchData[index].profileUrl),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                            title: Text(
                              "${_searchData[index].id}",
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(_searchData[index].title,
                                style: const TextStyle(color: Colors.grey)),
                            trailing: Text("${_searchData[index].completed}",
                                style: const TextStyle(color: Colors.grey)),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}
