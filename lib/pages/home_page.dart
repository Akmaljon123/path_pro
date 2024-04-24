import 'dart:io';
import 'package:application/pages/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Directory directory;
  late TextEditingController fileNameController;
  late TextEditingController textController;
  late List<String> list;
  late List<String> listText;

  @override
  void initState() {
    super.initState();
    fileNameController = TextEditingController();
    textController = TextEditingController();
    list = [];
    listText = [];
    getAllFiles();
  }

  @override
  void dispose() {
    fileNameController.dispose();
    textController.dispose();
    super.dispose();
  }

  Future<String> getLocation() async {
    directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> createFile({required String fileName, required String text}) async {
    final path = await getLocation();
    final file = File("$path/$fileName-${DateTime.now().toIso8601String()}.txt");
    await file.writeAsString(text);
    await getAllFiles();
    fileNameController.clear();
    textController.clear();
  }

  Future<void> getAllFiles() async {
    list = [];
    listText = [];
    await getLocation();
    final files = await directory.list().toList();
    for (var file in files) {
      if (file.path.endsWith('.txt')) {
        list.add(file.path);
        final fileText = await File(file.path).readAsString();
        listText.add(fileText);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onLongPress: (){
                        showDialog(
                          context: context,
                          builder: (context)=>AlertDialog(
                            backgroundColor: Colors.grey.shade900,
                            title: const Text("Are you sure want to delete this note?"),
                            titleTextStyle: const TextStyle(
                              fontSize: 32,
                              color: Colors.white
                            ),
                            content: const Text("You will not be able to recover this file once you delete."),
                            contentTextStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.white
                            ),
                            actionsAlignment: MainAxisAlignment.spaceAround,
                            actions: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.purpleAccent
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text("Cancel"),
                                ),
                              ),

                              GestureDetector(
                                onTap: ()async{
                                  final deletedFile = File(list[index]);
                                  deletedFile.delete();
                                  await getAllFiles();
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: Container(
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.purpleAccent
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text("Delete"),
                                ),
                              )
                            ],
                          )
                        );
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              updateFiles: getAllFiles,
                              index: index,
                              titleText: list[index],
                              bodyText: listText[index],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(list[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.grey.shade900,
              title: const Text("Add a file"),
              titleTextStyle: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white
                      ),
                      controller: fileNameController,
                      decoration: const InputDecoration(
                        hintText: "File name",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      cursorColor: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white
                      ),
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: "Text",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      cursorColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.purpleAccent,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await createFile(
                            fileName: fileNameController.text.trim().toLowerCase(),
                            text: textController.text,
                          );
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.purpleAccent,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
        backgroundColor: Colors.purpleAccent,
        child: Icon(
          Icons.add,
          size: 26,
          color: Colors.grey.shade900,
        ),
      ),
    );
  }
}
