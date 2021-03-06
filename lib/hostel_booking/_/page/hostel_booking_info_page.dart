import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_booking/_/methods/hostel_booking_methods.dart';
import 'package:Ohstel_app/hostel_booking/_/model/hostel_model.dart';
import 'package:Ohstel_app/hostel_booking/_/page/booking_home_page.dart';
import 'package:Ohstel_app/hostel_booking/_/page/hostel_booking_inspection_request_page.dart';
import 'package:Ohstel_app/wallet/method.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HostelBookingInFoPage extends StatefulWidget {
  final HostelModel hostelModel;

  HostelBookingInFoPage({@required this.hostelModel});

  @override
  _HostelBookingInFoPageState createState() => _HostelBookingInFoPageState();
}

class _HostelBookingInFoPageState extends State<HostelBookingInFoPage> {
  Map userData;
  int _current = 0;
  bool loading = false;

  Future<void> archivePost() async {
    await HostelBookingMethods().archiveHostel(
      userDetails: userData,
      hostelDetails: widget.hostelModel,
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  Future<void> getUserData() async {
    Map data = await HiveMethods().getUserData();
    print(data);
    userData = data;
  }

  void paymentPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Alert'),
          content: Container(
              child: PaymentPopUp(
            hostelModel: widget.hostelModel,
            userData: userData,
          )
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                children: [
//                  Text(
//                    'The Sum Of NGN ${widget.hostelModel.price} '
//                    'Will Be Deducted From Your Wallet Balance!',
//                    textAlign: TextAlign.center,
//                  ),
//                  SizedBox(height: 20),
//                  TextField(
//                    decoration: InputDecoration(
//                      labelText: 'Password',
//                      hintText: 'Enter Your Password',
//                    ),
//                    obscureText: true,
//                    keyboardType: TextInputType.text,
//                    textInputAction: TextInputAction.done,
//                    onChanged: (val) {
//                      password = val;
//                    },
//                  ),
//                  SizedBox(height: 20),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: [
//                      FlatButton(
//                        onPressed: () async {
//                          await validateUser(password: password);
//                        },
//                        child: Text('Proceed'),
//                        color: Colors.green,
//                      ),
//                      FlatButton(
//                        onPressed: () {
//                          Navigator.pop(context);
//                        },
//                        child: Text('Cancel'),
//                        color: Colors.grey,
//                      ),
//                    ],
//                  ),
//                ],
//              ),
              ),
        );
      },
    );
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            body(),
            footer(),
          ],
        ),
      ),
    );
  }

  Widget body() {
    return Expanded(
      child: Container(
        child: Column(
          children: <Widget>[
            Stack(children: [
              displayMultiPic(imageList: widget.hostelModel.imageUrl),
              Positioned(
                  top: 0.0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
//                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Colors.grey[900].withOpacity(0.9),
                          Colors.grey[800].withOpacity(0.9),
                          Colors.grey[800].withOpacity(0.9),
                          Colors.grey[800].withOpacity(0.7),
                          Colors.grey[800].withOpacity(0.6),
                          Colors.grey[800].withOpacity(0.2),
                          Colors.transparent
                        ])),
                  )),
              Container(
                padding: EdgeInsets.only(right: 10, top: 10, left: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 6,
                        child: Text('Hostel Details',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white))),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          archivePost();
                        },
                        child: Center(
                          child: Icon(
                            Icons.bookmark_border,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
            hostelDetails(),
          ],
        ),
      ),
    );
  }

  Widget footer() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: InkWell(
                onTap: () {
                  paymentPopUp();
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: Text(
                    'Make Payment',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: FlatButton(
                color: Colors.transparent,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HostelBookingInspectionRequestPage(
                        hostelModel: widget.hostelModel,
                      ),
                    ),
                  );
                },
                child: Text('Request Inspection'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget hostelDetails() {
    TextStyle _titlestyle =
        TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    return DefaultTabController(
      length: 2,
      child: Expanded(
        child: Container(
//        height: MediaQuery.of(context).size.height * 0.36,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '${widget.hostelModel.hostelName}',
                    style: _titlestyle,
                  ),
                  Spacer(),
                  Text(
                    '₦${formatCurrency.format(widget.hostelModel.price)}',
                    style: _titlestyle,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Text('${widget.hostelModel.hostelLocation}'),
                  Spacer(),
                  Text(widget.hostelModel.isSchoolHostel
                      ? 'Roommate Needed'
                      : 'Roomate not Needed')
                ],
              ),
              SizedBox(height: 8),
              Row(children: <Widget>[
                Icon(
                  Icons.location_on,
                  size: 16,
                ),
                Text(
                    '${widget.hostelModel.distanceFromSchoolInKm.toLowerCase().contains('km') ? widget.hostelModel.distanceFromSchoolInKm + ' from Unilorin' : widget.hostelModel.distanceFromSchoolInKm + 'KM from Unilorin'}'),
                Spacer(),
                Text("12/12/2020")
              ]),
              SizedBox(height: 16),
              Container(
                child: TabBar(
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        'Details',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Tab(
                        child: Text(
                      'Reviews',
                      style: TextStyle(color: Colors.black),
                    ))
                  ],
                ),
              ),
              Container(
//                  height: MediaQuery.of(context).size.height * 0.13,
                  child: Expanded(
                child: TabBarView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                          child: Text('${widget.hostelModel.description}')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                          child: Text(
                              'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat')),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget displayMultiPic({@required List imageList}) {
    List imgs = imageList.map(
      (images) {
        return Container(
          child: ExtendedImage.network(
            images,
            fit: BoxFit.fill,
            handleLoadingProgress: true,
            shape: BoxShape.rectangle,
            cache: false,
            enableMemoryCache: true,
          ),
        );
      },
    ).toList();
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.474,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            child: CarouselSlider(
              items: imgs,
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
                height: 310.0,
                aspectRatio: 2.0,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: false,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: map<Widget>(imageList, (index, url) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index ? Colors.grey : Colors.black),
                );
              }).toList())
        ],
      ),
    );
  }
}

class PaymentPopUp extends StatefulWidget {
  final HostelModel hostelModel;
  final Map userData;

  PaymentPopUp({
    @required this.hostelModel,
    @required this.userData,
  });

  @override
  _PaymentPopUpState createState() => _PaymentPopUpState();
}

class _PaymentPopUpState extends State<PaymentPopUp> {
  bool loading = false;

  Future<void> savePaidDataToServer() async {
    int result = await HostelBookingMethods().savePaidHostelDetailsDetails(
      fullName: widget.userData['fullName'],
      phoneNumber: widget.userData['phoneNumber'],
      email: widget.userData['email'],
      price: widget.hostelModel.price,
      hostelDetails: widget.hostelModel,
    );

    if (result == 0) {
      Fluttertoast.showToast(
        msg: 'Sent Sucessfully!!',
        gravity: ToastGravity.CENTER,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'An Error Occur :(',
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> validateUser({@required String password}) async {
    Map userDate = await HiveMethods().getUserData();

    await AuthService()
        .loginWithEmailAndPassword(
      email: userDate['email'],
      password: password,
    )
        .then((value) async {
      print(value);
      print('vvvvvvvvvvvvvvvvv');
      if (value != null) {
        await pay();
      }
    });
  }

  Future<void> pay() async {
    int result = await WalletMethods().deductWallet(
      amount: widget.hostelModel.price.toDouble(),
      payingFor: 'hostel',
      itemId: widget.hostelModel.id,
    );
    print(result);
    print(';;;;;;;;;;;;;;;;;;;;;;;;;;');
    if (result == 0) {
      savePaidDataToServer();
    }
  }

  @override
  Widget build(BuildContext context) {
    String password;
    return Container(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'The Sum Of NGN ${widget.hostelModel.price} '
              'Will Be Deducted From Your Wallet Balance!',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter Your Password',
              ),
              obscureText: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onChanged: (val) {
                password = val;
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    await validateUser(password: password);
                    setState(() {
                      loading = false;
                    });
                  },
                  child:
                      loading ? CircularProgressIndicator() : Text('Proceed'),
                  color: Colors.green,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
