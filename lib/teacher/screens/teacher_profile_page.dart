import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../main.dart';
import '../../role_selection_page.dart';

class TeacherProfilePage
    extends StatefulWidget {

  const TeacherProfilePage({
    super.key,
  });

  @override

  State<TeacherProfilePage>
  createState() =>
      _TeacherProfilePageState();
}

class _TeacherProfilePageState
    extends State<TeacherProfilePage> {

  final phoneController =
  TextEditingController();

  final qualificationController =
  TextEditingController();

  final designationController =
  TextEditingController();

  final experienceController =
  TextEditingController();

  final bioController =
  TextEditingController();

  File? profileImage;

  @override
  void dispose() {
    phoneController.dispose();
    qualificationController.dispose();
    designationController.dispose();
    experienceController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      backgroundColor:
      isDark
          ? const Color(0xFF081120)
          : const Color(0xFFF4F8FC),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(20),

          child: Column(

            children: [

              /// TOP
              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  Text(
                    "Profile",

                    style: TextStyle(
                      fontSize: 34,
                      fontWeight:
                      FontWeight.bold,

                      color:
                      isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),

                  Row(

                    children: [

                      glassIcon(

                        icon:
                        isDark
                            ? Icons.light_mode
                            : Icons.dark_mode,

                        onTap: () {

                          EduMateApp.of(
                            context,
                          )?.toggleTheme();
                        },
                      ),

                      const SizedBox(width: 12),

                      glassIcon(
                        icon:
                        Icons.notifications_none,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// PROFILE CARD
              /// PROFILE CARD
              glassCard(

                isDark: isDark,

                child: Column(

                  children: [



                    StreamBuilder<DocumentSnapshot>(

                      stream:

                      FirebaseFirestore
                          .instance

                          .collection(
                        "teachers",
                      )

                          .doc(

                        FirebaseAuth
                            .instance
                            .currentUser!
                            .uid,
                      )

                          .snapshots(),

                      builder:(

                          context,

                          snapshot,
                          ){

                        if(
                        !snapshot.hasData

                            ||

                            !snapshot.data!.exists
                        ){

                          return const Text(
                            "Loading...",
                          );
                        }

                        final data =

                        snapshot.data!;
                        final name = data["name"].toString();

                        return Column(

                          children:[

                            CircleAvatar(

                              radius:50,

                              backgroundColor:
                              Colors.blue,

                              backgroundImage:

                              data["photoUrl"] != null &&
                                  data["photoUrl"].toString().isNotEmpty
                                  ?

                              NetworkImage(
                                data["photoUrl"],
                              )

                                  : null,

                              child: data["photoUrl"] == null ||
                                  data["photoUrl"].toString().isEmpty
                                  ?

                              Text(
                                (name.length >= 2
                                    ? name.substring(0, 2)
                                    : name)
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                ),
                              )




                                  : null,
                            ),

                            const SizedBox(
                              height:18,
                            ),

                            Text(

                              data["name"],

                              style:

                              TextStyle(

                                fontSize:28,

                                fontWeight:
                                FontWeight.bold,

                                color:

                                isDark

                                    ?

                                Colors.white

                                    :

                                Colors.black,
                              ),
                            ),

                            const SizedBox(
                              height:6,
                            ),

                            Text(

                              data["department"],

                              style:

                              TextStyle(

                                color:

                                isDark

                                    ?

                                Colors.white70

                                    :

                                Colors.black54,
                              ),
                            ),

                            const SizedBox(
                              height:18,
                            ),

                            Row(

                              mainAxisAlignment:
                              MainAxisAlignment.center,

                              children:[

                                badge(
                                  (data["experience"]?.toString().isNotEmpty ?? false)
                                      ? data["experience"].toString()
                                      : "No Experience",
                                  Colors.orange,
                                ),

                                const SizedBox(
                                  width:12,
                                ),

                                badge(
                                  "Teacher",
                                  Colors.green,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              /// SETTINGS
              glassCard(

                isDark: isDark,

                child: Column(

                  children: [

                    settingTile(
                      context,
                      isDark,
                      Icons.notifications_none,
                      "Notifications",
                    ),

                    divider(isDark),

                    settingTile(
                      context,
                      isDark,
                      Icons.dark_mode,
                      "Dark Mode",
                    ),

                    divider(isDark),

                    settingTile(
                      context,
                      isDark,
                      Icons.language,
                      "Language",
                    ),

                    divider(isDark),

                    settingTile(
                      context,
                      isDark,
                      Icons.lock_outline,
                      "Privacy & Security",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              /// EDIT
              SizedBox(

                width:
                double.infinity,

                height: 60,

                child:
                ElevatedButton.icon(

                  onPressed: () async {

                    final teacherDoc = await FirebaseFirestore.instance
                        .collection("teachers")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get();

                    final teacher = teacherDoc.data()!;

                    phoneController.text =
                        teacher["phone"]?.toString() ?? "";

                    qualificationController.text =
                        teacher["qualification"]?.toString() ?? "";

                    designationController.text =
                        teacher["designation"]?.toString() ?? "";

                    experienceController.text =
                        teacher["experience"]?.toString() ?? "";

                    bioController.text =
                        teacher["bio"]?.toString() ?? "";

                    showDialog(

                      context:context,

                      builder:(_){

                        return Dialog(

                          backgroundColor:
                          Colors.transparent,

                          child:

                          ClipRRect(

                            borderRadius:

                            BorderRadius.circular(
                              30,
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
                                  24,
                                ),

                                decoration:

                                BoxDecoration(

                                  color:

                                  isDark

                                      ?

                                  Colors.white
                                      .withOpacity(
                                    0.08,
                                  )

                                      :

                                  Colors.white
                                      .withOpacity(
                                    0.4,
                                  ),

                                  borderRadius:

                                  BorderRadius.circular(
                                    30,
                                  ),

                                  border:

                                  Border.all(
                                    color:
                                    Colors.white24,
                                  ),
                                ),

                                child:

                                SingleChildScrollView(

                                  child:

                                  Column(

                                    mainAxisSize:
                                    MainAxisSize.min,

                                    children:[

                                      Container(

                                        width:90,

                                        height:90,

                                        decoration:

                                        BoxDecoration(

                                          shape:
                                          BoxShape.circle,

                                          gradient:

                                          const LinearGradient(

                                            colors:[

                                              Color(
                                                0xFF008CFF,
                                              ),

                                              Color(
                                                0xFF00D4FF,
                                              ),
                                            ],
                                          ),
                                        ),

                                        child:

                                        profileImage != null

                                            ?

                                        ClipOval(

                                          child:

                                          Image.file(

                                            profileImage!,

                                            fit:
                                            BoxFit.cover,
                                          ),
                                        )

                                            :

                                        const Icon(

                                          Icons.person,

                                          size:42,

                                          color:
                                          Colors.white,
                                        ),
                                      ),

                                      const SizedBox(
                                        height:20,
                                      ),

                                      ElevatedButton.icon(

                                        onPressed:() async {

                                          final result=

                                          await FilePicker
                                              .platform
                                              .pickFiles(

                                            type:
                                            FileType.image,
                                          );

                                          if(
                                          result != null
                                          ){

                                            profileImage=

                                                File(

                                                  result.files
                                                      .first.path!,
                                                );

                                            setState(() {});
                                          }
                                        },

                                        icon:
                                        const Icon(
                                          Icons.photo,
                                        ),

                                        label:
                                        const Text(
                                          "Choose Photo",
                                        ),

                                        style:

                                        ElevatedButton.styleFrom(

                                          backgroundColor:

                                          const Color(
                                            0xFF008CFF,
                                          ),

                                          shape:

                                          RoundedRectangleBorder(

                                            borderRadius:

                                            BorderRadius.circular(
                                              18,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height:18,
                                      ),

                                      TextField(

                                        controller:
                                        phoneController,

                                        decoration:

                                        InputDecoration(

                                          labelText:
                                          "Phone",

                                          filled:true,

                                          fillColor:

                                          isDark

                                              ?

                                          Colors.white
                                              .withOpacity(
                                            0.08,
                                          )

                                              :

                                          Colors.white,

                                          border:

                                          OutlineInputBorder(

                                            borderRadius:

                                            BorderRadius.circular(
                                              18,
                                            ),

                                            borderSide:
                                            BorderSide.none,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height:14,
                                      ),

                                      const SizedBox(
                                        height: 14,
                                      ),

                                      TextField(

                                        controller: designationController,

                                        decoration: InputDecoration(

                                          labelText: "Designation",

                                          filled: true,

                                          fillColor: isDark
                                              ? Colors.white.withOpacity(0.08)
                                              : Colors.white,

                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(18),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),

                                      TextField(

                                        controller:
                                        qualificationController,

                                        decoration:

                                        InputDecoration(

                                          labelText:
                                          "Qualification",

                                          filled:true,

                                          fillColor:

                                          isDark

                                              ?

                                          Colors.white
                                              .withOpacity(
                                            0.08,
                                          )

                                              :

                                          Colors.white,

                                          border:

                                          OutlineInputBorder(

                                            borderRadius:

                                            BorderRadius.circular(
                                              18,
                                            ),

                                            borderSide:
                                            BorderSide.none,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height:14,
                                      ),

                                      TextField(

                                        controller:
                                        experienceController,

                                        decoration:

                                        InputDecoration(

                                          labelText:
                                          "Experience Years",

                                          filled:true,

                                          fillColor:

                                          isDark

                                              ?

                                          Colors.white
                                              .withOpacity(
                                            0.08,
                                          )

                                              :

                                          Colors.white,

                                          border:

                                          OutlineInputBorder(

                                            borderRadius:

                                            BorderRadius.circular(
                                              18,
                                            ),

                                            borderSide:
                                            BorderSide.none,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height:14,
                                      ),

                                      TextField(

                                        controller:
                                        bioController,

                                        maxLines:3,

                                        decoration:

                                        InputDecoration(

                                          labelText:
                                          "Bio",

                                          filled:true,

                                          fillColor:

                                          isDark

                                              ?

                                          Colors.white
                                              .withOpacity(
                                            0.08,
                                          )

                                              :

                                          Colors.white,

                                          border:

                                          OutlineInputBorder(

                                            borderRadius:

                                            BorderRadius.circular(
                                              18,
                                            ),

                                            borderSide:
                                            BorderSide.none,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height:24,
                                      ),

                                      SizedBox(

                                        width:
                                        double.infinity,

                                        height:55,

                                        child:

                                        ElevatedButton(

                                          style:

                                          ElevatedButton.styleFrom(

                                            backgroundColor:

                                            const Color(
                                              0xFF008CFF,
                                            ),

                                            shape:

                                            RoundedRectangleBorder(

                                              borderRadius:

                                              BorderRadius.circular(
                                                18,
                                              ),
                                            ),
                                          ),

                                          onPressed: () async {
                                            try {
                                              String imageUrl = "";

                                              if (profileImage != null) {
                                                final ref = FirebaseStorage.instance
                                                    .ref()
                                                    .child(
                                                  "teacher_profiles/${FirebaseAuth.instance.currentUser!.uid}",
                                                );

                                                await ref.putFile(profileImage!);

                                                imageUrl = await ref.getDownloadURL();
                                              }

                                              final Map<String, dynamic> updateData = {
                                                "phone": phoneController.text,
                                                "qualification": qualificationController.text,
                                                "designation": designationController.text,
                                                "experience": experienceController.text,
                                                "bio": bioController.text,
                                              };

                                              if (imageUrl.isNotEmpty) {
                                                updateData["photoUrl"] = imageUrl;
                                              }

                                              await FirebaseFirestore.instance
                                                  .collection("teachers")
                                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                                  .update(updateData);

                                              if (mounted) {
                                                Navigator.pop(context);

                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    content: Text("Profile Updated Successfully"),
                                                  ),
                                                );
                                              }
                                            } catch (e) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(e.toString()),
                                                ),
                                              );
                                            }
                                          },

                                          child:

                                          const Text(

                                            "SAVE PROFILE",

                                            style:

                                            TextStyle(
                                              color:
                                              Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );

                      },
                    );
                  },

                  icon: const Icon(
                    Icons.edit,
                  ),

                  label: const Text(
                    "Edit Profile",
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// LOGOUT
              SizedBox(

                width:
                double.infinity,

                height: 60,

                child:
                ElevatedButton.icon(

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    Colors.red
                        .withOpacity(
                      0.12,
                    ),
                  ),

                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RoleSelectionPage(),
                      ),
                          (route) => false,
                    );
                  },

                  icon: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),

                  label: const Text(
                    "Logout",

                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingTile(
      BuildContext context,
      bool isDark,
      IconData icon,
      String title,
      ) {

    return ListTile(

      onTap: () {

        if (title == "Dark Mode") {

          EduMateApp.of(
            context,
          )?.toggleTheme();
        }
      },

      leading: CircleAvatar(

        backgroundColor:
        Colors.blue
            .withOpacity(0.15),

        child: Icon(
          icon,
          color: Colors.blue,
        ),
      ),

      title: Text(
        title,

        style: TextStyle(
          color:
          isDark
              ? Colors.white
              : Colors.black,

          fontSize: 18,
          fontWeight:
          FontWeight.w600,
        ),
      ),

      trailing: Icon(
        Icons.arrow_forward_ios,

        color:
        isDark
            ? Colors.white70
            : Colors.black54,

        size: 18,
      ),
    );
  }

  Widget divider(bool isDark) {

    return Divider(
      color:
      isDark
          ? Colors.white.withOpacity(
        0.08,
      )
          : Colors.black12,
    );
  }

  Widget badge(
      String text,
      Color color,
      ) {

    return Container(

      padding:
      const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color:
        color.withOpacity(0.15),

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Text(
        text,

        style: TextStyle(
          color: color,
          fontWeight:
          FontWeight.bold,
        ),
      ),
    );
  }

  Widget statCard(
      bool isDark,
      String title,
      String value,
      ) {

    return glassCard(

      isDark: isDark,

      child: Padding(

        padding:
        const EdgeInsets.symmetric(
          vertical: 18,
        ),

        child: Column(

          children: [

            Text(
              title,

              style: TextStyle(
                color:
                isDark
                    ? Colors.white70
                    : Colors.black54,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              value,

              style: const TextStyle(
                fontSize: 32,
                fontWeight:
                FontWeight.bold,
                color:
                Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget glassCard({
    required Widget child,
    required bool isDark,
  }) {

    return ClipRRect(

      borderRadius:
      BorderRadius.circular(30),

      child: BackdropFilter(

        filter:
        ImageFilter.blur(
          sigmaX: 20,
          sigmaY: 20,
        ),

        child: Container(

          width: double.infinity,

          padding:
          const EdgeInsets.all(20),

          decoration: BoxDecoration(

            color:
            isDark
                ? Colors.white
                .withOpacity(
              0.06,
            )
                : Colors.white,

            borderRadius:
            BorderRadius.circular(
              30,
            ),

            border: Border.all(
              color:
              isDark
                  ? Colors.white
                  .withOpacity(
                0.08,
              )
                  : Colors.black12,
            ),
          ),

          child: child,
        ),
      ),
    );
  }

  Widget glassIcon({
    required IconData icon,
    VoidCallback? onTap,
  }) {

    return GestureDetector(

      onTap: onTap,

      child: Container(
        width: 50,
        height: 50,

        decoration: BoxDecoration(
          color:
          Colors.white
              .withOpacity(0.08),

          shape: BoxShape.circle,
        ),

        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}