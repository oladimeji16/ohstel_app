import 'dart:async';

import 'package:Ohstel_app/hive_methods/hive_class.dart';
import 'package:Ohstel_app/hostel_food/_/models/extras_food_details.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_cart_model.dart';
import 'package:Ohstel_app/hostel_food/_/models/food_details_model.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'food_cart_page.dart';


class FoodDialog extends StatefulWidget {
  final List<ExtraItemDetails> currentExtraItemDetails;
  final ItemDetails itemDetails;

  FoodDialog({
    @required this.itemDetails,
    @required this.currentExtraItemDetails,
  });

  @override
  _FoodDialogState createState() => _FoodDialogState();
}

class _FoodDialogState extends State<FoodDialog> {
  final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "");
  Box cartBox;
  bool isLoading = true;

  Runes input = Runes('\u20a6');
  var symbol;
  StreamController<List<ExtraItemDetails>> extraListController =
      StreamController();
  String selectedExtras;
  List<ExtraItemDetails> extraList = [];
  int totalPrice;
  int numberOfPlates = 1;

  void getCart() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });
    cartBox = await HiveMethods().getOpenBox('cart');
    setState(() {
      isLoading = false;
    });
  }

  int getTotal() {
    int _initialTotal = widget.itemDetails.price;

    if (extraList.isEmpty) {
      return _initialTotal * numberOfPlates;
    } else {
      int _total = _initialTotal;
      for (ExtraItemDetails extra in extraList) {
        _total = _total + extra.price;
      }
      return _total * numberOfPlates;
    }
  }

  @override
  void dispose() {
    extraListController.close();
    super.dispose();
  }

  @override
  void initState() {
    getCart();
    super.initState();
    symbol = String.fromCharCodes(input);
  }

  @override
  Widget build(BuildContext context) {
//    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
        actions: [
          cartWidget(),
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: ListView(
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text(
                          "${widget.itemDetails.itemFastFoodName}",
                          style: TextStyle(fontSize: 24),
                        )),
                    widget.itemDetails.imageUrl != null
                        ? Container(
                            //  margin: const EdgeInsets.all(10.0),
                            height: 200,
                            width: double.infinity,
                            child: ExtendedImage.network(
                              widget.itemDetails.imageUrl,
                              fit: BoxFit.fitWidth,
                              handleLoadingProgress: true,
                              shape: BoxShape.rectangle,
                              cache: false,
                              enableMemoryCache: true,
                            ),
                          )
                        : Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
//                        padding: EdgeInsets.symmetric(horizontal: 1.5),
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: numberOfPlates == 1
                                    ? Colors.grey
                                    : Color(0xFFF27507),
                              ),
                            ),
                            child: InkWell(
                              child: Icon(
                                Icons.remove,
                                color: numberOfPlates == 1
                                    ? Colors.grey
                                    : Color(0xFFF27507),
                              ),
                              onTap: () {
                                if (numberOfPlates > 1) {
                                  if (mounted) {
                                    setState(() {
                                      numberOfPlates--;
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                          Text('$numberOfPlates'),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFF27507),
                              ),
                            ),
                            child: InkWell(
                              child: Icon(
                                Icons.add,
                                color: Color(0xFFF27507),
                              ),
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    numberOfPlates++;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${widget.itemDetails.itemName}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '$symbol ${formatCurrency.format(getTotal())}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      constraints: BoxConstraints(minWidth: 90),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.alarm,
                                  color: Color(0xFFF27507),
                                  size: 16,
                                ),
                                Text(
                                  "delivery time will be here",
                                  style: TextStyle(color: Color(0xFFF27507)),
                                )
                              ],
                            ),
                          ),
                          Text("Ratings will be here")
                        ],
                      ),
                    ),
                    widget.currentExtraItemDetails.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              elevation: 1.5,
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                //     constraints: BoxConstraints(maxHeight: 150),
                                margin: EdgeInsets.all(10.0),
                                child: extraItemWidget(),
                              ),
                            ),
                          )
                        : Container(),
                    widget.currentExtraItemDetails.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                            margin: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton(
                              underline: Container(),
                              hint: extraList.isEmpty
                                  ? Text('Select Extras')
                                  : Text('Add More Extras'),
                              items: widget.currentExtraItemDetails
                                  .map((ExtraItemDetails element) {
                                return DropdownMenuItem<String>(
                                  value: element.extraItemName,
                                  child: Text('${element.extraItemName}'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  print(value);
                                  selectedExtras = value;
                                  extraList.add(
                                    widget.currentExtraItemDetails
                                        .where((element) =>
                                            element.extraItemName == value)
                                        .toList()[0],
                                  );
                                  setState(() {});
                                  print(selectedExtras);
                                });
                                setState(() {});
                              },
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Description",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${widget.itemDetails.shortDescription}',
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: RaisedButton.icon(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.all(20),
                        onPressed: () {
                          Map map = FoodCartModel(
                            itemDetails: widget.itemDetails,
                            totalPrice: getTotal(),
                            numberOfPlates: numberOfPlates,
                            extraItems: extraList,
                          ).toMap();
                          HiveMethods().saveFoodCartToDb(map: map);
                        },
                        color: Color(0xFFF27507),
                        label: Text(
                          "Add to Cart",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        icon: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget extraItemWidget() {
    if (extraList == [] || extraList.isEmpty) {
      return Container(
          child: Text(
        'No Extras Selected..',
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey[600],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ));
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: extraList.length,
        itemBuilder: (context, index) {
          ExtraItemDetails extraItem = extraList[index];

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Extra ${extraItem.extraItemName}'),
              Row(
                children: <Widget>[
                  Text('$symbol${extraItem.price}'),
                  InkWell(
                    onTap: () {
                      setState(() {
                        extraList.remove(extraItem);
                      });
                    },
                    child: Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ],
          );
        },
      );
    }
  }

  Widget addDrinkWidget() {
    if (extraList == [] || extraList.isEmpty) {
      return Container(child: Text('Add Extras'));
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: extraList.length,
        itemBuilder: (context, index) {
          ExtraItemDetails extraItem = extraList[index];

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Extra ${extraItem.extraItemName}'),
              Text('$symbol${extraItem.price}'),
            ],
          );
        },
      );
    }
  }

  Widget cartWidget() {
    return Container(
      margin: EdgeInsets.only(right: 5.0),
      child: ValueListenableBuilder(
        valueListenable: cartBox.listenable(),
        builder: (context, Box box, widget) {
          if (box.values.isEmpty) {
            return Container(
              margin: EdgeInsets.only(right: 5.0),
              child: IconButton(
                color: Colors.grey,
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).primaryColor,
                  size: 43,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CartPage(),
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
                      size: 43,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CartPage(),
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
  }
}
