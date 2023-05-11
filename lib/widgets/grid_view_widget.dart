import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_order/appcolors/app_colors.dart';
import 'package:food_order/pages/details/details_page.dart';
import 'package:food_order/route/routing_page.dart';
import 'package:food_order/widgets/single_product.dart';

class GridViewWidget extends StatefulWidget {
  final String id;
  final String collection;
  final String subCollection;

  const GridViewWidget({
    Key? key,
    required this.collection,
    required this.id,
    required this.subCollection,
  }) : super(key: key);

  @override
  State<GridViewWidget> createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {
String query="";
  var result;
  searchFunction(query, searchList) {
    result = searchList.where((element) {
      return element["productName"].toUpperCase().contains(query) ||
          element["productName"].toLowerCase().contains(query) ||
          element["productName"].toUpperCase().contains(query) &&
              element["productName"].toLowerCase().contains(query);
    }).toList();
    return result;
  }




  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        
        child: Container(
         height: 1000,
          width: 400,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(widget.collection)
                .doc(widget.id)
                .collection(widget.subCollection)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshort) {
              if (!snapshort.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
             var varData = searchFunction(query, snapshort.data!.docs);
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 7,
                      shadowColor: Colors.grey[300],
                      child: TextFormField(
                       onChanged: (value){ 
                      setState(() {
                        query=value;
                      });
                        
                       },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          fillColor: AppColors.kwhiteColor,
                          hintText: "Search your product",
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
        
              
                           result.isEmpty
                              ? Center(child: Text("Not found"))
                              : GridView.builder(
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                  itemCount: result.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 5.0,
                                    childAspectRatio: 0.8,
                                  ),
                                  itemBuilder: (ctx, index) {
                                    var data = varData[index];
                                    return SingleProduct(
                                      onTap: () {
                                        RoutingPage.gotonext(
                                          context: context,
                                          navigateTo: DetailsPage(
                                            productCategory:
                                                data["productCategory"],
                                            productId: data["productId"],
                                            productImage: data["productImage"],
                                            productName: data["productName"],
                                            productOldPrice:
                                                data["productOldPrice"],
                                            productPrice: data["productPrice"],
                                            productRate: data["productRate"],
                                            productDescription:
                                                data["productDescription"],
                                          ),
                                        );
                                      },
                                      productId: data["productId"],
                                      productCategory: data["productCategory"],
                                      productName: data["productName"],
                                      productImage: data["productImage"],
                                      productOldPrice: data["productOldPrice"],
                                      productPrice: data["productPrice"],
                                      productRate: data["productRate"],
                                    );
                                  },
                                ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
