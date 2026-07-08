import 'package:flutter/material.dart';

import 'medicines_screen.dart';
import 'pharmacy_screen.dart';
import 'reservation_screen.dart';
import 'profile_screen.dart';


class DashboardScreen extends StatefulWidget {

  const DashboardScreen({
    super.key
  });


  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();

}



class _DashboardScreenState extends State<DashboardScreen> {


  int index = 0;



  final List<Widget> pages = const [


    HomeDashboard(),

    MedicinesScreen(),

    PharmacyScreen(),

    ReservationScreen(),

    ProfileScreen(),


  ];





  @override
  Widget build(BuildContext context) {


    return Scaffold(


      body:
      pages[index],



      bottomNavigationBar:
      BottomNavigationBar(


        currentIndex:index,


        selectedItemColor:
        const Color(0xff0A66FF),


        unselectedItemColor:
        Colors.grey,


        type:
        BottomNavigationBarType.fixed,



        onTap:(value){


          setState(() {


            index=value;


          });


        },



        items:[


          const BottomNavigationBarItem(

            icon:
            Icon(Icons.home),

            label:
            "Home",

          ),



          const BottomNavigationBarItem(

            icon:
            Icon(Icons.medication),

            label:
            "Medicine",

          ),



          const BottomNavigationBarItem(

            icon:
            Icon(Icons.local_pharmacy),

            label:
            "Pharmacy",

          ),



          const BottomNavigationBarItem(

            icon:
            Icon(Icons.event_note),

            label:
            "Reservation",

          ),



          const BottomNavigationBarItem(

            icon:
            Icon(Icons.person),

            label:
            "Profile",

          ),



        ],


      ),


    );


  }


}







// ================= HOME DASHBOARD =================


class HomeDashboard extends StatelessWidget {


  const HomeDashboard({
    super.key
  });



  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar:AppBar(


        title:
        const Text(

          "Patient Dashboard",

        ),



        centerTitle:true,


      ),





      body:
      SingleChildScrollView(


        padding:
        const EdgeInsets.all(15),



        child:
        Column(


          crossAxisAlignment:
          CrossAxisAlignment.start,



          children:[



            // WELCOME CARD


            Container(


              width:
              double.infinity,


              padding:
              const EdgeInsets.all(20),



              decoration:
              BoxDecoration(


                borderRadius:
                BorderRadius.circular(20),


                gradient:
                const LinearGradient(

                  colors:[

                    Color(0xff0A66FF),

                    Color(0xff4D9BFF),

                  ],

                ),


              ),




              child:
              const Column(


                crossAxisAlignment:
                CrossAxisAlignment.start,


                children:[


                  Text(

                    "Welcome Customer",

                    style:
                    TextStyle(

                      color:
                      Colors.white,

                      fontSize:22,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),



                  SizedBox(height:8),



                  Text(

                    "Find medicine and reserve easily",

                    style:
                    TextStyle(

                      color:
                      Colors.white,

                    ),

                  ),


                ],


              ),


            ),





            const SizedBox(height:25),





            const Text(

              "Services",

              style:
              TextStyle(

                fontSize:20,

                fontWeight:
                FontWeight.bold,

              ),

            ),




            const SizedBox(height:15),





            Row(


              children:[



                Expanded(


                  child:
                  DashboardCard(


                    title:
                    "Medicines",


                    number:
                    "Search",


                    icon:
                    Icons.medication,



                    onTap:(){


                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder:(context)=>
                          const MedicinesScreen(),

                        ),

                      );


                    },


                  ),


                ),





                const SizedBox(width:15),





                Expanded(


                  child:
                  DashboardCard(


                    title:
                    "Reservations",


                    number:
                    "My List",


                    icon:
                    Icons.event_note,



                    onTap:(){


                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder:(context)=>
                          const ReservationScreen(),

                        ),

                      );


                    },


                  ),



                ),



              ],


            ),





            const SizedBox(height:15),





            Row(


              children:[



                Expanded(


                  child:
                  DashboardCard(


                    title:
                    "Pharmacy",


                    number:
                    "Nearby",


                    icon:
                    Icons.local_pharmacy,



                    onTap:(){


                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder:(context)=>
                          const PharmacyScreen(),

                        ),

                      );


                    },


                  ),


                ),





                const SizedBox(width:15),





                Expanded(


                  child:
                  DashboardCard(


                    title:
                    "Profile",


                    number:
                    "Account",


                    icon:
                    Icons.person,



                    onTap:(){


                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder:(context)=>
                          const ProfileScreen(),

                        ),

                      );


                    },


                  ),


                ),



              ],


            ),




            const SizedBox(height:30),





            const Text(

              "Quick Actions",

              style:
              TextStyle(

                fontSize:20,

                fontWeight:
                FontWeight.bold,

              ),

            ),





            const SizedBox(height:15),





            Card(


              child:
              ListTile(


                leading:
                const Icon(

                  Icons.search,

                  color:
                  Color(0xff0A66FF),

                ),


                title:
                const Text(

                  "Find Medicine",

                ),


                subtitle:
                const Text(

                  "Search available medicines",

                ),



                onTap:(){


                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder:(context)=>
                      const MedicinesScreen(),

                    ),

                  );


                },


              ),


            ),





            Card(


              child:
              ListTile(


                leading:
                const Icon(

                  Icons.history,

                  color:
                  Color(0xff0A66FF),

                ),


                title:
                const Text(

                  "My Reservations",

                ),


                subtitle:
                const Text(

                  "View reservation status",

                ),



                onTap:(){


                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder:(context)=>
                      const ReservationScreen(),

                    ),

                  );


                },


              ),


            ),



          ],


        ),


      ),


    );


  }



}







// ================= CARD =================


class DashboardCard extends StatelessWidget {


  final String title;

  final String number;

  final IconData icon;

  final VoidCallback onTap;




  const DashboardCard({

    super.key,

    required this.title,

    required this.number,

    required this.icon,

    required this.onTap,

  });




  @override
  Widget build(BuildContext context) {



    return InkWell(


      onTap:onTap,


      borderRadius:
      BorderRadius.circular(18),



      child:
      Container(


        padding:
        const EdgeInsets.all(18),



        decoration:
        BoxDecoration(


          color:
          Colors.white,


          borderRadius:
          BorderRadius.circular(18),



          boxShadow:[


            BoxShadow(

              color:
              Colors.black12,

              blurRadius:
              8,

              offset:
              const Offset(0,3),

            )


          ],


        ),




        child:
        Column(


          children:[



            Icon(

              icon,

              size:40,

              color:
              const Color(0xff0A66FF),

            ),




            const SizedBox(height:10),




            Text(

              number,

              style:
              const TextStyle(

                fontSize:18,

                fontWeight:
                FontWeight.bold,

              ),

            ),





            const SizedBox(height:5),





            Text(

              title,

              style:
              const TextStyle(

                color:
                Colors.grey,

              ),

            ),



          ],



        ),



      ),



    );


  }


}