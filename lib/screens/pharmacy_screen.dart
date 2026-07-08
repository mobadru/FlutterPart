import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';


class PharmacyScreen extends StatefulWidget {

  const PharmacyScreen({super.key});


  @override
  State<PharmacyScreen> createState() =>
      _PharmacyScreenState();

}



class _PharmacyScreenState extends State<PharmacyScreen> {


  List pharmacies = [];

  bool loading = true;



  @override
  void initState(){

    super.initState();

    loadPharmacies();

  }




  // ==========================
  // LOAD PHARMACIES
  // ==========================

  Future<void> loadPharmacies() async {


    try{


      final data =
      await ApiService.getPharmacies();



      setState((){

        pharmacies = data;

        loading = false;

      });



    }

    catch(e){


      setState((){

        loading=false;

      });


      ScaffoldMessenger.of(context)
      .showSnackBar(

        SnackBar(
          content:
          Text(e.toString()),
        ),

      );


    }


  }





  // ==========================
  // OPEN GOOGLE MAP LOCATION
  // ==========================

  Future<void> openMap(
      dynamic latitude,
      dynamic longitude
      ) async {


    String lat =
    latitude.toString();


    String lng =
    longitude.toString();



    print("OPEN MAP LAT: $lat");
    print("OPEN MAP LNG: $lng");



    final Uri googleMapUrl = Uri.parse(

      "https://www.google.com/maps/search/?api=1&query=$lat,$lng"

    );



    try{


      bool opened =
      await launchUrl(

        googleMapUrl,

        mode:
        LaunchMode.externalApplication,

      );



      if(!opened){

        throw Exception(
          "Cannot open Google Maps"
        );

      }


    }

    catch(e){


      ScaffoldMessenger.of(context)
      .showSnackBar(

        SnackBar(

          content:
          Text(
            e.toString()
          ),

        ),

      );


    }


  }





  // ==========================
  // CALL PHONE
  // ==========================

  Future<void> callPharmacy(
      String phone
      ) async{


    final Uri phoneUrl =
    Uri.parse(
      "tel:$phone"
    );


    await launchUrl(phoneUrl);


  }





  @override
  Widget build(BuildContext context){


    return Scaffold(



      appBar:
      AppBar(

        title:
        const Text(
          "Nearby Pharmacies"
        ),

        centerTitle:true,

      ),





      body:


      loading


      ?


      const Center(

        child:
        CircularProgressIndicator(),

      )



      :


      ListView.builder(


        padding:
        const EdgeInsets.all(15),



        itemCount:
        pharmacies.length,



        itemBuilder:(context,index){


          final pharmacy =
          pharmacies[index];



          return Card(


            elevation:4,


            margin:
            const EdgeInsets.only(
              bottom:15
            ),



            child:
            InkWell(


              borderRadius:
              BorderRadius.circular(15),



              onTap:(){


                openMap(

                  pharmacy["latitude"],

                  pharmacy["longitude"],

                );


              },




              child:
              Padding(

                padding:
                const EdgeInsets.all(15),



                child:
                Row(

                  children:[



                    const CircleAvatar(

                      radius:25,

                      child:
                      Icon(
                        Icons.local_pharmacy
                      ),

                    ),





                    const SizedBox(
                      width:15
                    ),





                    Expanded(

                      child:
                      Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,


                        children:[



                          Text(

                            pharmacy["name"]
                            ??
                            "No Name",

                            style:
                            const TextStyle(

                              fontSize:18,

                              fontWeight:
                              FontWeight.bold,

                            ),

                          ),




                          Text(

                            "📍 ${pharmacy["location_name"] ?? ""}",

                          ),




                          Text(

                            "☎ ${pharmacy["phone"] ?? ""}",

                          ),




                          Text(

                            "🕒 ${pharmacy["opening_hours"] ?? ""}",

                          ),



                        ],


                      ),

                    ),






                    Column(

                      mainAxisSize:
                      MainAxisSize.min,


                      children:[



                        IconButton(

                          icon:
                          const Icon(

                            Icons.location_on,

                            color:
                            Colors.green,

                          ),



                          onPressed:(){


                            openMap(

                              pharmacy["latitude"],

                              pharmacy["longitude"],

                            );


                          },


                        ),





                        IconButton(

                          icon:
                          const Icon(

                            Icons.phone,

                            color:
                            Colors.blue,

                          ),



                          onPressed:(){


                            callPharmacy(

                              pharmacy["phone"]
                              .toString(),

                            );


                          },


                        ),



                      ],


                    )



                  ],

                ),


              ),


            ),


          );


        },


      ),


    );


  }



}