import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../hive_methods/hive_class.dart';
import '../../utilities/app_style.dart';
import '../../utilities/shared_widgets.dart';
import '../model/hire_agent_model.dart';
import 'laundry_basket_page.dart';
import 'select_laundry_page.dart';
//import 'package:url_launcher/url_launcher.dart';

class SelectedHireWorkerPage extends StatefulWidget {
  final HireWorkerModel hireWorker;

  SelectedHireWorkerPage({@required this.hireWorker});

  @override
  _SelectedHireWorkerPageState createState() => _SelectedHireWorkerPageState();
}

class _SelectedHireWorkerPageState extends State<SelectedHireWorkerPage> {
  void book(BuildContext context) {
    if (widget.hireWorker.workType.toLowerCase() == 'laundry') {
      print(widget.hireWorker.laundryList.length);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SelectLaundryPage(
            laundryList: widget.hireWorker.laundryList,
            laundryWork: widget.hireWorker,
          ),
        ),
      );
    }
  }

  Box<Map> laundryBox;
  bool loadingBasket = true;
  Future<void> getBox() async {
    laundryBox = await HiveMethods().getOpenBox('laundryBox');
    setState(() {
      loadingBasket = false;
    });
  }

  @override
  initState() {
    getBox();
    super.initState();
  }

  Widget basketWidget() {
    if (widget.hireWorker.workType.toLowerCase() == 'laundry') {
      if (loadingBasket) return CircularProgressIndicator();
      return Container(
        margin: EdgeInsets.only(right: 5.0),
        child: ValueListenableBuilder(
          valueListenable: laundryBox.listenable(),
          builder: (context, Box box, widget) {
            if (box.values.isEmpty) {
              return Container(
                margin: EdgeInsets.only(right: 5.0),
                child: IconButton(
                  color: Colors.grey,
                  icon: Icon(
                    Icons.shopping_basket,
                    color: childeanFire,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LaundryBasketPage(),
                      ),
                    );
                  },
                ),
              );
            } else {
              int count = box.length;

              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5.0),
                    child: IconButton(
                      color: Colors.grey,
                      icon: Icon(
                        Icons.shopping_basket,
                        color: Theme.of(context).primaryColor,
                        size: 43,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LaundryBasketPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    right: 0.0,
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 24,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Random().nextBool() //TODO: BE Change Random bool to if worker is saved
                  ? Icons.bookmark_border
                  : Icons.bookmark,
            ),
            onPressed: () {},
          ),
          basketWidget(),
        ],
        actionsIconTheme: IconThemeData(
          color: Colors.white,
          size: 24,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          widget.hireWorker.profileImageUrl != null
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: ExtendedImage.network(
                    widget.hireWorker.profileImageUrl,
                    fit: BoxFit.fill,
                    handleLoadingProgress: true,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                    cache: false,
                    enableMemoryCache: true,
                  ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  color: midnightExpress,
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: childeanFire,
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: kToolbarHeight, horizontal: 24),
                ),
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -30),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                  color: Colors.white,
                ),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      //Worker Data
                      Container(
                          margin: const EdgeInsets.fromLTRB(16, 40, 16, 24),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${widget.hireWorker.workerName}',
                                      style: heading2.copyWith(
                                        color: Color(0xFF3A3A3A),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${widget.hireWorker.priceRange ?? 'NA'}',
                                    style: heading2.copyWith(
                                      color: textAnteBlack,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${widget.hireWorker.uniName},',
                                        style: body1,
                                      ),
                                    ),
                                    Text(
                                      '${widget.hireWorker.workerPhoneNumber}',
                                      style: body1,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: textAnteBlack,
                                  ),
                                  SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${widget.hireWorker.uniName}',
                                      style: body2,
                                    ),
                                  ),
                                  Text(
                                    'NA', //TODO: BE change to OPEN PERIOD of hireworker
                                    style: body2,
                                  ),
                                ],
                              ),
                            ],
                          )),

                      //Tab heading
                      Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TabBar(
                          indicatorColor: childeanFire,
                          indicatorWeight: 4.0,
                          labelStyle: body1.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 17),
                          labelColor: textBlack,
                          labelPadding: EdgeInsets.zero,
                          tabs: [
                            Tab(
                                child: Text(
                              "Details",
                            )),
                            Tab(
                                child: Text(
                              "Reviews",
                            )),
                          ],
                        ),
                      ),
                      Divider(height: 0),

                      //Tabs
                      Expanded(
                        child: TabBarView(children: [
                          //Details Tab
                          ListView(
                            primary: true,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            children: [
                              Text(
                                'About',
                                style: body1.copyWith(fontSize: 17),
                              ),
                              SizedBox(height: 4),
                              Text(
                                //TODO: BE change to worker short description
                                'dfjkajdflajd ajdkflkjdlfjasld dkjfladk falkfjdsf ladkjfldsjf lakdjflsadjf lkadjf ldjflkjdskfla jdslkf jsadlkfj alkdsjflkdsj flkjdsfljdslfjls',
                                style: body2.copyWith(
                                  color: Color(0xFF868686),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 24.0, bottom: 16),
                                child: Text(
                                  'Services',
                                  style: body1.copyWith(fontSize: 17),
                                ),
                              ),
                              if (widget.hireWorker.laundryList !=null)
                              Wrap(spacing: 16, runSpacing: 16, children: [
                                //TODO: BE This section should contain icons for the type of services offered by the laundry
                                //But does not exist in the model.
                                //Laundry list used as a place holder.
                                for (int i = 0;
                                    i <
                                            widget.hireWorker?.laundryList
                                                ?.length; 
                                    i++)
                                  if (widget.hireWorker.laundryList[i]
                                          ['imageUrl'] !=
                                      null)
                                    Container(
                                      height: 40,
                                      width: 40,
                                      color: Color(0xFFE7E7E7),
                                      child: Image.network(widget.hireWorker
                                          .laundryList[i]['imageUrl']),
                                    ),
                              ]),
                            ],
                          ),

                          //Reviews Tab
                          ListView.builder(
                            padding: EdgeInsets.fromLTRB(16, 16, 16, 40),
                            itemBuilder: (context, index) {
                              return ReviewDisplayListTile(); //TODO: BE Make a review model and pass object of it into this ...
                            },
                          )
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      extendBody: true,
      bottomNavigationBar: CustomLongButton(
        label: 'Book',
        onTap: () {
          book(context);
        },
      ),
    );
  }
}

class ReviewDisplayListTile extends StatelessWidget {
  const ReviewDisplayListTile({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            child: ExtendedImage.network(
              'url',
              fit: BoxFit.fill,
              handleLoadingProgress: true,
              shape: BoxShape.circle,
              cache: false,
              enableMemoryCache: true,
            ),
            radius: 25,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'Khalid Karem',
                        style: body2.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      '12/07/2020',
                      style: body2.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 4),
                SmoothStarRating(
                  isReadOnly: true,
                  starCount: 5,
                  rating: 3.5,
                  borderColor: midnightExpress,
                  color: midnightExpress,
                  size: 14,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 48.0),
                  child: Text(
                    'Lorem ipsum dolor sit amet. consecteture adipi cing elit.',
                    style: body2.copyWith(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// return loading
//     ? Container(
//         color: Colors.white,
//         child: Center(
//           child: CircularProgressIndicator(),
//         ),
//       )
//     : Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back_ios),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             color: Colors.black,
//           ),
//           backgroundColor: Colors.white,
//           actions: [
//             basketWidget(),
//           ],
//         ),
//         body: body(),
//       );

//   Widget body() {
//     return Container(
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Center(
//               child: Container(
//                 height: 250,
//                 width: MediaQuery.of(context).size.width * 0.85,
//                 decoration: BoxDecoration(
//                   color: Colors.grey,
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                 ),
//                 child: widget.hireWorker.profileImageUrl != null
//                     ? ExtendedImage.network(
//                         widget.hireWorker.profileImageUrl,
//                         fit: BoxFit.fill,
//                         handleLoadingProgress: true,
//                         shape: BoxShape.rectangle,
//                         borderRadius: BorderRadius.circular(10),
//                         cache: false,
//                         enableMemoryCache: true,
//                       )
//                     : Center(
//                         child: Icon(Icons.person),
//                       ),
//               ),
//             ),
//             Column(
//               children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 2.0),
//                   child: Text(
//                     '${widget.hireWorker.userName}',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 2.0),
//                   child: Text(
//                     '${widget.hireWorker.workerPhoneNumber}',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 2.0),
//                   child: Text(
//                     '${widget.hireWorker.workerEmail}',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.symmetric(horizontal: 2.0),
//                   child: Text(
//                     '${widget.hireWorker.workType}',
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//             FlatButton(
//               onPressed: () {
//                 book();
// //                  makeCall();
//               },
//               color: Colors.green,
//               child: Text('Place A Booking'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
