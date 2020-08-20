import 'package:Ohstel_app/auth/methods/auth_methods.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Ohstel_app/hostel_booking/_/page/hostel_booking_info_page.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  BoxDecoration _boxDec = BoxDecoration(
      color: Color(0xfff4f5f6), borderRadius: BorderRadius.circular(10));

  TextStyle _tStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.normal);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset("asset/timmy.png"),
            SizedBox(
              height: 16,
            ),
            Row(
              children: <Widget>[
                Text(
                  'Welcome, ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),
                Text(
                  'Timmy',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 30.0),
              child: Container(
                height: 147,
                width: 315,
                child: Image.asset("asset/store.png"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.all(8),
                    decoration: _boxDec,
                    height: 135,
                    width: 162,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("asset/chostel.png"),
                        SizedBox(height: 16),
                        Text(
                          "Hostel",
                          style: _tStyle,
                        )
                      ],
                    )),
                Container(
                    margin: EdgeInsets.all(8),
                    decoration: _boxDec,
                    height: 135,
                    width: 162,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("asset/cfood.png"),
                        SizedBox(height: 16),
                        Text(
                          "Food",
                          style: _tStyle,
                        )
                      ],
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.all(8),
                    decoration: _boxDec,
                    height: 135,
                    width: 162,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("asset/cmarket.png"),
                        SizedBox(height: 16),
                        Text(
                          "Market",
                          style: _tStyle,
                        )
                      ],
                    )),
                Container(
                    margin: EdgeInsets.all(8),
                    decoration: _boxDec,
                    height: 135,
                    width: 162,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("asset/chire.png"),
                        SizedBox(height: 16),
                        Text(
                          "Other Services",
                          style: _tStyle,
                        )
                      ],
                    ))
              ],
            ),
            Text('Account\n SignOut'),
            IconButton(
              icon: Icon(Icons.phonelink_erase),
              onPressed: () async {
                await AuthService().signOut();
              },
            ),
          ],
        ),
      ),
    ));
  }
}
