import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:websocket/server.dart';
import 'client.dart';


class WhatsAppStyle extends StatefulWidget {
  const WhatsAppStyle({
    Key key,
  }) : super(key: key);

  @override
  _WhatsAppStyleState createState() => _WhatsAppStyleState();
}

class _WhatsAppStyleState extends State<WhatsAppStyle> with SingleTickerProviderStateMixin {

  TabController _tabController;
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'LEFT'),
    Tab(text: 'RIGHT'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController( vsync: this, length: myTabs.length,);

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(

        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.yellow,
              title: Text(
                "WhatsApp type sliver appbar",
              ),
              elevation: 0.0,
              forceElevated: false,
              pinned: false,
              floating: true,
              primary: false,
              centerTitle: false,
              titleSpacing: NavigationToolbar.kMiddleSpacing,
              automaticallyImplyLeading: false,
            ),
            SliverAppBar(
              backgroundColor: Colors.orange,
              pinned: true,
              primary: false,
              centerTitle: false,
              titleSpacing: 0,
              toolbarHeight: 48,
              automaticallyImplyLeading: false,
              forceElevated: true,
              title: Align(
                alignment: Alignment.topLeft,
                child: TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.label,
                    controller: _tabController,
                    labelPadding: EdgeInsets.only(
                        top: 13, bottom: 13, left: 16, right: 16),
                    tabs: [
                      Text(
                        "Server",
                      ),
                      Text(
                        "Client",
                      ),
                    ]),
              ),
            ),
          ];
        },
        body: SafeArea(child: MyTabs(tabController: _tabController))
      ),
    );
  }


}

class MyTabs extends StatefulWidget {
  final TabController tabController;
  const MyTabs({
    Key key, this.tabController
  }) : super(key: key);

  @override
  _MyTabsState createState() => _MyTabsState();
}

class _MyTabsState extends State<MyTabs>  {


  @override
  Widget build(BuildContext context) {
    return  TabBarView(

      controller: widget.tabController,
      children: [
        ServerPage(),
        ClientPage(),

/*   TabA(),
            const Center(
              child: Text('Display Tab 2',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),*/
      ],
    );
  }
}


Stream<String> readLine() => stdin
    .transform(utf8.decoder)
    .transform(const LineSplitter());

void processLine(String line) {
  print(line);
}

class TabA extends StatefulWidget {
  const TabA({
    Key key,
  }) : super(key: key);

  @override
  _TabA createState() => _TabA();
}

class _TabA extends State<TabA> {


  @override
  void initState()  {
    super.initState();
    _go();
  }



  Map<String,dynamic> a = {'a' : 'b', 'c' : {'d' : 'e'}};
  void _go () async  {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/a.json');
    await file.writeAsString(json.encode(a));
    Map<String, dynamic> myJson = await json.decode(await file.readAsString());
    print(myJson.toString());
  }





//     readLine().listen(processLine);
  // var line = stdin.readLineSync(encoding: Encoding.getByName('utf-8')!);
  //    print(line);

  @override
  Widget build(BuildContext context) {
    return   Container(child: InkWell(
        child: Container(
          child: Text('gdfd'),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(25),
            color: Color(0x33ff0000),
          ),
          height: MediaQuery.of(context).size.height * .065,
          width: MediaQuery.of(context).size.width * .8,)));


    //TextButton(child: Text('hey'), onPressed: () => _go() ,);
  }
}