import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
class TeacherMaterialUploadPage
    extends StatefulWidget {

  const TeacherMaterialUploadPage({
    super.key,
  });

  @override
  State<TeacherMaterialUploadPage>
  createState() =>
      _TeacherMaterialUploadPageState();
}

class _TeacherMaterialUploadPageState
    extends State<TeacherMaterialUploadPage> {

  final TextEditingController
  titleController =
  TextEditingController();
  String teacherName = "";
  String teacherId = "";

  String selectedYear =
      "1st Year";

  String selectedDepartment =
      "CSE";

  String selectedSection = "A";
  File? selectedFile;

  String fileType="FILE";

  String fileSize="";
  bool isUploading = false;
  @override
  void initState() {
    super.initState();
    loadTeacherName();
  }
  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }
  Future<void> loadTeacherName() async {

    final email = FirebaseAuth.instance.currentUser?.email;

    if (email == null) return;

    final query = await FirebaseFirestore.instance
        .collection("teachers")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {

      setState(() {

        teacherName = query.docs.first["name"] ?? "Teacher";

        teacherId = query.docs.first["id"] ?? "";

      });

    } else {

      setState(() {

        teacherName = "Teacher";

        teacherId = "";

      });

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
        const Text(
          "Upload Materials",
        ),
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            TextField(
              controller:
              titleController,

              decoration:
              const InputDecoration(
                labelText:
                "Material Title",
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(

              onPressed: () async {

                final result=

                await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: [
                    'pdf',
                    'ppt',
                    'pptx',
                    'doc',
                    'docx',
                  ],
                );

                if(result!=null){
                  if (result.files.first.size > 50 * 1024 * 1024) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Maximum file size is 50 MB"),
                      ),
                    );
                    return;
                  }

                  selectedFile=

                      File(
                        result.files
                            .first.path!,
                      );

                  fileType=

                      result.files
                          .first.extension
                          ?.toUpperCase()

                          ?? "FILE";

                  fileSize=

                  "${(result.files.first.size/1024/1024).toStringAsFixed(1)} MB";

                  setState(() {});
                }
              },

              icon: const Icon(
                Icons.upload_file,
              ),

              label:

              Text(

                selectedFile==null

                    ?

                "Upload PDF / PPT"

                    :

                selectedFile!
                    .path
                    .split("/")
                    .last,
              ),
            ),

            const SizedBox(height: 25),

            DropdownButton<String>(

              value: selectedYear,

              isExpanded: true,

              items: [

                "1st Year",
                "2nd Year",
                "3rd Year",
                "4th Year"
              ]
                  .map(
                    (year) =>
                    DropdownMenuItem(
                      value: year,
                      child:
                      Text(year),
                    ),
              )
                  .toList(),

              onChanged: (value) {

                setState(() {

                  selectedYear =
                  value!;
                });
              },
            ),

            const SizedBox(height: 20),

            DropdownButton<String>(

              value:
              selectedDepartment,

              isExpanded: true,

              items: [

                "CSE",
                "AIML",
                "CSM",
                "ECE",
                "EEE"
              ]
                  .map(
                    (dept) =>
                    DropdownMenuItem(
                      value: dept,
                      child:
                      Text(dept),
                    ),
              )
                  .toList(),

              onChanged: (value) {

                setState(() {

                  selectedDepartment =
                  value!;
                });
              },
            ),

            const SizedBox(height: 20),

            DropdownButton<String>(

              value:
              selectedSection,

              isExpanded: true,

              items: [
                "A",
                "B",
                "C",
                "D"
              ]
                  .map(
                    (section) =>
                    DropdownMenuItem(
                      value:
                      section,
                      child:
                      Text(section),
                    ),
              )
                  .toList(),

              onChanged: (value) {

                setState(() {

                  selectedSection =
                  value!;
                });
              },
            ),

            const SizedBox(height: 40),

            SizedBox(

              width:
              double.infinity,

              height: 55,

              child: ElevatedButton(

                onPressed: () async {

                  if (titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter material title"),
                      ),
                    );
                    return;
                  }

                  if (selectedFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select a file"),
                      ),
                    );
                    return;
                  }
                  if (isUploading) return;

                  setState(() {
                    isUploading = true;
                  });

                  try {
                    final supabase = Supabase.instance.client;

                    final uid = FirebaseAuth.instance.currentUser!.uid;

                    final fileName =
                        "$uid/${DateTime.now().millisecondsSinceEpoch}_${selectedFile!.path.split('/').last}";
                    await supabase.storage
                        .from('study-materials')
                        .upload(fileName, selectedFile!);

                    final String url = supabase.storage
                        .from('study-materials')
                        .getPublicUrl(fileName);

                    await FirebaseFirestore.instance
                        .collection("study_materials")
                        .add({

                      "title": titleController.text.trim(),
                      "teacherId": teacherId,

                      "teacher": teacherName,

                      "fileUrl": url,
                      "fileName": selectedFile!.path.split('/').last,

                      "fileType": fileType,

                      "fileSize": fileSize,

                      "year": selectedYear.replaceAll(" Year", ""),

                      "department": selectedDepartment,

                      "section": selectedSection,

                      "uploadedAt": Timestamp.now(),

                    });

                    titleController.clear();

                    setState(() {
                      selectedFile = null;
                      fileType = "FILE";
                      fileSize = "";
                      isUploading = false;
                    });


                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Material Uploaded Successfully",
                          ),
                        ),
                      );
                    }

                  } catch (e) {
                    setState(() {
                      isUploading = false;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  };


                },

                child: isUploading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "Upload Material",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}