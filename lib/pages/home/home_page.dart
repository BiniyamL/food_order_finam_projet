import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_order/appcolors/app_colors.dart';
import 'package:food_order/model/user_model.dart';
import 'package:food_order/pages/details/details_page.dart';
import 'package:food_order/route/routing_page.dart';
import 'package:food_order/widgets/build_drawer.dart';
import 'package:food_order/widgets/grid_view_widget.dart';
import 'package:food_order/widgets/single_product.dart';


late UserModel userModel;
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  String query = "";
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

  Future getCurrentUserFunction() async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        userModel = UserModel.fromDocument(documentSnapshot);
      } else {
        print("document donot found in the database");
      }
    });
  }

  Widget buildCategory() {
    return Column(
      children: [
        ListTile(
          leading: Text(
            "Categories",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Colors.grey[600],
            ),
          ),
        ),
        Container(
          height: 100,
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("categories").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshort) {
              if (!streamSnapshort.hasData) {
                return Center(child: const CircularProgressIndicator());
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: streamSnapshort.data!.docs.length,
                itemBuilder: (ctx, index) {
                  return Categories(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => GridViewWidget(
                            subCollection: streamSnapshort.data!.docs[index]
                                ["categoryName"],
                            collection: "categories",
                            id: streamSnapshort.data!.docs[index].id,
                          ),
                        ),
                      );
                    },
                    categoryName: streamSnapshort.data!.docs[index]
                        ["categoryName"],
                    image: streamSnapshort.data!.docs[index]["categoryImage"],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // FirebaseFirestore.instance.collection("products").snapshots(),
  Widget buildProduct(
      {required Stream<QuerySnapshot<Map<String, dynamic>>>? stream}) {
    return Container(
      height: 200,
      child: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshort) {
          if (!streamSnapshort.hasData) {
            return Center(child: const CircularProgressIndicator());
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: streamSnapshort.data!.docs.length,
            itemBuilder: (ctx, index) {
              var varData = searchFunction(query, streamSnapshort.data!.docs);

              var data = varData[index];

              return SingleProduct(
                onTap: () {
                  RoutingPage.gotonext(
                    context: context,
                    navigateTo: DetailsPage(
                      productCategory: data["productCategory"],
                      productId: data["productId"],
                      productImage: data["productImage"],
                      productName: data["productName"],
                      productOldPrice: data["productOldPrice"],
                      productPrice: data["productPrice"],
                      productRate: data["productRate"],
                      productDescription: data["productDescription"],
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
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUserFunction();
    return Scaffold(
      drawer: BuildDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 7,
              shadowColor: Colors.grey[300],
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    query = value;
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
          query == ""
              ? Column(
                  children: [
                    buildCategory(),
                    ListTile(
                      leading: Text(
                        "Products",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    buildProduct(
                      stream: FirebaseFirestore.instance
                          .collection("products")
                          .snapshots(),
                    ),
                    ListTile(
                      leading: Text(
                        "Best Sell",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    buildProduct(
                      stream: FirebaseFirestore.instance
                          .collection("products")
                          .where("productRate", isGreaterThan: 3)
                          .orderBy("productRate", descending: true)
                          .snapshots(),
                    ),
                  ],
                )
              : Container(
                  
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot> streamSnapshort) {
                      if (!streamSnapshort.hasData) {
                        return Center(child: const CircularProgressIndicator());
                      }
                      var varData =
                          searchFunction(query, streamSnapshort.data!.docs);
                      return result.isEmpty
                          ? Center(child: Text("Not found"))
                          : GridView.builder(
                            shrinkWrap: true,
                              itemCount: result.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                                childAspectRatio: 0.6,
                              ),
                              itemBuilder: (ctx, index) {
                                var data = varData[index];
                                return SingleProduct(
                                  onTap: () {
                                    RoutingPage.gotonext(
                                      context: context,
                                      navigateTo: DetailsPage(
                                        productCategory: data["productCategory"],
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
                            );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class Categories extends StatelessWidget {
  final String image;
  final String categoryName;
  final Function()? onTap;
  // final Function()? onTap;
  const Categories(
      {required this.categoryName,
      required this.image,
      required this.onTap,
      // required this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(12.0),
        height: 100,
        width: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              image,
            ),
          ),
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black.withOpacity(0.7),
          ),
          child: Center(
            child: Text(
              categoryName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
