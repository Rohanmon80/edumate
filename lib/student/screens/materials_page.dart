import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../../main.dart';

class MaterialsPage extends StatelessWidget {
  const MaterialsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      appBar: AppBar(

        backgroundColor: Colors.transparent,

        elevation: 0,

        leading: IconButton(

          icon: const Icon(Icons.arrow_back),

          onPressed: () {

            Navigator.pop(context);
          },
        ),
      ),

      backgroundColor:
      isDark
          ? const Color(0xFF081120)
          : const Color(0xFFF4F8FC),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              /// TOP BAR
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        "Materials",

                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,

                          color:
                          isDark
                              ? Colors.white
                              : const Color(0xFF0B1736),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Study resources & notes",

                        style: TextStyle(
                          fontSize: 16,

                          color:
                          isDark
                              ? Colors.white70
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  glassIcon(
                    icon:
                    isDark
                        ? Icons.light_mode
                        : Icons.dark_mode,

                    onTap: () {

                      EduMateApp.of(context)
                          ?.toggleTheme();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// SEARCH BAR
              ClipRRect(

                borderRadius:
                BorderRadius.circular(24),

                child: BackdropFilter(

                  filter: ImageFilter.blur(
                    sigmaX: 20,
                    sigmaY: 20,
                  ),

                  child: Container(

                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 18,
                    ),

                    decoration: BoxDecoration(

                      color:
                      isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.white.withOpacity(0.35),

                      borderRadius:
                      BorderRadius.circular(24),

                      border: Border.all(
                        color:
                        Colors.white.withOpacity(0.2),
                      ),
                    ),

                    child: TextField(

                      style: TextStyle(
                        color:
                        isDark
                            ? Colors.white
                            : Colors.black,
                      ),

                      decoration: InputDecoration(

                        border: InputBorder.none,

                        hintText:
                        "Search materials...",

                        hintStyle: TextStyle(
                          color:
                          isDark
                              ? Colors.white54
                              : Colors.grey,
                        ),

                        icon: const Icon(
                          Icons.search,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              /// SECTION TITLE
              Text(
                "Available Resources",

                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,

                  color:
                  isDark
                      ? Colors.white
                      : Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              StreamBuilder<
                  DocumentSnapshot>(

                stream:

                FirebaseFirestore
                    .instance

                    .collection(
                    "users")

                    .doc(
                    FirebaseAuth
                        .instance
                        .currentUser!
                        .uid)

                    .snapshots(),

                builder:
                    (context,userSnap){

                  if(
                  !userSnap.hasData
                  ){

                    return const SizedBox();
                  }

                  if(
                  !userSnap.data!
                      .exists
                  ){

                    return const SizedBox();
                  }

                  final user =

                  userSnap.data!
                      .data()

                  as Map<
                      String,
                      dynamic>;

                  return StreamBuilder<
                      QuerySnapshot>(

                    stream:

                    FirebaseFirestore
                        .instance

                        .collection(
                        "study_materials")

                        .where(
                        "year",

                        isEqualTo:

                        user[
                        "year"
                        ])

                        .where(
                        "department",

                        isEqualTo:

                        user[
                        "department"
                        ])

                        .where(
                        "section",

                        isEqualTo:

                        user[
                        "section"
                        ])

                        .snapshots(),

                    builder:
                        (context,snapshot){

                      if(
                      !snapshot.hasData
                      ){

                        return const Center(

                          child:
                          CircularProgressIndicator(),
                        );
                      }

                      final docs=

                          snapshot
                              .data!
                              .docs;

                      if(
                      docs.isEmpty
                      ){

                        return const Text(

                          "No materials available",
                        );
                      }

                      return Column(

                        children:

                        docs.map(

                              (e){

                            final m=

                            e.data()

                            as Map<
                                String,
                                dynamic>;

                            return materialCard(

                              isDark:
                              isDark,

                              title:

                              m["title"]
                                  ?? "Material",

                              subtitle:

                              "Uploaded by ${m["teacher"]}",

                              type:

                              m["fileType"]
                                  ?? "FILE",

                              size:

                              m["fileSize"]
                                  ?.toString()

                                  ?? "",

                              color:
                              Colors.blue,

                              icon:
                              Icons.description,

                              fileUrl:

                              m["fileUrl"]
                                  ?? "",
                            );
                          },
                        ).toList(),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget materialCard({

    required bool isDark,

    required String title,

    required String subtitle,

    required String type,

    required String size,

    required Color color,

    required IconData icon,

    required String fileUrl,
  }) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),

      child: ClipRRect(

        borderRadius:
        BorderRadius.circular(30),

        child: BackdropFilter(

          filter: ImageFilter.blur(
            sigmaX: 20,
            sigmaY: 20,
          ),

          child: Container(

            padding: const EdgeInsets.all(22),

            decoration: BoxDecoration(

              color:
              isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.white.withOpacity(0.35),

              borderRadius:
              BorderRadius.circular(30),

              border: Border.all(
                color:
                Colors.white.withOpacity(0.2),
              ),
            ),

            child: Row(

              children: [

                /// FILE ICON
                Container(
                  width: 62,
                  height: 62,

                  decoration: BoxDecoration(
                    color:
                    color.withOpacity(0.15),

                    borderRadius:
                    BorderRadius.circular(20),
                  ),

                  child: Icon(
                    icon,
                    color: color,
                    size: 32,
                  ),
                ),

                const SizedBox(width: 18),

                /// TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        title,

                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,

                          color:
                          isDark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        subtitle,

                        style: TextStyle(
                          color:
                          isDark
                              ? Colors.white70
                              : Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(

                        children: [

                          Container(

                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),

                            decoration: BoxDecoration(
                              color:
                              color.withOpacity(0.15),

                              borderRadius:
                              BorderRadius.circular(16),
                            ),

                            child: Text(
                              type,

                              style: TextStyle(
                                color: color,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Text(
                            size,

                            style: TextStyle(
                              color:
                              isDark
                                  ? Colors.white54
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                /// DOWNLOAD BUTTON
                GestureDetector(

                  onTap: () async {

                    final uri=

                    Uri.parse(
                      fileUrl,
                    );

                    await launchUrl(

                      uri,

                      mode:

                      LaunchMode
                          .externalApplication,
                    );
                  },

                  child:

                  Container(

                    width:54,

                    height:54,

                    decoration:
                    BoxDecoration(

                      color:

                      Colors.blue
                          .withOpacity(
                          0.15),

                      borderRadius:

                      BorderRadius.circular(
                          18),
                    ),

                    child:
                    const Icon(

                      Icons.download,

                      color:
                      Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
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

      child: ClipRRect(

        borderRadius:
        BorderRadius.circular(18),

        child: BackdropFilter(

          filter: ImageFilter.blur(
            sigmaX: 15,
            sigmaY: 15,
          ),

          child: Container(
            width: 58,
            height: 58,

            decoration: BoxDecoration(

              color: Colors.white.withOpacity(0.12),

              borderRadius:
              BorderRadius.circular(18),

              border: Border.all(
                color: Colors.white24,
              ),
            ),

            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}