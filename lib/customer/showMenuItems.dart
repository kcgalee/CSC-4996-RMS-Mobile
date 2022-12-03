/*
showMenuItems.dart is a customer side page that shows the menu options of the chosen menu category from the Menu page
menu options open up to show menu details and is able to be added to order
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_management_system/customer/viewOrder.dart';
import 'package:counter/counter.dart';
import 'package:restaurant_management_system/widgets/customTextForm.dart';
import '../widgets/customSubButton.dart';
import 'Models/createOrderInfo.dart';
import 'customerHome.dart';

/*
This page displays all of the menu items which are apart of the category
selected on the order page.  Each tile is tappable, the user will select
the quantity and leave a comment to add an item to their order.
 */

class ShowMenuItems extends StatefulWidget {
  final String text, restName;
  final int priority;
  final CreateOrderInfo createOrderInfo;

  const ShowMenuItems(
      {Key? key,
      required this.text,
      required this.restName,
      required this.priority,
      required this.createOrderInfo})
      : super(key: key);

  @override
  State<ShowMenuItems> createState() => _ShowMenuItems();
}

class _ShowMenuItems extends State<ShowMenuItems> {


  final orderCommentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.text.toUpperCase()),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewOrder(
                              createOrderInfo: widget.createOrderInfo)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
          ],
        ),

        //=====================================
        //Customer User Document Stream Builder
        //=====================================
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (context, userSnapshot) {
              //Check for data in document
              if (userSnapshot.hasData) {
                //===============================
                //ERROR HANDLING FOR CLOSED TABLE
                //===============================

                if (userSnapshot.data!['tableID'] == '') {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text('Table Closed')
                      ),
                      CustomSubButton(
                        text: "Back to Home Page",
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CustomerHome()));
                        },
                      ),
                    ],
                  );
                }

                //============================
                //Table document Snapshot stream builder
                //=============================
                return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('tables')
                        .doc(userSnapshot.data!['tableID'])
                        .snapshots(),
                    builder: (context, tableSnapshot) {
                      if (tableSnapshot.hasData) {
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection(
                                    'restaurants/${tableSnapshot.data!['restID']}/menu')
                                .where('category', isEqualTo: widget.text)
                                .snapshots(),
                            builder: (context, menuSnapshot) {
                              if (!menuSnapshot.hasData ||
                                  menuSnapshot.data?.docs.length == 0) {
                                return const Center(
                                  child: Text("No items to display."),
                                );
                              } else {
                                return ListView.builder(
                                    itemCount: menuSnapshot.data?.docs.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 20, right: 20),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10.0),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: Colors.grey,
                                                        blurRadius: 2.0,
                                                        offset: Offset(2.0, 2.0))
                                                  ]),
                                              child: ListTile(
                                                title: Padding(
                                                  padding: EdgeInsets.only(top: 5, bottom: 10),
                                                  child: Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(20), // Image border
                                                        child: SizedBox.fromSize(
                                                          size: const Size.fromRadius(25), // Image radius
                                                          child:   FadeInImage(
                                                              placeholder: const AssetImage('assets/images/RMS_logo.png'),
                                                              image: menuSnapshot.data?.docs[index]['imgURL'] != '' ?
                                                              NetworkImage(menuSnapshot.data?.docs[index]['imgURL']) : AssetImage('assets/images/RMS_logo.png') as ImageProvider,
                                                              fit: BoxFit.cover
                                                          ),
                                                        ),
                                                      ),


                                                      const SizedBox(width: 10),
                                                      SizedBox(
                                                          width: MediaQuery.of(context).size.height * 0.25,
                                                        child: Expanded(
                                                            child: Text(menuSnapshot
                                                                .data?.docs[index]
                                                            ['itemName'] ??
                                                                '',
                                                            )
                                                        )
                                                      ),

                                                      const Spacer(),

                                                      if(menuSnapshot.data?.docs[index]['price'] == '0.00')
                                                        const Text('\nFree\n'),

                                                      if(menuSnapshot.data?.docs[index]['price'] != '0.00')
                                                        Text('\$' + (menuSnapshot
                                                            .data?.docs[index]
                                                        ['price'] ??
                                                            '\n')),
                                                    ],
                                                  ),
                                                ),
                                                onTap: () {
                                                  orderCommentsController.clear();
                                                  int? count = 0;
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return
                                                        Scaffold(
                                                          resizeToAvoidBottomInset: false, // set it to false
                                                          body: SingleChildScrollView(
                                                              child: Expanded(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment.end,
                                                                    children: [
                                                                      SingleChildScrollView(
                                                                          child: AlertDialog(
                                                                            insetPadding:
                                                                            EdgeInsets.zero,
                                                                            content: Builder(
                                                                              builder: (context) {
                                                                                String dietRestrictionsString = dietRestrictions(menuSnapshot.data?.docs[index]['isGlutenFree'],
                                                                                    menuSnapshot.data?.docs[index]['isHalal'], menuSnapshot.data?.docs[index]['isKosher'],
                                                                                    menuSnapshot.data?.docs[index]['isLactose'], menuSnapshot.data?.docs[index]['isNuts'],
                                                                                    menuSnapshot.data?.docs[index]['isPescatarian'], menuSnapshot.data?.docs[index]['isVegan'],
                                                                                    menuSnapshot.data?.docs[index]['isVegetarian']);
                                                                                var price = 'Free';
                                                                                if(menuSnapshot.data?.docs[index]['price'] != '0.00') {
                                                                                  price = '\$' + menuSnapshot.data?.docs[index]['price'];
                                                                                }

                                                                                return Padding(
                                                                                  padding: const EdgeInsets.only(top: 15,),
                                                                                  child: SizedBox(
                                                                                      height: MediaQuery.of(context).size.height*0.8,
                                                                                      width: MediaQuery.of(context).size.width,
                                                                                      child: Column(
                                                                                          children: [
                                                                                            if (menuSnapshot.data?.docs[index]['imgURL'] !=
                                                                                                '')
                                                                                              SizedBox(
                                                                                                height:
                                                                                                MediaQuery.of(context).size.height *0.3 ,
                                                                                                width:
                                                                                                MediaQuery.of(context).size.width,
                                                                                                child:
                                                                                                Image.network(menuSnapshot.data?.docs[index]['imgURL'], fit: BoxFit.cover,)
                                                                                              ),

                                                                                            const SizedBox(height: 10),
                                                                                            Row(
                                                                                              children: [
                                                                                                SizedBox(
                                                                                                  width: MediaQuery.of(context).size.height * 0.3,
                                                                                                  child: Expanded(
                                                                                                      child: Text(
                                                                                                        menuSnapshot.data?.docs[index]['itemName'],
                                                                                                        style:
                                                                                                        const TextStyle(
                                                                                                          fontWeight:
                                                                                                          FontWeight.bold,
                                                                                                          fontSize:
                                                                                                          20,
                                                                                                        ),
                                                                                                        textAlign: TextAlign.left,
                                                                                                      )
                                                                                                  )
                                                                                                ),
                                                                                                const Spacer(),
                                                                                                Text(
                                                                                                  price,
                                                                                                  style:
                                                                                                  const TextStyle(
                                                                                                    fontWeight:
                                                                                                    FontWeight.bold,
                                                                                                    fontSize:
                                                                                                    20,
                                                                                                  ),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            const SizedBox(height: 10),
                                                                                            Row(
                                                                                              children: [
                                                                                                SizedBox(
                                                                                                  width: 330,
                                                                                                  child: Text(menuSnapshot.data?.docs[index]['description'],
                                                                                                  ),
                                                                                                )
                                                                                              ],
                                                                                            ),

                                                                                            //Display dietaryRestrictions
                                                                                            if(dietRestrictionsString != '')
                                                                                              const SizedBox(height: 10),
                                                                                            Expanded(
                                                                                                child: Align(
                                                                                                  alignment: FractionalOffset.bottomCenter,
                                                                                                  child: Row(
                                                                                                    children: [
                                                                                                      SizedBox(
                                                                                                        width: 330,
                                                                                                        child: Text(dietRestrictionsString,
                                                                                                            textAlign: TextAlign.left),
                                                                                                      )
                                                                                                    ],
                                                                                                  ),
                                                                                                )
                                                                                            ),
                                                                                            Expanded(
                                                                                                child: Align(
                                                                                                    alignment: FractionalOffset.bottomCenter,
                                                                                                    child: Container(
                                                                                                        decoration: BoxDecoration(
                                                                                                            border: Border.all(color: Colors.grey)
                                                                                                        ),
                                                                                                      child: CustomTextForm(
                                                                                                          hintText:
                                                                                                          'Optional Order Comments',
                                                                                                          controller:
                                                                                                          orderCommentsController,
                                                                                                          validator:
                                                                                                          null,
                                                                                                          keyboardType: TextInputType
                                                                                                              .text,
                                                                                                          maxLines:
                                                                                                          3,
                                                                                                          maxLength:
                                                                                                          100,
                                                                                                          icon:
                                                                                                          const Icon(Icons.fastfood))
                                                                                                    )
                                                                                                )
                                                                                            )
                                                                                          ])
                                                                                  ),
                                                                                );
                                                                              },
                                                                            ),
                                                                            actions: <Widget>[
                                                                              Row(
                                                                                mainAxisAlignment:
                                                                                MainAxisAlignment
                                                                                    .center,
                                                                                children: [
                                                                                  TextButton(
                                                                                    child: const Text(
                                                                                        "Cancel"),
                                                                                    onPressed:
                                                                                        () {
                                                                                      Navigator.of(
                                                                                          context)
                                                                                          .pop();
                                                                                    },
                                                                                  ),
                                                                                  Counter(
                                                                                    min: 1,
                                                                                    max: 10,
                                                                                    bound: 1,
                                                                                    step: 1,
                                                                                    onValueChanged:
                                                                                        (value) {
                                                                                      count = value
                                                                                      as int?;
                                                                                    },
                                                                                  ),
                                                                                  TextButton(
                                                                                    child: const Text(
                                                                                        "Add to Order"),
                                                                                    onPressed:
                                                                                        () {
                                                                                      //=================================
                                                                                      //ERROR HANDLING FOR BILL REQUESTED
                                                                                      //=================================
                                                                                      if (tableSnapshot
                                                                                          .data![
                                                                                      'billRequested']) {
                                                                                        showDialog<
                                                                                            void>(
                                                                                          context:
                                                                                          context,
                                                                                          barrierDismissible:
                                                                                          false,
                                                                                          // user must tap button!
                                                                                          builder:
                                                                                              (BuildContext
                                                                                          context) {
                                                                                            return AlertDialog(
                                                                                              title:
                                                                                              const Text('Alert!'),
                                                                                              content:
                                                                                              SingleChildScrollView(
                                                                                                child: ListBody(
                                                                                                  children: const <Widget>[
                                                                                                    Text('Bill requested, can not place anymore orders.'),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              actions: <Widget>[
                                                                                                TextButton(
                                                                                                  child: const Text('OK'),
                                                                                                  onPressed: () {
                                                                                                    Navigator.of(context).pop();
                                                                                                  },
                                                                                                ),
                                                                                              ],
                                                                                            );
                                                                                          },
                                                                                        );
                                                                                      }

                                                                                      //=================================
                                                                                      //NO ERRORS PLACE ADD ITEM TO ORDER
                                                                                      //=================================
                                                                                      else {
                                                                                        count ==
                                                                                            null
                                                                                            ? count =
                                                                                        1
                                                                                            : count =
                                                                                            count?.toInt();
                                                                                        var price = double.parse(menuSnapshot
                                                                                            .data
                                                                                            ?.docs[index]['price']);
                                                                                        price = price *
                                                                                            count!;

                                                                                        widget.createOrderInfo.orderSetter(
                                                                                            menuSnapshot.data?.docs[index].id
                                                                                            as String,
                                                                                            count!,
                                                                                            menuSnapshot.data?.docs[index]
                                                                                            [
                                                                                            'itemName'],
                                                                                            price.toStringAsFixed(
                                                                                                2),
                                                                                            orderCommentsController
                                                                                                .text,
                                                                                            widget
                                                                                                .priority,
                                                                                            menuSnapshot
                                                                                                .data
                                                                                                ?.docs[index]['imgURL'] as String,
                                                                                        menuSnapshot.data?.docs[index]['category']
                                                                                        );

                                                                                        Navigator.of(
                                                                                            context)
                                                                                            .pop();

                                                                                        Navigator.push(
                                                                                            context,
                                                                                            MaterialPageRoute(
                                                                                                builder: (context) => ViewOrder(createOrderInfo: widget.createOrderInfo)));
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              const SizedBox(height: 10),
                                                                            ],
                                                                          )
                                                                      ),
                                                                    ],
                                                                  ))
                                                          ),
                                                        );

                                                    },
                                                  );
                                                },
                                              )));
                                    });
                              }
                            });
                      } else {
                        return const Text('No Data to display');
                      }

                      //=====================================
                      //End of REST MENU STREAM BUILDER
                      //=====================================
                    } // end of tableSnapshot builder

                    );
                //================================
                //End of table doc stream builder
                //===============================

              }

              //Display if userSnapshot has no data
              else {
                return const Text('No Data to display');
              }
            } //End of customer User Doc Builder

            ),
        //=====================================
        // End of Customer User Document Stream Builder
        //=====================================
      );
  }

  String dietRestrictions( bool isGlutenFree, bool isHalal, bool isKosher, bool isLactose, bool isNuts,
      bool isPescatarian, bool isVegan, bool isVegetarian){
  String text = '';

  if(isGlutenFree) {
    text = 'Gluten Free, ';
  }
  if(isHalal) {
    text = text + 'Halal, ';
  }
  if(isKosher) {
    text = text + 'Kosher, ';
  }
  if(isLactose) {
    text = text + 'Lactose Free, ';
  }
  if(isNuts) {
    text = text + 'Contains Nuts, ';
  }
  if(isPescatarian) {
    text = text + 'Pescatarian, ';
  }
  if(isVegan) {
    text = text + 'Vegan, ';
  }
  if(isVegetarian) {
    text = text + 'Vegetarian, ';
  }
  if(text != '') {
    text = 'Dietary Labels\n' + text;
  }

  if (text != '') {
    text = text.substring(0, text.length - 2);
  }

  if(text == '') {
    text = 'No dietary options to show';
  }
    return text;
  }
}

