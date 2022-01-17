import 'package:logintest/storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

//Upload yaptığımız eski ekran, şu an kullanılmıyor

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud'),
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) => onSelected(context, item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    Text('Sign out'),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    Icon(
                      Icons.nightlight_outlined,
                      color: Colors.black,
                    ),
                    Text('Dark Mode Go Brr'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: Column(
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final results = await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: ['png', 'jpg'],
                    );
                    if (results == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('No File Selected'),
                        ),
                      );
                      return null;
                    }
                    final path = results.files.single.path!;
                    final fileName = results.files.single.name;

                    storage
                        .uploadFile(path, fileName)
                        .then((value) => print('Done!'));
                  },
                  child: const Text('Upload File'),
                ),
              ),
              FutureBuilder(
                future: storage.listFiles(),
                builder: (BuildContext context,
                    AsyncSnapshot<firebase_storage.ListResult> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 50,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.items.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text(snapshot.data!.items[index].name),
                              ),
                            );
                          }),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Container();
                },
              ),
              FutureBuilder(
                  //future: storage.downloadURL('MaM Sense.png'), //Bunu buton clicklendiğinde butonun ismine göre değiştirebilir yapmamız lazım
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Container(
                      width: 300,
                      height: 250,
                      child: Image.network(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ));
                }
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Container();
              })
            ],
          )),
    );
  }

  Future<void> onSelected(BuildContext context, int item) async {
    switch (item) {
      case 0:
        final results = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg'],
        );
        if (results == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No File Selected'),
            ),
          );
          return null;
        }
        final path = results.files.single.path!;
        final fileName = results.files.single.name;
        final Storage storage = Storage();
        storage.uploadFile(path, fileName).then((value) => print('Done!'));
        ;
        break;
    }
  }
}
