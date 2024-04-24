import 'dart:io';

import 'package:application/pages/home_page.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  String? titleText;
  String? bodyText;
  late int index;
  final VoidCallback updateFiles;
  DetailPage({super.key, required this.index, this.titleText, this.bodyText, required this.updateFiles});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController titleController;
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.titleText);
    textController = TextEditingController(text: widget.bodyText);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  "Detail Page",
                  style: TextStyle(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                  ),
                ),

                Container(
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: IconButton(
                    onPressed: ()async{

                      showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.grey.shade900,
                            title: const Text('Saved'),
                            titleTextStyle: TextStyle(
                                fontSize: 26,
                                color: Colors.white.withOpacity(0.7)
                            ),
                            content: const Text('Your note has been saved'),
                            contentTextStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withOpacity(0.7)
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: ()async{
                                  final file = File(widget.titleText!);

                                  await file.writeAsString(textController.text);

                                  widget.updateFiles();

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                                        (route) => false,
                                  );
                                },
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 18
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.save,
                      size: 36,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                )
              ],
            ),

            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: titleController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        autofocus: true,
                        style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w500
                        ),
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          hintText: 'Title', // Hint text
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 36,
                              fontWeight: FontWeight.w500
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: textController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        autofocus: true,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400
                        ),
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          hintText: 'Type something...',
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.w300
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
