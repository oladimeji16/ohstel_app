import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_market_place/methods/market_methods.dart';
import 'package:Ohstel_app/hostel_market_place/models/product_model.dart';
import 'package:Ohstel_app/hostel_market_place/pages/all_categories_page.dart';
import 'package:Ohstel_app/hostel_market_place/pages/market_cart_page.dart';
import 'package:Ohstel_app/hostel_market_place/pages/market_search_page.dart';
import 'package:Ohstel_app/hostel_market_place/pages/markets_orders_page.dart';
import 'package:Ohstel_app/hostel_market_place/pages/selected_categrioes_page.dart';
import 'package:Ohstel_app/hostel_market_place/pages/selected_product_page.dart';
import 'package:Ohstel_app/landing_page/profile_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class MarketHomePage extends StatefulWidget {
  @override
  _MarketHomePageState createState() => _MarketHomePageState();
}

class _MarketHomePageState extends State<MarketHomePage> {
  String uniName;
  bool isLoading = true;
  Map userData;
  Box marketBox;
  int _current = 0;
  List _imgList = [1, 2, 3, 4];
  TextStyle _tabBarStyle = TextStyle(color: Colors.black);

  Future<void> getUserData() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });
    userData = await HiveMethods().getUserData();
    marketBox = await HiveMethods().getOpenBox('marketCart');
    String name = await HiveMethods().getUniName();
    print(name);
    uniName = name;

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: ListView(
                    children: <Widget>[
                      appBar(),
                      SizedBox(height: 2),
                      searchBar(),
                      SizedBox(height: 16),
                      advertBanner(),
                      categories(),
                      SizedBox(height: 24),
                      tabBar(),
                      SizedBox(height: 8),
                      tabBarView(),
                      SizedBox(height: 8),
                      topBrands(),
                      SizedBox(height: 16),
                      recommended4U(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget popMenu() {
    return PopupMenuButton(
        onSelected: (value) {
          if (value == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MarketCartPage(),
              ),
            );
          } else if (value == 2) {
            print(userData['uid']);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MarketOrdersPage(),
              ),
            );
          }
//          Fluttertoast.showToast(
//            msg: "You have selected " + value.toString(),
//            toastLength: Toast.LENGTH_SHORT,
//            gravity: ToastGravity.BOTTOM,
//            backgroundColor: Colors.black,
//            textColor: Colors.white,
//            fontSize: 16.0,
//          );
        },
        itemBuilder: (context) => [
              PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(Icons.add_shopping_cart),
                      ),
                      Text('Cart')
                    ],
                  )),
              PopupMenuItem(
                  value: 2,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                        child: Icon(Icons.history),
                      ),
                      Text('Orders')
                    ],
                  )),
            ]);
  }

  Widget recommended4U() {
    return Container(
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recommended for you",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(child: latestProduct()),
          SizedBox(height: 8),
          Expanded(child: latestProduct()),
        ],
      ),
    );
  }

  Widget appBar() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.blueGrey[400],
                radius: 25,
                child: userData['profilePicUrl'] == null
                    ? Icon(Icons.person, color: Color(0xffebf1ef))
                    : ExtendedImage.network(
                        userData['profilePicUrl'],
                        fit: BoxFit.fill,
                        handleLoadingProgress: true,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(160),
                        cache: false,
                        enableMemoryCache: true,
                      ),
              ),
            ),
            Spacer(),
            cartWidget(),
            popMenu()

//                header(),
          ],
        ));
  }

  Widget topBrands() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(color: Color(0xffC4C4C4)),
      width: MediaQuery.of(context).size.width,
      height: 214,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Top Brands",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 25),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
              ),
              CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget tabBar() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            isScrollable: true,
            tabs: <Widget>[
              Tab(
                child: Text(
                  'New in',
                  style: _tabBarStyle,
                ),
              ),
              Tab(
                  child: Text(
                'Best Sell',
                style: _tabBarStyle,
              ))
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              "See All",
              style: _tabBarStyle,
            ),
          )
        ],
      ),
    );
  }

  Widget tabBarView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      height: 160, //
      child: TabBarView(
        children: <Widget>[
          latestProduct(),
          latestProduct(),
        ],
      ),
    );
  }

  Widget latestProduct() {
    return PaginateFirestore(
      scrollDirection: Axis.horizontal,
      itemsPerPage: 3,
      initialLoader: Container(
        height: 50,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      bottomLoader: Center(child: CircularProgressIndicator()),
      shrinkWrap: true,
      query: FirebaseFirestore.instance
          .collection('market')
          .doc('products')
          .collection('allProducts')
          .orderBy('dateAdded', descending: true),
      itemBuilder: (_, context, DocumentSnapshot documentSnapshot) {
//          print(documentSnapshot.data);
        ProductModel currentProductModel =
            ProductModel.fromMap(documentSnapshot.data());
        return Card(
          elevation: 0,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SelectedProductPage(
                    productModel: currentProductModel,
                  ),
                ),
              );
            },
            child: Container(
              height: 153,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: 153,
                      height: 104,
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(color: Colors.black12),
                            child: ExtendedImage.network(
                              currentProductModel.imageUrls[0],
                              fit: BoxFit.fill,
                              handleLoadingProgress: true,
                              shape: BoxShape.rectangle,
                              cache: false,
                              enableMemoryCache: true,
                            ),
                          ),
                          Positioned(
                              bottom: 7,
                              right: 7,
                              child: SvgPicture.asset("asset/Shape.svg"))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      width: 153,
                      height: 46,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child:
                                  Text('${currentProductModel.productName}')),
                          Expanded(
                            child: Text(
                              '\₦${currentProductModel.productPrice}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }, itemBuilderType: dynamic,
    );
  }

  Widget categories() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Top Categories',
                  style: TextStyle(fontSize: 16),
                ),
                InkWell(
                  child: Container(
                    child: Text('See All'),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AllCategories(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 210,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
                future: MarketMethods().getAllCategories(),
                builder: (context, snapshot) {
                  List<Map> currentDataList = snapshot.data;
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (currentDataList.isEmpty) {
                      return Container(
                        child: Center(
                          child: Text('Empty'),
                        ),
                      );
                    }
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: GridView.count(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        children: List.generate(
                          currentDataList.length,
                          (index) {
                            Map currentData = snapshot.data[index];
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SelectedCategoriesPage(
                                      title: currentData['searchKey'],
                                      searchKey: currentData['searchKey'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: ExtendedImage.network(
                                  currentData['imageUrl'],
                                  fit: BoxFit.fill,
                                  handleLoadingProgress: true,
                                  shape: BoxShape.rectangle,
                                  cache: false,
                                  enableMemoryCache: true,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget advertBanner() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 0),
          height: 150,
          width: double.infinity,
          child: Center(
              child: CarouselSlider(
            options: CarouselOptions(
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
              height: 400.0,
              aspectRatio: 2.0,
              initialPage: 0,
              viewportFraction: 0.8,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              pauseAutoPlayOnTouch: true,
              enableInfiniteScroll: false,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            items: _imgList.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(color: Colors.grey),
                    child: Center(
                      child: Text(
                        'image $i',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          )),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(_imgList, (index, url) {
              return Container(
                width: _current == index ? 24 : 11,
                height: 4.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    shape: BoxShape.rectangle,
                    color: _current == index
                        ? Theme.of(context).primaryColor
                        : Colors.black),
              );
            }).toList())
      ],
    );
  }

  Widget searchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(),
      child: MaterialButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MarketSearchPage(),
            ),
          );
        },
        color: Colors.grey[50],
        shape: RoundedRectangleBorder(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.search, color: Colors.black, size: 19),
            SizedBox(width: 24),
            Text(
              'Search',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 17.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        cartWidget(),
      ],
    );
  }

  Widget cartWidget() {
    return Container(
      margin: EdgeInsets.only(right: 5.0),
      child: ValueListenableBuilder(
        valueListenable: marketBox.listenable(),
        builder: (context, Box box, widget) {
          if (box.values.isEmpty) {
            return Container(
              margin: EdgeInsets.only(right: 5.0),
              child: IconButton(
                color: Colors.grey,
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).primaryColor,
                  size: 35,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MarketCartPage(),
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
                      Icons.shopping_cart,
                      color: Theme.of(context).primaryColor,
                      size: 35,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MarketCartPage(),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 5.0,
                  right: 5.0,
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
  }
}
