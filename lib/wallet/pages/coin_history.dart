import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../../utilities/app_style.dart';
import '../../hive_methods/hive_class.dart';
import '../method.dart';
import '../models/coin_history_model.dart';

class CoinHistoryPage extends StatefulWidget {
  @override
  _CoinHistoryPageState createState() => _CoinHistoryPageState();
}

class _CoinHistoryPageState extends State<CoinHistoryPage> {
  Map userData;
  bool loading = true;

  Future<void> getUserData() async {
    if (!mounted) return;

    setState(() {
      loading = true;
    });
    userData = await HiveMethods().getUserData();
    print(userData);
    print(userData['uid']);

    if (!mounted) return;
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Center(
                child: PaginateFirestore(
                  itemBuilder:
                      (_, BuildContext context, DocumentSnapshot snap) {
                    CoinHistoryModel walletHistory =
                        CoinHistoryModel.fromMap(snap.data());
                    DateTime date = walletHistory.date.toDate();
                    String _dateTime = DateFormat.yMMMd().add_jm().format(date);

                    return Card(
                      elevation: 2.5,
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      '${walletHistory.desc}',
                                      style: TextStyle(
                                        color: textBlack,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Container(
                                    child: Text(
                                      '$_dateTime',
                                      style: TextStyle(
                                        color: textBlack,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${walletHistory.amount}',
                              style: TextStyle(
                                color: walletHistory.type == 'credit'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  query: WalletMethods()
                      .coinHistoryCollectionRef
                      .doc(userData['uid'])
                      .collection('coinHistory')
                      .orderBy('date', descending: true),
                  itemBuilderType: PaginateBuilderType.listView,
                ),
              ),
            ),
    );
  }
}
