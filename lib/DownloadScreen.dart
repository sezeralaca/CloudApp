import 'storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'firebase_api.dart';
import 'firebase_file.dart';
import 'image_page.dart';

//Where the magic happens

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  late Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();

    futureFiles = FirebaseApi.listAll('test/');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: const Text('Cloud App Demo'),
            centerTitle: true,
            actions: [
              //Popup Menu Button for Upload File section
              PopupMenuButton<int>(
                onSelected: (item) => onSelected(context, item),
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: const [
                        Icon(
                          Icons.upload,
                          color: Colors.black,
                        ),
                        Text('Upload File'),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
        body: FutureBuilder<List<FirebaseFile>>(
          future: futureFiles,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:

                //Print Errors
                if (snapshot.hasError) {
                  return const Center(child: Text('Some error occurred!'));
                } else {
                  final files = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeader(files.length),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            final file = files[index];

                            return buildFile(context, file);
                          },
                        ),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      );

//List of images

  Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
        leading: ClipOval(
          child: Image.network(
            file.url,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          file.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ImagePage(file: file),
        )),
      );
  Widget buildHeader(int length) => ListTile(
        tileColor: Colors.blue,
        leading: Container(
          width: 52,
          height: 52,
          child: const Icon(
            Icons.file_copy,
            color: Colors.white,
          ),
        ),
        title: Text(
          '$length Files',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );
  Future<void> onSelected(BuildContext context, int item) async {
    switch (item) {
      case 0:

        //File Picker
        final results = await FilePicker.platform.pickFiles(
          allowMultiple: false, //One image per upload
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg'], //Which file types are allowed
        );

        //Select image = none, Prints No file selectes
        if (results == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No File Selected'),
            ),
          );
          return;
        }
        //Upload Success
        final path = results.files.single.path!;
        final fileName = results.files.single.name;
        final Storage storage = Storage();
        storage.uploadFile(path, fileName).then((value) => print('Done!'));
        {}
        break;
    }
  }
}
