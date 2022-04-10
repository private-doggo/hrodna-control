import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import '../../utils/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

void modalBottomSheet(context, String titleStop, String titleDirection) {
  var timestamp;
  var rechargeTimeInMinutes = 60;

  _setTimestamp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    timestamp = DateTime.parse(prefs.getString('timestamp')!);
  }

  _setTimestamp();

  showAlertDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Пожалуйста, попробуйте позже'),
        content: const Text('Оставлять отметку можно не чаще, чем 1 раз за час'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('Ок'),
          ),
        ],
      ),
    );
  }

  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 350,
        width: double.infinity,
        // color: Colors.amber,
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(top: 20),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  titleDirection == ''
                      ? titleStop
                      : '$titleStop ($titleDirection)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Align(
              alignment: const FractionalOffset(0.1, 0.18),
              child: OutlinedButton(
                onPressed: () {
                  if (timestamp != null && DateTime.now().difference(timestamp).inMinutes < rechargeTimeInMinutes) {
                    showAlertDialog(context);
                  }
                  else {
                    FirebaseFirestore.instance
                        .collection(titleStop == ''
                        ? titleStop
                        : '$titleStop ($titleDirection)')
                        .add({'date': DateTime.now(), 'status': true});
                    timestamp = DateTime.now();
                    updateTimestamp(timestamp);
                  }
                },
                style: OutlinedButton.styleFrom(
                  side:
                      BorderSide(width: 1, color: Colors.red.withOpacity(0.5)),
                ),
                child: const Text("Тревожная кнопка"),
              ),
            ),
            Align(
              alignment: const FractionalOffset(0.9, 0.18),
              child: OutlinedButton(
                onPressed: () {
                  if (timestamp != null && DateTime.now().difference(timestamp).inMinutes < rechargeTimeInMinutes) {
                    showAlertDialog(context);
                  }
                  else {
                    FirebaseFirestore.instance
                        .collection(titleStop == ''
                        ? titleStop
                        : '$titleStop ($titleDirection)')
                        .add({'date': DateTime.now(), 'status': false});
                    timestamp = DateTime.now();
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      width: 1, color: Colors.green.withOpacity(0.5)),
                ),
                child: const Text("Отметить \"чисто\""),
              ),
            ),
            Container(
              // alignment: const FractionalOffset(0.9, 0.48),
              margin: const EdgeInsets.only(top: 100),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(titleStop == ''
                        ? titleStop
                        : '$titleStop ($titleDirection)')
                    .orderBy('date', descending: true)
                    .limit(20)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Row(
                          children: [
                            Text(DateFormat('dd MMMM HH:mm')
                                .format(snapshot.data!.docs[i]['date'].toDate())
                                .toString()),
                            const Spacer(),
                            Text(
                              snapshot.data!.docs[i]['status']
                                  ? 'Контроль'
                                  : 'Чисто',
                              style: TextStyle(
                                  color: snapshot.data!.docs[i]['status']
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          ],
                        ),
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        // tileColor: snapshot.data!.docs[i]['status']
                        //     ? Colors.red.withOpacity(0.5)
                        //     : Colors.white,
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                    // separatorBuilder: (BuildContext context, int index) => const Divider(),
                  );

                  // return ListView(
                  //   children: snapshot.data!.docs.map((document) {
                  //     return Container(
                  //       child: Center(child: Text(document['date'].toString())),
                  //     );
                  //   }).toList(),
                  // );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
