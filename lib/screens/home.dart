import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recruit_test/services/auth_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firestoreInstance = FirebaseFirestore.instance;
  Future testData;





  Future _getTestData() async {
    QuerySnapshot qn = await firestoreInstance.collection("testdata").get();
    print('return fetched docs ${qn.docs}qn');
    return qn.docs;
  }


  //query test data by price = 500 and car = ford
  Future _queryByPriceBrand(var price, var brand) async {
    QuerySnapshot qn = await firestoreInstance.collection("testdata").where("price", isEqualTo: price)
        .where("car", isEqualTo: "$brand").get();
    print('return fetched docs ${qn.docs}qn');
    return qn.docs;
  }

//query documents with price = 400
  Future _queryByPrice(var price) async {
    QuerySnapshot qn = await firestoreInstance.collection("testdata").where("price", isEqualTo: price)
        .get();
    print('return fetched docs ${qn.docs}qn');
    return qn.docs;
  }


@override
  void initState() {
    testData=_getTestData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(
            height: 40,
            width: 100,
            child: IconButton(
              icon: Icon(
                Icons.exit_to_app,
                size: 30,
              ),
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.fromLTRB(10,10,10,0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Query by price = 500 and car = ford'),
                  FlatButton(
                    color: Colors.orange,
                    onPressed: (){
                      setState(() {
                        testData=_queryByPriceBrand(500, 'ford');
                      });

                    },
                    child: Text('Submit Query'),
                  ),
                Text('Query by price = 400'),
                FlatButton(
                  color: Colors.green,
                  onPressed: (){
                    setState(() {
                      testData=_queryByPrice(400);
                    });


                  },
                  child: Text('Submit Query'),
                ),

                Text('Refresh'),
                FlatButton(
                  color: Colors.blue,
                  onPressed: (){
                    setState(() {
                      testData=_getTestData();
                    });


                  },
                  child: Text('Refresh'),
                ),


                Container(
                    child: Expanded(
                      child: FutureBuilder(
                          future: testData,
                          builder: (_, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: Text('Loading..'),
                              );
                            } else {
                              return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (_, index) {
                                    return ListTile(
                                      title: Text(
                                          '${snapshot.data[index].get('car')}'),
                                      subtitle: Text(
                                          'Price: ${snapshot.data[index].get('price')}'),
                                    );
                                  });
                            }
                          }),
                    )),
              ],
            ),
          )),
    );
  }


}
