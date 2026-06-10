import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherMarksPage extends StatefulWidget {

  const TeacherMarksPage({super.key});

  @override
  State<TeacherMarksPage> createState() =>
      _TeacherMarksPageState();
}

class _TeacherMarksPageState
    extends State<TeacherMarksPage>{

  String year="1";

  String department="CSE";

  String section="A";

  String semester="1";

  String exam="Mid 1";

  String subject="";

  bool loading=false;

  List<DocumentSnapshot> students=[];

  final subjectController=
  TextEditingController();

  Map<String,
      TextEditingController>
  marksControllers={};

  final exams=[

    "Mid 1",
    "Mid 2",
    "Sem External 1",
    "Sem External 2",
    "Lab Internal 1",
    "Lab Internal 2",
    "Lab External",
  ];

  Future<void>
  searchStudents() async{

    setState(() {

      loading=true;
    });

    final data=

    await FirebaseFirestore
        .instance
        .collection(
      "users",
    )

        .where(
      "role",
      isEqualTo:
      "student",
    )

        .where(
      "year",
      isEqualTo:
      year,
    )

        .where(
      "department",
      isEqualTo:
      department,
    )

        .where(
      "section",
      isEqualTo:
      section,
    )

        .where(
      "semester",
      isEqualTo:
      int.parse(
        semester,
      ),
    )

        .get();

    setState(() {

      students=
          data.docs;

      loading=false;
    });
  }

  @override
  Widget build(
      BuildContext context){

    final isDark=

        Theme.of(context)
            .brightness==

            Brightness.dark;

    return Scaffold(

      backgroundColor:

      isDark

          ? const Color(
        0xFF07111F,
      )

          : const Color(
        0xFFF4F8FC,
      ),

      appBar:AppBar(

        backgroundColor:
        Colors.transparent,

        elevation:0,

        title:
        const Text(
          "Upload Marks",
        ),
      ),

      body:

      Padding(

        padding:
        const EdgeInsets.all(
          18,
        ),

        child:
        Column(

          children:[

            glass(

              isDark,

              Wrap(

                spacing:12,

                runSpacing:12,

                children:[

                  drop(
                      year,
                      [
                        "1","2","3","4"
                      ],

                          (v){

                        setState(() {

                          year=v!;
                        });
                      }
                  ),

                  drop(
                      department,

                      [

                        "CSE",
                        "CSM",
                        "AIML",
                        "ECE",
                        "EEE"
                      ],

                          (v){

                        setState(() {

                          department=v!;
                        });
                      }
                  ),

                  drop(
                      section,

                      [

                        "A",
                        "B",
                        "C",
                        "D"
                      ],

                          (v){

                        setState(() {

                          section=v!;
                        });
                      }
                  ),

                  drop(
                      semester,

                      [

                        "1","2","3","4",
                        "5","6","7","8"
                      ],

                          (v){

                        setState(() {

                          semester=v!;
                        });
                      }
                  ),
                ],
              ),
            ),

            const SizedBox(
              height:15,
            ),

            glass(

              isDark,

              TextField(

                controller:
                subjectController,

                decoration:
                const InputDecoration(

                  hintText:
                  "Subject",

                  prefixIcon:
                  Icon(
                    Icons.book,
                  ),

                  border:
                  InputBorder.none,
                ),
              ),
            ),

            const SizedBox(
              height:15,
            ),

            DropdownButtonFormField(

              value:exam,

              items:

              exams.map(

                    (e)=>

                    DropdownMenuItem(

                      value:e,

                      child:
                      Text(e),
                    ),
              ).toList(),

              onChanged:(v){

                exam=v!;
              },
            ),

            const SizedBox(
              height:15,
            ),

            SizedBox(

              width:
              double.infinity,

              child:

              ElevatedButton.icon(

                icon:
                const Icon(
                  Icons.search,
                ),

                label:
                const Text(
                  "Search Students",
                ),

                onPressed:
                searchStudents,
              ),
            ),

            const SizedBox(
              height:20,
            ),

            Expanded(

              child:

              loading

                  ?

              const Center(
                child:
                CircularProgressIndicator(),
              )

                  :

              students.isEmpty

                  ?

              const Center(

                child:
                Text(
                  "No Students Found",
                ),
              )

                  :

              ListView.builder(

                itemCount:
                students.length,

                itemBuilder:
                    (
                    c,
                    i
                    ){

                  final student=

                  students[i]
                      .data()

                  as Map<
                      String,
                      dynamic>;

                  final uid=
                      students[i].id;

                  marksControllers.putIfAbsent(

                    uid,

                        ()=>TextEditingController(),
                  );

                  return studentCard(

                    student,

                    uid,

                    isDark,
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton:

      FloatingActionButton.extended(

        onPressed:
            () async{

          for(

          var e

          in marksControllers
              .entries

          ){

            await FirebaseFirestore
                .instance

                .collection(
              "student_marks",
            )

                .doc(
              e.key,
            )

                .set({

              "year":
              year,

              "department":
              department,

              "section":
              section,

              "semester":

              int.parse(
                semester,
              ),

              "subject":

              subjectController
                  .text,

              exam:

              e.value.text,

            },

              SetOptions(
                merge:true,
              ),
            );
          }
        },

        label:
        Text(
          "Save $exam",
        ),
      ),
    );
  }

  Widget glass(
      bool dark,
      Widget child){

    return ClipRRect(

      borderRadius:
      BorderRadius.circular(
        25,
      ),

      child:
      BackdropFilter(

        filter:
        ImageFilter.blur(

          sigmaX:20,

          sigmaY:20,
        ),

        child:
        Container(

          padding:
          const EdgeInsets.all(
            15,
          ),

          decoration:
          BoxDecoration(

            color:

            dark

                ?

            Colors.white
                .withOpacity(
              .08,
            )

                :

            Colors.white
                .withOpacity(
              .7,
            ),
          ),

          child:
          child,
        ),
      ),
    );
  }

  Widget studentCard(
      Map s,
      String uid,
      bool dark){

    return glass(

      dark,

      ListTile(

        leading:

        CircleAvatar(

          child:
          Text(
            s["name"][0],
          ),
        ),

        title:
        Text(
          s["name"],
        ),

        subtitle:
        Text(

          s["rollNumber"]
              ??"",
        ),

        trailing:

        SizedBox(

          width:90,

          child:
          TextField(

            controller:
            marksControllers[
            uid
            ],

            keyboardType:
            TextInputType.number,
          ),
        ),
      ),
    );
  }

  Widget drop(
      String value,

      List<String> items,

      Function(String?)
      f){

    return DropdownButton(

      value:value,

      items:

      items.map(

            (e)=>

            DropdownMenuItem(

              value:e,

              child:
              Text(e),
            ),
      ).toList(),

      onChanged:f,
    );
  }
}