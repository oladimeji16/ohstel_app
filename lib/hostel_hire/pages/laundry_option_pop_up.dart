import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_hire/model/hire_agent_model.dart';
import 'package:Ohstel_app/hostel_hire/model/laundry_basket_model.dart';
import 'package:Ohstel_app/hostel_hire/model/laundry_booking_model.dart';
import 'package:flutter/material.dart';

class LaundryOptionPopUp extends StatefulWidget {
  final LaundryBookingModel laundryDetails;
  final HireWorkerModel hireWorkerDetails;

  LaundryOptionPopUp({
    @required this.laundryDetails,
    @required this.hireWorkerDetails,
  });

  @override
  _LaundryOptionPopUpState createState() => _LaundryOptionPopUpState();
}

class _LaundryOptionPopUpState extends State<LaundryOptionPopUp> {
  String dropdownValue = 'Wash Only';
  int unitValue = 1;

  Future<void> saveToBasket() async {
    LaundryBookingBasketModel laundry = LaundryBookingBasketModel(
      clothTypes: widget.laundryDetails.clothTypes,
      imageUrl: widget.laundryDetails.imageUrl,
      units: unitValue,
      laundryMode: dropdownValue,
      price: price(),
      laundryPersonName: widget.hireWorkerDetails.workerName,
      laundryPersonEmail: widget.hireWorkerDetails.workerEmail,
      laundryPersonUniName: widget.hireWorkerDetails.uniName,
      laundryPersonPhoneNumber: widget.hireWorkerDetails.workerPhoneNumber,
    );
    print(laundry.toMap());

    await HiveMethods().saveLaundryToBasketCart(data: laundry.toMap());
  }

  int price() {
    Map laundryModeAndPrice = widget.laundryDetails.laundryModeAndPrice;
    int currentSelectedPrice = (laundryModeAndPrice[dropdownValue] * unitValue);

    return currentSelectedPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.laundryDetails.clothTypes.toUpperCase()}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          dropDown(),
          unitController(),
          priceWidget(),
          addToCartButton(),
        ],
      ),
    );
  }

  Widget addToCartButton() {
    return FlatButton(
      color: Colors.green,
      onPressed: () {
        saveToBasket();
      },
      child: Text('Add To Basket'),
    );
  }

  Widget priceWidget() {
    return Container(
      margin: EdgeInsets.all(15.0),
      child: Text(
        'Price: NGN ${price()}',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
      ),
    );
  }

  Widget unitController() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: InkWell(
              child: Icon(Icons.remove),
              onTap: () {
                if (unitValue > 1) {
                  setState(() {
                    unitValue--;
                  });
                }
              },
            ),
          ),
          Text('$unitValue'),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: InkWell(
              child: Icon(Icons.add),
              onTap: () {
                if (unitValue < 99) {
                  setState(() {
                    unitValue++;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget dropDown() {
    return Container(
      child: DropdownButton(
          value: dropdownValue,
          items: [
            DropdownMenuItem(
              child: Text("Wash Only"),
              value: 'Wash Only',
            ),
            DropdownMenuItem(
              child: Text("Wash And Iron"),
              value: 'Wash and Iron',
            ),
            DropdownMenuItem(
              child: Text("Dry Clean"),
              value: 'Dry Clean',
            ),
          ],
          onChanged: (value) {
            setState(() {
              dropdownValue = value;
            });
          }),
    );
  }
}
