import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:real_estate_app/views/home_tab.dart';
import 'package:real_estate_app/views/search_tab.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MainScreen());
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin<MainScreen> {
  late AnimationController _animationController;
  SequenceAnimation? sequenceAnimation;
  int _selectedIndex = 2; // Default to Home
  late PageController _pageController;

  final List<Widget> _pages = <Widget>[
    SearchScreen(),
    const Center(child: Text('Messages Page', style: TextStyle(fontSize: 24))),
    HomeScreen(),
    const Center(child: Text('Favorites Page', style: TextStyle(fontSize: 24))),
    const Center(
      child: Text('User Account Page', style: TextStyle(fontSize: 24)),
    ),
  ];

  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    sequenceAnimation = SequenceAnimationBuilder()
        .addAnimatable(
          animatable: Tween<Offset>(begin: Offset(0, 5), end: Offset.zero),
          curve: Curves.linear,
          from: const Duration(seconds: 6),
          to: const Duration(seconds: 7),
          tag: "slide_up_sheet",
        )
        .animate(_animationController);
    _animationController.forward();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _opacity = 0.0; // Start fade out
    });

    Future.delayed(Duration(milliseconds: 250), () {
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      Future.delayed(Duration(milliseconds: 250), () {
        setState(() {
          _opacity = 1.0; // Fade in after transition
          _selectedIndex = index;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: _opacity,
            // Control opacity during transition
            duration: Duration(milliseconds: 300),
            // Adjust fade-in duration
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(), // Disable swipe
              children: _pages,
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              color: Colors.transparent,
              child: SlideTransition(
                position:
                    sequenceAnimation!["slide_up_sheet"] as Animation<Offset>,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: IntrinsicWidth(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BottomNavigationBar(
                        landscapeLayout:
                            BottomNavigationBarLandscapeLayout.centered,
                        backgroundColor: Color.fromRGBO(21, 21, 21, 0.5),
                        currentIndex: _selectedIndex,
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        // Color.fromRGBO(252, 158, 18,1)
                        type: BottomNavigationBarType.fixed,
                        unselectedIconTheme: IconThemeData(
                          size: 28,
                          color: Colors.white,
                        ),
                        selectedIconTheme: IconThemeData(
                          size: 28,
                          color: Colors.white,
                        ),
                        items: [
                          _buildNavItem(
                            _searchWidget(28),
                            "Search",
                            _selectedIndex == 0,
                          ),
                          _buildNavItem(
                            Icon(Icons.sms, size: 28, color: Colors.white),
                            'Messages',
                            _selectedIndex == 1,
                          ),
                          _buildNavItem(
                            _homeWidget(
                              28,
                              _selectedIndex == 2
                                  ? Color.fromRGBO(252, 158, 18, 1)
                                  : Color.fromRGBO(93, 91, 88, 1),
                            ),
                            'Home',
                            _selectedIndex == 2,
                          ),
                          _buildNavItem(
                            Icon(Icons.favorite, size: 28, color: Colors.white),
                            'Favorites',
                            _selectedIndex == 3,
                          ),
                          _buildNavItem(
                            Icon(
                              Icons.person_rounded,
                              size: 28,
                              color: Colors.white,
                            ),
                            'Account',
                            _selectedIndex == 4,
                          ),
                        ],
                        onTap: _onItemTapped,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stack _searchWidget(double size) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Search Icon
        Icon(Icons.search, color: Colors.white, size: size),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          bottom: 5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Fill color
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Stack _homeWidget(double size, backgroundColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.pentagon_rounded, size: size, color: Colors.white),
        // Pentagon icon
        Positioned(
          child: Container(
            width: size * 0.25, // Adjust hole size
            height: size * 0.25,
            decoration: BoxDecoration(
              color: backgroundColor, // Match background color
              shape: BoxShape.circle, // Circular hole
            ),
          ),
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(
    Widget icon,
    String label,
    bool isSelected,
  ) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              isSelected
                  ? Color.fromRGBO(252, 158, 18, 1)
                  : Color.fromRGBO(
                    93,
                    91,
                    88,
                    1,
                  ), // Light background for the icon
        ),
        child: icon,
      ),
      label: label,
    );
  }
}
