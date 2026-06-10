import 'package:flutter/material.dart';

import '../screens/ai_assistant_page.dart';

import '../screens/bus_tracking_page.dart';
import '../screens/campus_map_page.dart';
import '../screens/certificate_vault_page.dart';
import '../screens/chat_page.dart';
import '../screens/coding_contest_page.dart';
import '../screens/events_page.dart';
import '../screens/library_page.dart';
import '../screens/placement_page.dart';
import '../screens/profile_page.dart';
import '../screens/project_hub_page.dart';
import '../screens/scholarship_page.dart';
import '../screens/settings_page.dart';
import '../screens/timetable_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    return Drawer(

      child: ListView(

        padding: EdgeInsets.zero,

        children: [

          const UserAccountsDrawerHeader(

            accountName:
            Text("Rohan Mondal"),

            accountEmail:
            Text("rohan@edumate.com"),

            currentAccountPicture:
            CircleAvatar(
              child: Icon(
                Icons.person,
                size: 42,
              ),
            ),
          ),

          drawerTile(
            context,
            "Profile",
            Icons.person,
            const ProfilePage(),
          ),

          drawerTile(
            context,
            "Timetable",
            Icons.calendar_today,
            const TimetablePage(),
          ),



          drawerTile(
            context,
            "Library",
            Icons.local_library,
            const LibraryPage(),
          ),

          drawerTile(
            context,
            "Chat",
            Icons.chat,
            const ChatPage(),
          ),

          drawerTile(
            context,
            "AI Assistant",
            Icons.smart_toy,
            const AIAssistantPage(),
          ),

          drawerTile(
            context,
            "Events",
            Icons.event,
            const EventsPage(),
          ),

          drawerTile(
            context,
            "Placement",
            Icons.business_center,
            const PlacementPage(),
          ),

          drawerTile(
            context,
            "Project Hub",
            Icons.groups,
            const ProjectHubPage(),
          ),

          drawerTile(
            context,
            "Scholarships",
            Icons.workspace_premium,
            const ScholarshipPage(),
          ),

          drawerTile(
            context,
            "Coding Contest",
            Icons.code,
            const CodingContestPage(),
          ),

          drawerTile(
            context,
            "Campus Map",
            Icons.map,
            const CampusMapPage(),
          ),

          drawerTile(
            context,
            "Bus Tracking",
            Icons.directions_bus,
            const BusTrackingPage(),
          ),

          drawerTile(
            context,
            "Certificates",
            Icons.folder,
            const CertificateVaultPage(),
          ),

          drawerTile(
            context,
            "Settings",
            Icons.settings,
            const SettingsPage(),
          ),
        ],
      ),
    );
  }

  Widget drawerTile(
      BuildContext context,
      String title,
      IconData icon,
      Widget page,
      ) {

    return ListTile(

      leading: Icon(icon),

      title: Text(title),

      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(
            builder: (_) => page,
          ),
        );
      },
    );
  }
}