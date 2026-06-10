import 'dart:ui';

import 'package:flutter/material.dart';

import '../../main.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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

          padding:
          const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.center,

            children: [

              /// TOP BAR
              Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

                children: [

                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      Text(
                        "Profile",

                        style: TextStyle(
                          fontSize: 36,
                          fontWeight:
                          FontWeight.bold,

                          color:
                          isDark
                              ? Colors.white
                              : const Color(
                            0xFF0B1736,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Text(
                        "Student information",

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

                      EduMateApp.of(
                        context,
                      )?.toggleTheme();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 35),

              /// PROFILE CARD
              glassCard(

                isDark: isDark,

                child: Column(

                  children: [

                    Container(
                      width: 120,
                      height: 120,

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

                      child: const Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Rohan Mondal",

                      style: TextStyle(
                        fontSize: 28,
                        fontWeight:
                        FontWeight.bold,

                        color:
                        isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Computer Science Engineering",

                      textAlign:
                      TextAlign.center,

                      style: TextStyle(
                        fontSize: 16,

                        color:
                        isDark
                            ? Colors.white70
                            : Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "3rd Year Student",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 58,

                      child: ElevatedButton(

                        onPressed: () {},

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
                              20,
                            ),
                          ),
                        ),

                        child: const Text(
                          "Edit Profile",

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.bold,
                            color:
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              /// INFO SECTION
              infoTile(
                isDark: isDark,
                icon: Icons.badge,
                title: "Roll Number",
                value: "22B81A0512",
                color: Colors.blue,
              ),

              infoTile(
                isDark: isDark,
                icon: Icons.email,
                title: "Email",
                value:
                "rohan@edumate.com",
                color: Colors.orange,
              ),

              infoTile(
                isDark: isDark,
                icon: Icons.phone,
                title: "Phone",
                value:
                "+91 9876543210",
                color: Colors.green,
              ),

              infoTile(
                isDark: isDark,
                icon: Icons.school,
                title: "Department",
                value: "CSE",
                color: Colors.purple,
              ),

              const SizedBox(height: 35),

              /// STATS
              Row(

                children: [

                  Expanded(
                    child: statCard(
                      title:
                      "Attendance",
                      value: "84%",
                      color:
                      Colors.green,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: statCard(
                      title: "CGPA",
                      value: "8.42",
                      color:
                      Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoTile({
    required bool isDark,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {

    return Padding(
      padding:
      const EdgeInsets.only(
        bottom: 18,
      ),

      child: glassCard(

        isDark: isDark,

        child: Row(

          children: [

            Container(
              width: 58,
              height: 58,

              decoration:
              BoxDecoration(
                color:
                color.withOpacity(
                  0.15,
                ),

                borderRadius:
                BorderRadius.circular(
                  18,
                ),
              ),

              child: Icon(
                icon,
                color: color,
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  Text(
                    title,

                    style: TextStyle(
                      color:
                      isDark
                          ? Colors
                          .white70
                          : Colors.grey,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    value,

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,

                      color:
                      isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statCard({
    required String title,
    required String value,
    required Color color,
  }) {

    return Container(

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color:
        color.withOpacity(0.15),

        borderRadius:
        BorderRadius.circular(22),
      ),

      child: Column(

        children: [

          Text(
            title,

            style: TextStyle(
              color: color,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            value,

            style: TextStyle(
              fontSize: 28,
              fontWeight:
              FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget glassCard({
    required bool isDark,
    required Widget child,
  }) {

    return ClipRRect(

      borderRadius:
      BorderRadius.circular(28),

      child: BackdropFilter(

        filter: ImageFilter.blur(
          sigmaX: 20,
          sigmaY: 20,
        ),

        child: Container(

          padding:
          const EdgeInsets.all(22),

          decoration: BoxDecoration(

            color:
            isDark
                ? Colors.white
                .withOpacity(0.08)
                : Colors.white
                .withOpacity(0.35),

            borderRadius:
            BorderRadius.circular(
              28,
            ),

            border: Border.all(
              color:
              Colors.white
                  .withOpacity(0.2),
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
        width: 52,
        height: 52,

        decoration:
        BoxDecoration(

          color: Colors.white
              .withOpacity(
            0.12,
          ),

          borderRadius:
          BorderRadius.circular(
            18,
          ),

          border: Border.all(
            color: Colors.white24,
          ),
        ),

        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}