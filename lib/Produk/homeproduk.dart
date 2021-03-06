// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'formproduk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_slider.dart';

import 'product.dart';

class Awalan extends StatefulWidget {
  const Awalan({Key? key}) : super(key: key);

  @override
  State<Awalan> createState() => _AwalanState();
}

class _AwalanState extends State<Awalan> {
  int _current = 0;
  bool isFavourite = true;
  final CarouselController _controller = CarouselController();
  Product studentService = Product();
  Color _iconColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'https://media.giphy.com/media/MRNr7i6zjPSCxkDZFz/giphy.gif',
      'https://media.giphy.com/media/hslu8XMb2ncwuss0zw/giphy.gif',
      'https://media.giphy.com/media/jRZTShagyO6Z6e8dYg/giphy.gif',
    ];
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(children: [
          const SizedBox(height: 30),
          CarouselSlider(
            options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 3.0,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: imgList
                .map((item) => Container(
                      margin: const EdgeInsets.all(5.0),
                      child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          child: Stack(
                            children: <Widget>[
                              Image.network(item,
                                  fit: BoxFit.cover,
                                  width: 1000.0,
                                  height: 1000.0),
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      // ignore: prefer_const_literals_to_create_immutables
                                      colors: [
                                        Color.fromARGB(200, 0, 0, 0),
                                        Color.fromARGB(0, 0, 0, 0)
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                ),
                              ),
                            ],
                          )),
                    ))
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "   Produk",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  height: 1.6,
                  fontFamily: 'Open Sans',
                  fontSize: 20),
            ),
          ),
          FutureBuilder<List>(
            future: studentService.getAllProducts(),
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.hasData) {
                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, i) {
                      return Center(
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.new_releases,
                                    color: Colors.red, size: 30),
                                title: Text(snapshot.data![i]['name'],
                                    style: const TextStyle(fontSize: 20)),
                                subtitle: Text(
                                  snapshot.data![i]['description'],
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Image(
                                image: NetworkImage(snapshot.data![i]['image']),
                                height: 150,
                                width: 150,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Rp." + snapshot.data![i]['price'].toString(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isFavourite = !isFavourite;
                                      });
                                      // Perform some action
                                    },
                                    icon: Icon(Icons.add_shopping_cart,
                                        color: isFavourite
                                            ? Colors.blue
                                            : Colors.blue),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_iconColor == Colors.blue) {
                                          _iconColor = Colors.red;
                                        } else {
                                          _iconColor = Colors.blue;
                                        }
                                      });
                                      // Perform some action
                                    },
                                    child: Icon(
                                      Icons.favorite,
                                      color: _iconColor,
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_iconColor == Colors.blue) {
                                          _iconColor = Colors.green;
                                        } else {
                                          _iconColor = Colors.blue;
                                        }
                                      });
                                      // Perform some action
                                    },
                                    child: Icon(
                                      Icons.share,
                                      color: _iconColor,
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red, // Background color
                                    ),
                                    onPressed: () {},
                                    child: const Text('Beli Sekarang'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          elevation: 8,
                          shadowColor: Colors.blue,
                          margin: const EdgeInsets.all(20),
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: Text('No Data Found'),
                );
              }
            },
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red, // Background color
            ),
            child: const Text('Add Produk'),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FormArtikel()));
            },
          ),
          const SizedBox(
            height: 50,
          ),
        ])));
  }
}
