import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_order/pages/provider/favorite_provider.dart';
import 'package:provider/provider.dart';

class SingleProduct extends StatefulWidget {
  final productId;
  final productCategory;
  final productRate;
  final productOldPrice;
  final productPrice;
  final productImage;

  final productName;
  // final String image;
  // final int price;
  // final String name;
  final Function()? onTap;

  const SingleProduct({
    Key? key,
    required this.productCategory,
    required this.productName,
    required this.productImage,
    required this.productId,
    required this.productOldPrice,
    required this.productPrice,
    required this.productRate,
    // required this.image,
    // required this.name,
    // required this.price,
    required this.onTap,
  }) : super(key: key);

  @override
  State<SingleProduct> createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  bool isFavorite = false;
  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);

 FirebaseFirestore.instance
                        .collection("favorite")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("userFavorite")
                        .doc(widget.productId)
                        .get().then((value) => {
                      if(this.mounted){
                   if(value.exists){
                    setState((){
                    isFavorite=value.get("productFavorite");
                    }),
                   }

                      }

                        },);




    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12.0),
            alignment: Alignment.topRight,
            height: 120,
            width: 160,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  widget.productImage,
                ),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;

                  if (isFavorite == true) {
                    favoriteProvider.favorite(
                      productId: widget.productId,
                      productCategory: widget.productCategory,
                      productRate: widget.productRate,
                      productOldPrice: widget.productOldPrice,
                      productPrice: widget.productPrice,
                      productImage: widget.productImage,
                      productFavorite: true,
                      productName: widget.productName,
                    );
                  } else if (isFavorite == false) {
                    favoriteProvider.deleteFavorite(productId:widget.productId);
                     
                  }
                });
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.pink[700],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.productName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                " ${widget.productPrice} Birr",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
