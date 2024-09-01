import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../models/cars_model.dart';
import 'MapSearchRoute.dart';
import 'SearchRoute.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var box = Hive.box('details');

  List<CarsModel> carsItem = [
    CarsModel(
        imageUrl: "https://img.freepik.com/premium-photo/white-car-isolated-white-background-side-view_140916-40199.jpg",
        carType: "Ride"
    ),
    CarsModel(
        imageUrl: "https://img.freepik.com/premium-photo/white-car-isolated-white-background-side-view_140916-40199.jpg",
        carType: "Rental"
    ),
    CarsModel(
        imageUrl: "https://img.freepik.com/premium-photo/white-car-isolated-white-background-side-view_140916-40199.jpg",
        carType: "Reserve"
    ),
  ];

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Handle the tap here
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Handle the tap here
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset("assets/images/6.png"),
                Positioned(
                    top: screenHeight/18,
                    left: screenWidth/20,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.pop(context);
                            _scaffoldKey.currentState?.openDrawer();
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.menu),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text("${getGreeting()},\n${box.get('name')}", style: TextStyle(color: Colors.white,fontSize: screenHeight/38, fontWeight: FontWeight.w600)),
                        )

                      ],
                    )
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight/8,),
                  TextField(
                    controller: searchController,
                    keyboardType: TextInputType.emailAddress,
                    onTap: (){
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => MapSearchWidget(),));
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LocationSearchWidget(),));
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      hintText: "Where to go?",
                      prefixIcon: Icon(Icons.search, color: Colors.grey,),
                      suffixIcon: Icon(Icons.arrow_forward, color: Colors.grey,),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey, width: 1),
                      ),),
                  ),

                  Container(
                    height: screenHeight/9,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.star, color: Colors.grey[100],)),
                          title: Text("Saved Places", style: TextStyle(color: Colors.grey),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight/55,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text("Suggations", style: TextStyle(fontSize: screenHeight/42, fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(
                    height: screenHeight/6.5,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: carsItem.length,
                      itemBuilder: (context, index) {
                        final carData = carsItem[index];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: SizedBox(
                                width: screenWidth/3,
                                child: Card(
                                  color: Colors.white,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(carData.imageUrl, height: screenHeight/12,),
                                  ),
                                ),
                              ),
                            ),
                            Text(carData.carType)
                          ],
                        );
                      },),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network("https://i.ytimg.com/vi/J853PlhCCDI/maxresdefault.jpg", height: screenHeight/6, width: double.infinity, fit: BoxFit.cover,)),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}
