import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sportdivers/screens/dailoz/dailoz_gloabelclass/dailoz_icons.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width / 30, vertical: height / 36),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            _buildNavigationItem(DailozSvgimage.home, DailozSvgimage.homefill, height, width),
            _buildNavigationItem(DailozSvgimage.chart, DailozSvgimage.chartfill, height, width),
            _buildNavigationItem(DailozSvgimage.calendar, DailozSvgimage.calendarfill, height, width),
            _buildNavigationItem(DailozSvgimage.chat, DailozSvgimage.chatfill, height, width),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationItem(String icon, String activeIcon, double height, double width) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        icon,
        height: height / 30,
        width: width / 30,
      ),
      activeIcon: SvgPicture.asset(
        activeIcon,
        height: height / 35,
        width: width / 35,
      ),
      label: '',
    );
  }
}