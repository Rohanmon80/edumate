import 'package:flutter/material.dart';

import 'materials_upload_page.dart';
import 'teacher_dashboard_page.dart';
import 'teacher_marks_page.dart';
import 'notice_panel_page.dart';
import 'teacher_profile_page.dart';

class TeacherMainNavigation
    extends StatefulWidget {

  TeacherMainNavigation({
    super.key,
  });

  @override
  State<TeacherMainNavigation>
  createState() =>
      _TeacherMainNavigationState();
}

class _TeacherMainNavigationState
    extends State<TeacherMainNavigation> {

  int currentIndex = 0;

  final List<Widget> pages = [

    TeacherDashboardPage(),

    const TeacherMarksPage(),

    const TeacherNoticePage(),

    const TeacherMaterialUploadPage(),

    const TeacherProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      extendBody: true,

      backgroundColor:
      const Color(0xFF081120),

      body: Stack(

        children: [

          /// CURRENT PAGE
          pages[currentIndex],

          /// FLOATING NAV BAR
          Positioned(

            left: 14,
            right: 14,
            bottom: 14,

            child: Container(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),

              decoration: BoxDecoration(

                color:
                Colors.white
                    .withOpacity(0.08),

                borderRadius:
                BorderRadius.circular(32),

                border: Border.all(
                  color:
                  Colors.white
                      .withOpacity(0.08),
                ),
              ),

              child: Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceAround,

                children: [

                  navItem(
                    Icons.home,
                    "Home",
                    0,
                  ),

                  navItem(
                    Icons.fact_check,
                    "Marks",
                    1,
                  ),

                  navItem(
                    Icons.campaign,
                    "Notice",
                    2,
                  ),

                  navItem(
                    Icons.menu_book,
                    "Mats",
                    3,
                  ),

                  navItem(
                    Icons.person,
                    "Me",
                    4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget navItem(
      IconData icon,
      String label,
      int index,
      ) {

    final bool isSelected =
        currentIndex == index;

    return GestureDetector(

      onTap: () {

        setState(() {

          currentIndex = index;
        });
      },

      child: AnimatedContainer(

        duration:
        const Duration(
          milliseconds: 250,
        ),

        padding:
        const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),

        decoration: BoxDecoration(

          color:
          isSelected
              ? Colors.blue
              .withOpacity(0.18)
              : Colors.transparent,

          borderRadius:
          BorderRadius.circular(20),
        ),

        child: Column(

          mainAxisSize:
          MainAxisSize.min,

          children: [

            Icon(
              icon,

              size: 24,

              color:
              isSelected
                  ? Colors.blue
                  : Colors.white70,
            ),

            const SizedBox(height: 4),

            Text(
              label,

              style: TextStyle(

                fontSize: 12,

                color:
                isSelected
                    ? Colors.blue
                    : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}