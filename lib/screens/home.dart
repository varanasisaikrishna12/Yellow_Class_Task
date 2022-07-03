import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hls_player/main.dart';
import 'package:hls_player/model/video.dart';
import 'package:hls_player/styles/styles.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'video_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GlobalKey<VideoTileState>> a = [];
  List<Video> videos = [];

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    getVideos();
    itemPositionsListener.itemPositions.addListener(visibleItems);
  }

  Future<String> getJson() {
    return rootBundle.loadString('assets/videos.json');
  }

  getVideos() async {
    String jsonString = await getJson();
    json.decode(jsonString).forEach((v) {
      videos.add(Video.fromJson(v)
        ..totalViews = 5000);
    });
    for (int i = 0; i < videos.length; i++) {
      a.add(GlobalKey());
    }
    setState(() {});
  }

  var visibleItemsindex;
  var preVisibleItemsindex = 0;

  void visibleItems() {
    var items = itemPositionsListener.itemPositions.value
        .where((element) {
      bool ab = element.itemLeadingEdge >= 0;
      bool cd = element.itemTrailingEdge <= 1;
      return ab && cd;
    })
        .map((e) => e.index)
        .toList();
    items.sort();
    print(items);
    print('${items.first}.....');
    visibleItemsindex = items[0];

    a[visibleItemsindex].currentState?.playvideo();

    if (
        preVisibleItemsindex != visibleItemsindex) {
      a[preVisibleItemsindex].currentState?.stopvideo();
    }
    preVisibleItemsindex = visibleItemsindex;
  }

  @override
  Widget build(BuildContext context) {
    //var wid = MediaQuery.of(context).size.width;
    //var themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yellow Class',
          style: Styles.TxtStyle(
            fontstyle: 'Nunito',
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        //Image.network("https://ci3.googleusercontent.com/mail-sig/AIorK4zCno06OIi10UlosjGRii2OE5WAiGVph1ygYKmpyu-wltT4SAPky9FrkbuZHaC36eCoSNpgXrA", width: wid/3),
        //backgroundColor:themeData.scaffoldBackgroundColor ,

        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_outlined,
              )),
          IconButton(
              onPressed: () {
                (themechange.value == 0)
                    ? themechange.value = 1
                    : themechange.value = 0;
              },
              icon: ValueListenableBuilder(
                builder: (BuildContext context, int value, Widget? child) {
                  return (value == 0)
                      ? const Icon(Icons.flare)
                      : const Icon(
                    Icons.bedtime,
                  );
                },
                valueListenable: themechange,
              )),
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundColor: Colors.grey[300],
              backgroundImage: const NetworkImage(
                  "https://randomuser.me/api/portraits/men/44.jpg"),
            ),
          ),
        ],
      ),
      body: (videos.length != 0)
          ? ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          Video video = videos[index];
          return VideoTile(
            video,
            key: a[index],
          );
        },
      )
          : CircularProgressIndicator(),
    );
  }
}
