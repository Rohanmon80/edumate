import 'dart:ui';

import 'package:flutter/material.dart';

import '../../main.dart';

class TimetablePage extends StatelessWidget {
  const TimetablePage({super.key});

  @override
  Widget build(BuildContext context) {

    final bool isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final List<Map<String, dynamic>>
    timetable = [

      {
        "subject": "Data Structures",
        "faculty": "Prof. Sharma",
        "time": "09:00 AM",
        "room": "B-204",
        "color": Colors.blue,
      },

      {
        "subject": "Operating Systems",
        "faculty": "Prof. Kumar",
        "time": "10:30 AM",
        "room": "A-102",
        "color": Colors.green,
      },

      {
        "subject": "DBMS",
        "faculty": "Prof. Das",
        "time": "12:00 PM",
        "room": "C-301",
        "color": Colors.orange,
      },

      {
        "subject": "Java Lab",
        "faculty": "Prof. Singh",
        "time": "02:00 PM",
        "room": "Lab-2",
        "color": Colors.purple,
      },

      {
        "subject": "AI Fundamentals",
        "faculty": "Prof. Roy",
        "time": "03:30 PM",
        "room": "D-105",
        "color": Colors.redAccent,
      },
    ];

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
                        "Timetable",

                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,

                          color:
                          isDark
                              ? Colors.white
                              : const Color(0xFF0B1736),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Today's class schedule",

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

              const SizedBox(height: 35),

              /// TODAY CARD
              glassCard(

                isDark: isDark,

                child: Row(

                  children: [

                    Container(
                      width: 75,
                      height: 75,

                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,

                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF005BEA),
                            Color(0xFF00C6FB),
                          ],
                        ),
                      ),

                      child: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Text(
                            "Monday Schedule",

                            style: TextStyle(
                              fontSize: 24,
                              fontWeight:
                              FontWeight.bold,

                              color:
                              isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            "${timetable.length} Classes Today",

                            style: TextStyle(
                              color:
                              isDark
                                  ? Colors.white70
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              Text(
                "Classes",

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

              ...timetable.map(
                    (subject) => classTile(
                  isDark: isDark,
                  subject: subject,
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget classTile({
    required bool isDark,
    required Map<String, dynamic>
    subject,
  }) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: glassCard(

        isDark: isDark,

        child: Row(

          children: [

            Container(
              width: 65,
              height: 65,

              decoration: BoxDecoration(
                color:
                subject["color"]
                    .withOpacity(0.15),

                borderRadius:
                BorderRadius.circular(20),
              ),

              child: Icon(
                Icons.menu_book,
                color: subject["color"],
                size: 34,
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    subject["subject"],

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,

                      color:
                      isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    subject["faculty"],

                    style: TextStyle(
                      color:
                      isDark
                          ? Colors.white70
                          : Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subject["room"],

                    style: TextStyle(
                      color:
                      subject["color"],
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              subject["time"],

              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: subject["color"],
              ),
            ),
          ],
        ),
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

          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(

            color:
            isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.white.withOpacity(0.35),

            borderRadius:
            BorderRadius.circular(28),

            border: Border.all(
              color:
              Colors.white.withOpacity(0.2),
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

        decoration: BoxDecoration(

          color:
          Colors.white.withOpacity(0.12),

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
    );
  }
}