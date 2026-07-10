import 'dart:ui';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../main.dart';
import '../../role_selection_page.dart';

class AdminProfilePage extends StatefulWidget {

  const AdminProfilePage({
    super.key,
  });

  @override
  State<AdminProfilePage>
  createState() =>
      _AdminProfilePageState();
}

class _AdminProfilePageState
    extends State<AdminProfilePage> {

  final phoneController =
  TextEditingController();

  final designationController =
  TextEditingController();

  final officeController =
  TextEditingController();

  final bioController =
  TextEditingController();

  File? profileImage;

  @override
  void dispose() {
    phoneController.dispose();
    designationController.dispose();
    officeController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(
      BuildContext context) {

    final bool isDark =
        Theme.of(context)
            .brightness ==
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

      body: SafeArea(

        child:
        StreamBuilder<
            DocumentSnapshot>(

          stream:

          FirebaseFirestore
              .instance

              .collection(
            "admins",
          )

              .doc(

            FirebaseAuth
                .instance
                .currentUser!
                .uid,
          )

              .snapshots(),

          builder:
              (
              context,
              profileSnapshot,
              ) {

            if (!profileSnapshot
                .hasData) {

              return const Center(
                child:
                CircularProgressIndicator(),
              );
            }

            final profile =
            profileSnapshot
                .data!;

            return SingleChildScrollView(

              padding:
              const EdgeInsets
                  .all(
                20,
              ),

              child: Column(

                children: [

                  /// TOP BAR
                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,

                    children: [

                      Text(

                        "Admin Profile",

                        style:
                        TextStyle(

                          fontSize:
                          34,

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

                            context:
                            context,

                            icon:

                            isDark

                                ? Icons.light_mode

                                : Icons.dark_mode,

                            onTap:
                                () {

                              EduMateApp.of(
                                  context)
                                  ?.toggleTheme();
                            },
                          ),

                          const SizedBox(
                            width:
                            12,
                          ),

                          glassIcon(

                            context:
                            context,

                            icon:
                            Icons.notifications_none,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(
                    height:
                    28,
                  ),

                  /// PROFILE

                  glassCard(

                    context:
                    context,

                    child:
                    Column(

                      children: [

                        Container(

                          width:
                          110,

                          height:
                          110,

                          decoration:
                          const BoxDecoration(

                            shape:
                            BoxShape.circle,

                            gradient:
                            LinearGradient(

                              colors: [

                                Color(
                                  0xFF005BEA,
                                ),

                                Color(
                                  0xFF00C6FB,
                                ),
                              ],
                            ),
                          ),

                          child:
                          Center(

                            child:
                            Text(

                              (
                                  profile.data()
                                      .toString()
                                      .contains(
                                      "name"
                                  )

                                      ? profile["name"]

                                      .toString()

                                      : "Admin"

                              )

                                  .toString().length >= 2
                                  ? profile["name"].toString().substring(0, 2).toUpperCase()
                                  : profile["name"].toString().toUpperCase(),

                              style:
                              const TextStyle(

                                fontSize:40,

                                fontWeight:
                                FontWeight.bold,

                                color:
                                Colors.white,
                              ),
                            )
                          ),
                        ),

                        const SizedBox(
                          height:
                          20,
                        ),

                        Text(

                          profile.data().toString().contains(
                              "name"
                          )
                              ? profile["name"]
                              : "Admin",

                          style:
                          TextStyle(

                            fontSize:
                            30,

                            fontWeight:
                            FontWeight.bold,

                            color:
                            isDark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),

                        const SizedBox(
                          height:
                          6,
                        ),

                        Text(
                          profile["designation"]?.toString() ?? "Administrator",
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark
                                ? Colors.white70
                                : Colors.black54,
                          ),
                        ),


                      ],
                    ),
                  ),

                  const SizedBox(
                    height:
                    25,
                  ),

                  /// STATS

                  FutureBuilder<List<QuerySnapshot>>(

                    future:
                    Future.wait([

                      FirebaseFirestore
                          .instance
                          .collection(
                        "users",
                      )
                          .where(
                        "role",
                        isEqualTo:
                        "student",
                      )
                          .get(),

                      FirebaseFirestore
                          .instance
                          .collection(
                        "teachers",
                      )
                          .get(),

                      FirebaseFirestore
                          .instance
                          .collection(
                        "admins",
                      )
                          .get(),

                    ]),

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

                      final data =
                      snapshot.data!;

                      int students =

                          data[0]
                              .docs
                              .length;

                      int teachers =

                          data[1]
                              .docs
                              .length;

                      int admins =

                          data[2]
                              .docs
                              .length;

                      return Row(

                        children:[

                          Expanded(
                            child:
                            statCard(
                              context,
                              "Students",
                              students
                                  .toString(),
                            ),
                          ),

                          const SizedBox(
                            width:12,
                          ),

                          Expanded(
                            child:
                            statCard(
                              context,
                              "Faculty",
                              teachers
                                  .toString(),
                            ),
                          ),

                          const SizedBox(
                            width:12,
                          ),

                          Expanded(
                            child:
                            statCard(
                              context,
                              "Admins",
                              admins
                                  .toString(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(
                    height:25,
                  ),




              /// SETTINGS
              glassCard(

                context: context,

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

              /// EDIT PROFILE
              SizedBox(

                width:
                double.infinity,

                height: 60,

                child:
                ElevatedButton.icon(

                  onPressed: () {
                    phoneController.text =
                        profile["phone"]?.toString() ?? "";

                    designationController.text =
                        profile["designation"]?.toString() ?? "";

                    officeController.text =
                        profile["office"]?.toString() ?? "";

                    bioController.text =
                        profile["bio"]?.toString() ?? "";

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

                                        width:95,

                                        height:95,

                                        decoration:

                                        const BoxDecoration(

                                          shape:
                                          BoxShape.circle,

                                          gradient:

                                          LinearGradient(

                                            colors:[

                                              Color(
                                                0xFF005BEA,
                                              ),

                                              Color(
                                                0xFF00C6FB,
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

                                          color:
                                          Colors.white,

                                          size:42,
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
                                      ),

                                      const SizedBox(
                                        height:18,
                                      ),

                                      editField(

                                        phoneController,

                                        "Phone",

                                        Icons.phone,
                                      ),

                                      const SizedBox(
                                        height:14,
                                      ),

                                      editField(

                                        designationController,

                                        "Designation",

                                        Icons.badge,
                                      ),

                                      const SizedBox(
                                        height:14,
                                      ),

                                      editField(

                                        officeController,

                                        "Office Room",

                                        Icons.room,
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

                                          hintText:
                                          "About Admin",

                                          prefixIcon:

                                          const Icon(
                                            Icons.info,
                                          ),

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

                                          onPressed:
                                              () async {

                                            String imageUrl="";

                                            if(
                                            profileImage != null
                                            ){

                                              final ref=

                                              FirebaseStorage
                                                  .instance

                                                  .ref()

                                                  .child(

                                                "admin_profiles/${FirebaseAuth.instance.currentUser!.uid}",
                                              );

                                              await ref.putFile(
                                                profileImage!,
                                              );

                                              imageUrl=

                                              await ref
                                                  .getDownloadURL();
                                            }
                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection("admins")
                                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                                  .update({
                                                if (imageUrl.isNotEmpty) "photoUrl": imageUrl,
                                                "phone": phoneController.text,
                                                "designation": designationController.text,
                                                "office": officeController.text,
                                                "bio": bioController.text,
                                              });

                                              Navigator.pop(context);

                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text("Profile Updated Successfully"),
                                                ),
                                              );
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

                  const SizedBox(
                    height:100,
                  ),

                ],
              ),
            );
              },
        ),
      ),
    );

  }

  Widget editField(

      TextEditingController controller,

      String hint,

      IconData icon,
      ){

    return TextField(

      controller:controller,

      decoration:

      InputDecoration(

        hintText:hint,

        prefixIcon:
        Icon(icon),

        filled:true,

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

        /// DARK MODE
        if (title == "Dark Mode") {

          EduMateApp.of(
            context,
          )?.toggleTheme();
        }

        /// LANGUAGE
        else if (title == "Language") {

          showModalBottomSheet(

            context: context,

            backgroundColor:
            isDark
                ? const Color(0xFF081120)
                : Colors.white,

            builder: (_) {

              return Padding(

                padding:
                const EdgeInsets.all(20),

                child: Column(

                  mainAxisSize:
                  MainAxisSize.min,

                  children: [

                    Text(
                      "Select Language",

                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                        FontWeight.bold,

                        color:
                        isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 20),

                    languageTile(
                      isDark,
                      "English",
                    ),

                    languageTile(
                      isDark,
                      "Hindi",
                    ),

                    languageTile(
                      isDark,
                      "Bengali",
                    ),

                    languageTile(
                      isDark,
                      "Telugu",
                    ),
                  ],
                ),
              );
            },
          );
        }

        /// NOTIFICATIONS
        else if (title == "Notifications") {

          ScaffoldMessenger.of(context)
              .showSnackBar(

            const SnackBar(
              content: Text(
                "Notifications Opened",
              ),
            ),
          );
        }

        /// PRIVACY
        else if (title ==
            "Privacy & Security") {

          showDialog(

            context: context,

            builder: (_) {

              return AlertDialog(

                title: const Text(
                  "Privacy & Security",
                ),

                content: const Text(
                  "Security settings page here.",
                ),

                actions: [

                  TextButton(

                    onPressed: () {

                      Navigator.pop(
                        context,
                      );
                    },

                    child:
                    const Text(
                      "Close",
                    ),
                  ),
                ],
              );
            },
          );
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

  Widget languageTile(
      bool isDark,
      String language,
      ) {

    return ListTile(

      title: Text(
        language,

        style: TextStyle(
          color:
          isDark
              ? Colors.white
              : Colors.black,
        ),
      ),

      onTap: () {},
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
      BuildContext context,
      String title,
      String value,
      ) {

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return glassCard(

      context: context,

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
    required BuildContext context,
    required Widget child,
  }) {

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

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
    required BuildContext context,
    required IconData icon,
    VoidCallback? onTap,
  }) {

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return GestureDetector(

      onTap: onTap,

      child: Container(
        width: 50,
        height: 50,

        decoration: BoxDecoration(
          color:
          isDark
              ? Colors.white
              .withOpacity(0.08)
              : Colors.white,

          shape: BoxShape.circle,
        ),

        child: Icon(
          icon,

          color:
          isDark
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}