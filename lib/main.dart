import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Tab> tabsForPhone = [
    Tab(child: Text("Iletisim")),
    Tab(child: Text("Kisisel")),
    Tab(child: Text("Izinler")),
    Tab(child: Text("Yasal")),
  ];

  List<Tab> tabsForTablet = [Tab(child: Text("Profil"))];

  late TabController tabControllerPhone;
  late TabController tabControllerTablet;

  @override
  void initState() {
    super.initState();
    tabControllerPhone =
        TabController(length: tabsForPhone.length, vsync: this);
    tabControllerTablet =
        TabController(length: tabsForTablet.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double w = constraints.maxWidth;
        double h = constraints.maxHeight;
        ScreenSize screenSize = ScreenSize.phone;
        if (w > 600) screenSize = ScreenSize.tablet;
        if (w > 960) screenSize = ScreenSize.desktop;

        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 260,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text("profil"),
                    background: Container(color: Colors.yellow),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      controller: screenSize == ScreenSize.phone
                          ? tabControllerPhone
                          : tabControllerTablet,
                      tabs: screenSize == ScreenSize.phone
                          ? tabsForPhone
                          : tabsForTablet,
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              controller: screenSize == ScreenSize.phone
                  ? tabControllerPhone
                  : tabControllerTablet,
              children: screenSize == ScreenSize.phone
                  ? [
                      tabA,
                      tabB,
                      tabC,
                      tabD,
                    ]
                  : [
                      tabP,
                    ],
            ),
          ),
        );
      },
    );
  }

  Widget get tabA => contentBuilder("A", false);
  Widget get tabB => contentBuilder("B", false);
  Widget get tabC => contentBuilder("C", false);
  Widget get tabD => contentBuilder("D", false);
  Widget get tabP => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            contentBuilder("A", true),
            contentBuilder("B", true),
            contentBuilder("C", true),
            contentBuilder("D", true),
          ],
        ),
      );

  Widget contentBuilder(String name, bool shrinkWrap) => ListView.builder(
        shrinkWrap: shrinkWrap,
        itemBuilder: (c, i) => ListTile(
          title: Text("$name item $i"),
        ),
        itemCount: 50,
      );
}

enum ScreenSize {
  phone,
  tablet,
  desktop,
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
