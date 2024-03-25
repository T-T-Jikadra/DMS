// ignore_for_file: camel_case_types, depend_on_referenced_packages, deprecated_member_use
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../admin_manage_alerts_screen/admin_alert_details_screen.dart';
import '../../Utils/common_files/alerts/alert_history_screen.dart';
import '../../../Components/Notification_related/notification_services.dart';
import '../../../Utils/Utils.dart';
import 'package:intl/intl.dart';

class commonbg_admin extends StatefulWidget {
  const commonbg_admin({super.key});

  @override
  State<commonbg_admin> createState() => _commonbg_adminState();
}

class _commonbg_adminState extends State<commonbg_admin> {
  NotificationServices notificationServices = NotificationServices();
  String fetchedState = "";
  String fetchedCity = "";
  bool isFetched = false;

  @override
  void initState() {
    super.initState();
    fetchCitizenData();
    Future.delayed(const Duration(milliseconds: 1600), () {
      setState(() {
        isFetched = true;
      });
    });
    //for notification permission pop up
    notificationServices.requestNotificationPermission();
    //listen to  incoming msg...
    // notificationServices.firebaseInit(context);

    //for  notification when background and terminated case of application
    notificationServices.setupInteractMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white12,
        body: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: const SizedBox(),
              ),
            ),

            //home design
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 80, top: 20),
                    //location
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            color: Colors.redAccent, size: 18),
                        const SizedBox(width: 8),
                        isFetched
                            ? const Text(
                                "INDIA",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            : const SpinKitThreeBounce(
                                color: Colors.blueGrey,
                                size: 20,
                              ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: SvgPicture.asset("assets/images/logo_svg.svg",
                              height: 33, width: 33),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  //latest alert
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 3),
                                const Text(
                                  "Latest alerts :",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                TextButton(
                                    child: const Row(
                                      children: [
                                        Text("View More",
                                            style: TextStyle(
                                              color: Colors.teal,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                            )),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(Icons.arrow_forward,
                                            color: Colors.teal),
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              const Alert_History_Screen(),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            var begin = const Offset(1.0, 0.0);
                                            var end = Offset.zero;
                                            var curve = Curves.ease;

                                            var tween = Tween(
                                                    begin: begin, end: end)
                                                .chain(
                                                    CurveTween(curve: curve));
                                            var offsetAnimation =
                                                animation.drive(tween);

                                            return SlideTransition(
                                              position: offsetAnimation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    }),
                              ],
                            ),
                            //Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("clc_alert")
                            //.where("contactNumber", isEqualTo: mobileNo)
                            .orderBy('sentTime', descending: true)
                            .limit(5)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData) {
                              return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 7, right: 7, top: 10),
                                  child: snapshot.data!.docs.isEmpty
                                      ? const Center(
                                          child: Text(
                                            'No records found for an alert !',
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.33,
                                          width: double.infinity,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              String level = snapshot
                                                  .data!.docs[index]['level'];
                                              Color cardColor =
                                                  getColorForLevel(level);
                                              //snapshot.data!.docs[index]['sentTime'];
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    PageRouteBuilder(
                                                      pageBuilder: (context,
                                                              animation,
                                                              secondaryAnimation) =>
                                                          Admin_Alert_Details_Screen(
                                                        documentSnapshot:
                                                            snapshot.data!
                                                                .docs[index],
                                                      ),
                                                      transitionsBuilder:
                                                          (context,
                                                              animation,
                                                              secondaryAnimation,
                                                              child) {
                                                        var begin =
                                                            const Offset(
                                                                1.0, 0.0);
                                                        var end = Offset.zero;
                                                        var curve = Curves.ease;

                                                        var tween = Tween(
                                                                begin: begin,
                                                                end: end)
                                                            .chain(CurveTween(
                                                                curve: curve));
                                                        var offsetAnimation =
                                                            animation
                                                                .drive(tween);

                                                        return SlideTransition(
                                                          position:
                                                              offsetAnimation,
                                                          child: child,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.75,
                                                  child: Card(
                                                    color: cardColor,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 13,
                                                            left: 7,
                                                            right: 7),
                                                    // Set margin to zero to remove white spaces
                                                    elevation: 3,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      7),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ListTile(
                                                                leading:
                                                                    CircleAvatar(
                                                                  maxRadius: 14,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey,
                                                                  child: Text(
                                                                      "${index + 1}"),
                                                                ),
                                                                title: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index]['typeofDisaster'],
                                                                        style: const TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.black,
                                                                        )),
                                                                    const SizedBox(
                                                                        height:
                                                                            3),
                                                                    Text(
                                                                        "${snapshot.data!.docs[index]['state']} \t"
                                                                        " ${snapshot.data!.docs[index]['city']}",
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              13,
                                                                        )),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 10),
                                                              const Divider(
                                                                  height: 2,
                                                                  color: Colors
                                                                      .black54),
                                                              const SizedBox(
                                                                  height: 10),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                child: SizedBox(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.65,
                                                                  child: Text(
                                                                      snapshot.data!.docs[
                                                                              index]
                                                                          [
                                                                          'description'],
                                                                      maxLines:
                                                                          5,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .justify,
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                              15)),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 5),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            15,
                                                                        top: 5),
                                                                child: Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Level : ",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                        snapshot.data!.docs[index]
                                                                            [
                                                                            'level'],
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold)),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 4),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            10,
                                                                        bottom:
                                                                            3),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    const Icon(
                                                                        Icons
                                                                            .watch_later_outlined,
                                                                        size:
                                                                            16,
                                                                        color: Colors
                                                                            .black54),
                                                                    const SizedBox(
                                                                        width:
                                                                            3),
                                                                    Text(
                                                                        DateFormat('dd-MM-yyyy , HH:mm').format(DateTime.parse(snapshot.data!.docs[index]
                                                                            [
                                                                            'sentTime'])),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black54,
                                                                            fontSize: 12)),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ));
                            }
                          } else if (snapshot.hasError) {
                            showToastMsg(snapshot.hasError.toString());
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        }),
                  ),
                  const SizedBox(height: 15),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchCitizenData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Fetch data from Firestore
      DocumentSnapshot citizenSnapshot = await FirebaseFirestore.instance
          .collection('clc_citizen')
          .doc(user?.phoneNumber)
          .get();

      // Check if the document exists
      if (citizenSnapshot.exists) {
        // Access the fields from the document
        setState(() {
          fetchedState = citizenSnapshot.get('state');
          fetchedCity = citizenSnapshot.get('city');
        });
      } else {
        if (kDebugMode) {
          print('Document does not exist');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
    }
  }
}