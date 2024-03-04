// ignore_for_file: library_private_types_in_public_api, camel_case_types

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Utils/Utils.dart';
import '../../../Utils/constants.dart';
import 'Govt_ListTile.dart';

class govt_ListofAgency extends StatefulWidget {
  const govt_ListofAgency({Key? key}) : super(key: key);

  @override
  State<govt_ListofAgency> createState() => _govt_ListofAgencyState();
}

class _govt_ListofAgencyState extends State<govt_ListofAgency> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 50,
        backgroundColor: Colors.black12,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25))),
        title: const Text("$appbar_display_name - Govt Agency List"),
      ),
      body: const Column(
        children: [
          SizedBox(height: 10),
          govt_list_widget(),
        ],
      ),
    );
  }
}

class govt_list_widget extends StatefulWidget {
  const govt_list_widget({Key? key}) : super(key: key);

  @override
  _govt_list_widgetState createState() => _govt_list_widgetState();
}

class _govt_list_widgetState extends State<govt_list_widget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("Govt").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return govtListTile(
                              index: "${index + 1}",
                              govtAgencyName: snapshot.data!.docs[index]
                                  ["GovtAgencyName"],
                              regNo: snapshot.data!.docs[index]
                                  ["GovtAgencyRegNo"],
                              serviceList: snapshot.data!.docs[index]
                                  ["services"],
                              contact: snapshot.data!.docs[index]
                                  ["contactNumber"],
                              email: snapshot.data!.docs[index]["email"],
                              website: snapshot.data!.docs[index]["website"],
                              state: snapshot.data!.docs[index]["state"],
                              city: snapshot.data!.docs[index]["city"],
                              pinCode: snapshot.data!.docs[index]["pinCode"],
                              address: snapshot.data!.docs[index]
                                  ["fullAddress"],
                              pwd: snapshot.data!.docs[index]["password"],
                              // Add more fields as needed
                            );
                          }),
                    );
                  }
                } else if (snapshot.hasError) {
                  showToastMsg(snapshot.hasError.toString());
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
                return const Center(child: CircularProgressIndicator());
              }),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    // Simulate a delay for refreshing data
    await Future.delayed(const Duration(milliseconds: 1200));
    setState(() {
      // Update your data here
    });
  }
}