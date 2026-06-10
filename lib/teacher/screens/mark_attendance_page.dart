import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherAttendancePage extends StatefulWidget {

  const TeacherAttendancePage({
    super.key,
  });

  @override
  State<TeacherAttendancePage>
  createState() =>
      _TeacherAttendancePageState();
}

class _TeacherAttendancePageState
    extends State<TeacherAttendancePage> {

  String year = "1";

  String department = "CSE";

  String section = "A";

  final years = [
    "1",
    "2",
    "3",
    "4",
  ];

  final departments = [

    "CSE",

    "ECE",

    "EEE",

    "CSM",

    "AIML",

    "BCA",

    "BBA",

    "MBA",
  ];

  final sections = [

    "A",

    "B",

    "C",

    "D",
  ];

  String selectedSubject =
      "DBMS";

  final teacherController =
  TextEditingController(
    text:
    "Madam",
  );

  final searchController =
  TextEditingController();

  Map<String,bool> attendance={};

  @override
  Widget build(
      BuildContext context){

    final isDark =

        Theme.of(context)
            .brightness==

            Brightness.dark;

    return Scaffold(

      backgroundColor:

      isDark

          ? const Color(
        0xFF081120,
      )

          : const Color(
        0xFFF4F8FC,
      ),

      appBar: AppBar(

        leading:

        IconButton(

          icon:
          const Icon(
            Icons.arrow_back,
          ),

          onPressed:(){

            Navigator.pop(
              context,
            );
          },
        ),

        title:
        const Text(
          "Mark Attendance",
        ),

        actions:[

          IconButton(

            onPressed:(){},

            icon:
            const Icon(
              Icons.notifications_none,
            ),
          ),
        ],
      ),

      body:

      Padding(

        padding:
        const EdgeInsets.all(
          20,
        ),

        child:
        Column(

          children:[

            Row(

              children:[

                Expanded(

                  child:

                  DropdownButtonFormField(

                    value:
                    year,

                    decoration:

                    const InputDecoration(

                      labelText:
                      "Year",
                    ),

                    items:

                    years.map(

                          (e)=>

                          DropdownMenuItem(

                            value:e,

                            child:
                            Text(e),
                          ),
                    )

                        .toList(),

                    onChanged:
                        (v){

                      setState(() {

                        year=v!;
                      });
                    },
                  ),
                ),

                const SizedBox(
                  width:10,
                ),

                Expanded(

                  child:

                  DropdownButtonFormField(

                    value:
                    department,

                    decoration:

                    const InputDecoration(

                      labelText:
                      "Department",
                    ),

                    items:

                    departments.map(

                          (e)=>

                          DropdownMenuItem(

                            value:e,

                            child:
                            Text(e),
                          ),
                    )

                        .toList(),

                    onChanged:
                        (v){

                      setState(() {

                        department=v!;
                      });
                    },
                  ),
                ),

                const SizedBox(
                  width:10,
                ),

                Expanded(

                  child:

                  DropdownButtonFormField(

                    value:
                    section,

                    decoration:

                    const InputDecoration(

                      labelText:
                      "Section",
                    ),

                    items:

                    sections.map(

                          (e)=>

                          DropdownMenuItem(

                            value:e,

                            child:
                            Text(e),
                          ),
                    )

                        .toList(),

                    onChanged:
                        (v){

                      setState(() {

                        section=v!;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(
              height:20,
            ),

            Row(

              children:[

                Expanded(

                  child:
                  statsBox(

                    "Present",

                    attendance
                        .values

                        .where(
                            (e)=>

                        e)

                        .length

                        .toString(),

                    Colors.green,
                  ),
                ),

                const SizedBox(
                  width:10,
                ),

                Expanded(

                  child:
                  statsBox(

                    "Absent",

                    attendance
                        .values

                        .where(
                            (e)=>

                        !e)

                        .length

                        .toString(),

                    Colors.red,
                  ),
                ),
              ],
            ),

            DropdownButtonFormField(

              value:
              selectedSubject,

              items:[

                "DBMS",
                "Java Programming",
                "Operating System",
                "Data Structures",

              ].map(

                    (e)=>

                    DropdownMenuItem(

                      value:e,

                      child:
                      Text(e),
                    ),
              ).toList(),

              onChanged:
                  (v){

                setState(() {

                  selectedSubject=
                  v!;
                });
              },
            ),

            const SizedBox(
              height:20,
            ),



            const SizedBox(
              height:20,
            ),

            TextField(

              controller:
              searchController,

              decoration:
              InputDecoration(

                hintText:
                "Search student",

                prefixIcon:
                const Icon(
                  Icons.search,
                ),

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(
                    30,
                  ),
                ),
              ),

              onChanged:(_){

                setState(() {});
              },
            ),

            const SizedBox(
              height:20,
            ),

            Expanded(

              child:

              StreamBuilder<
                  QuerySnapshot>(

                stream:

                FirebaseFirestore
                    .instance

                    .collection(
                    "users")

                    .where(
                    "role",
                    isEqualTo:
                    "student")

                    .where(
                    "year",
                    isEqualTo:
                    year)

                    .where(
                    "department",
                    isEqualTo:
                    department)

                    .where(
                    "section",
                    isEqualTo:
                    section)

                    .snapshots(),

                builder:
                    (
                    context,
                    snapshot,
                    ){

                  if(
                  !snapshot.hasData
                  ){

                    return const Center(

                      child:
                      CircularProgressIndicator(),
                    );
                  }

                  final students =

                      snapshot
                          .data!
                          .docs;

                  return ListView.builder(

                    itemCount:
                    students.length,

                    itemBuilder:
                        (
                        context,
                        index,
                        ){

                      final student =

                      students[
                      index
                      ]

                          .data()

                      as Map<
                          String,
                          dynamic>;

                      final id =

                          students[
                          index
                          ].id;

                      attendance
                          .putIfAbsent(

                        id,

                            ()=>false,
                      );

                      return Card(

                        child:
                        ListTile(

                          leading:
                          CircleAvatar(

                            child:
                            Text(

                              student[
                              "name"
                              ]==null

                                  ?"S"

                                  :student[
                              "name"]

                                  .substring(
                                0,
                                1,
                              ),
                            ),
                          ),

                          title:
                          Text(

                            student[
                            "name"
                            ] ??

                                "Student",
                          ),

                          subtitle:
                          Text(

                            student[
                            "rollNumber"
                            ] ??

                                "",
                          ),

                          trailing:

                          Switch(

                            value:

                            attendance[
                            id] ??
                                false,

                            onChanged:
                                (
                                v
                                ){

                              setState(() {

                                attendance[
                                id]=v;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            SizedBox(

              width:
              double.infinity,

              height:60,

              child:
              ElevatedButton(

                onPressed:
                    () async {

                  int present = 0;

                  int absent = 0;

                  for(
                  var e
                  in attendance.entries
                  ){

                    String uid =
                        e.key;

                    bool isPresent =
                        e.value;

                    final userDoc =

                    await FirebaseFirestore
                        .instance
                        .collection(
                        "users")
                        .doc(uid)
                        .get();

                    final data =

                    userDoc.data()

                    as Map<
                        String,
                        dynamic>;

                    int totalClasses =

                        data[
                        "totalClasses"
                        ] ?? 0;

                    int attendedClasses =

                        data[
                        "attendedClasses"
                        ] ?? 0;

                    totalClasses++;

                    if(
                    isPresent
                    ){

                      present++;

                      attendedClasses++;
                    }

                    else{

                      absent++;
                    }

                    double attendancePercent =

                    totalClasses == 0

                        ?0

                        :

                    (attendedClasses
                        /

                        totalClasses)

                        *100;

                    await FirebaseFirestore
                        .instance
                        .collection(
                        "users")
                        .doc(uid)

                        .update({

                      "attendance":
                      attendancePercent,

                      "totalClasses":
                      totalClasses,

                      "attendedClasses":
                      attendedClasses,
                    });

                    await FirebaseFirestore
                        .instance
                        .collection(
                        "attendance_history")

                        .add({

                      "studentId":
                      uid,

                      "present":
                      isPresent,

                      "day":

                      DateTime.now()
                          .weekday,

                      "date":
                      Timestamp.now(),

                      "subject":
                      selectedSubject,

                      "teacher":

                      teacherController
                          .text,
                    });
                  }

                  if(
                  mounted
                  ){

                    showDialog(

                      context:
                      context,

                      builder:
                          (_){

                        return AlertDialog(

                          title:
                          const Text(
                            "Attendance Saved",
                          ),

                          content:

                          Text(

                            "Present : $present\n\nAbsent : $absent",
                          ),

                          actions:[

                            TextButton(

                              onPressed:(){

                                Navigator.pop(
                                  context,
                                );
                              },

                              child:
                              const Text(
                                "OK",
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },

                child:
                const Text(
                  "Save Attendance",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chip(
      String t,
      String v){

    return Expanded(

      child:
      Card(

        child:
        Padding(

          padding:
          const EdgeInsets.all(
            12,
          ),

          child:
          Column(

            children:[

              Text(t),

              Text(v),
            ],
          ),
        ),
      ),
    );
  }

  Widget statsBox(
      String t,
      String v,
      Color c){

    return Card(

      child:
      Padding(

        padding:
        const EdgeInsets.all(
          20,
        ),

        child:
        Column(

          children:[

            Text(t),

            Text(

              v,

              style:
              TextStyle(

                color:c,

                fontSize:28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}