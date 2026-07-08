import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';


class MedicinesScreen extends StatefulWidget {

  const MedicinesScreen({super.key});


  @override
  State<MedicinesScreen> createState() =>
      _MedicinesScreenState();

}



class _MedicinesScreenState extends State<MedicinesScreen> {


  List medicines = [];

  List filtered = [];

  bool loading = true;


  final TextEditingController searchController =
  TextEditingController();




  @override
  void initState(){

    super.initState();

    loadMedicines();

  }





  // ===========================
  // LOAD + GROUP MEDICINES
  // ===========================

  Future<void> loadMedicines() async {


    try{


      final data =
      await ApiService.getMedicines();



      Map<String,dynamic> grouped = {};



      for(var item in data){


        String name =
        item["product_name"]?.toString()
            ?? "Unknown";



        if(!grouped.containsKey(name)){


          grouped[name] = {

            "product":
            item["product"],


            "product_name":
            name,


            "prescription":
            item["prescription"] ?? false,


            "pharmacies":[]

          };


        }




        grouped[name]["pharmacies"].add({


          "pharmacy":
          item["pharmacy"],


          "pharmacy_name":
          item["pharmacy_name"],


          "pharmacy_location":
          item["pharmacy_location"],


          "latitude":
          item["latitude"],


          "longitude":
          item["longitude"],


        });



      }




      setState((){


        medicines =
        grouped.values.toList();


        filtered =
        medicines;


        loading=false;


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
          Text(
              e.toString()
          ),

        ),

      );


    }


  }







  // ===========================
  // SEARCH
  // ===========================

  void searchMedicine(String value){


    setState((){


      filtered =
          medicines.where((medicine){


            return medicine["product_name"]
                .toString()
                .toLowerCase()
                .contains(

                value.toLowerCase()

            );


          }).toList();



    });


  }







  // ===========================
  // OPEN MAP
  // ===========================

  Future<void> openMap(
      dynamic lat,
      dynamic lng
      ) async {


    try{


      final latitude =
      double.parse(lat.toString());


      final longitude =
      double.parse(lng.toString());



      final Uri url = Uri.parse(

        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",

      );



      await launchUrl(

        url,

        mode:
        LaunchMode.externalApplication,

      );



    }

    catch(e){


      ScaffoldMessenger.of(context)
          .showSnackBar(

          const SnackBar(

            content:
            Text(
                "Invalid location"
            ),

          )

      );


    }


  }








  // ===========================
  // PHARMACY LIST
  // ===========================

  void showPharmacies(Map medicine){


    showModalBottomSheet(

        context: context,


        builder:(context){


          return Padding(

            padding:
            const EdgeInsets.all(15),


            child:

            ListView(


              children:[



                Text(

                  medicine["product_name"],


                  style:
                  const TextStyle(

                    fontSize:22,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),



                const SizedBox(height:10),




                Chip(

                  backgroundColor:

                  medicine["prescription"] == true

                      ? Colors.red

                      : Colors.green,



                  label:

                  Text(

                    medicine["prescription"] == true

                        ? "Prescription Required"

                        : "No Prescription",


                    style:
                    const TextStyle(

                      color:
                      Colors.white,

                    ),

                  ),

                ),




                const SizedBox(height:15),





                ...medicine["pharmacies"]
                    .map<Widget>((pharmacy){


                  return Card(

                    child:

                    ListTile(



                      leading:

                      const Icon(

                        Icons.local_pharmacy,

                        color:
                        Colors.blue,

                      ),



                      title:

                      Text(

                        pharmacy["pharmacy_name"]
                            .toString(),

                      ),



                      subtitle:

                      Text(

                        pharmacy["pharmacy_location"]
                            .toString(),

                      ),



                      trailing:

                      IconButton(

                        icon:

                        const Icon(

                          Icons.map,

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





                      onTap:(){


                        Navigator.pop(context);


                        reserveDialog({

                          "product":
                          medicine["product"],


                          "pharmacy":
                          pharmacy["pharmacy"],


                          "product_name":
                          medicine["product_name"],


                        });



                      },


                    ),


                  );


                }).toList(),



              ],


            ),


          );


        }

    );


  }








  // ===========================
  // RESERVATION
  // ===========================

  void reserveDialog(Map medicine){


    TextEditingController quantity =
    TextEditingController();



    showDialog(

        context:context,


        builder:(context){


          return AlertDialog(


            title:

            Text(

              "Reserve ${medicine["product_name"]}",

            ),



            content:

            TextField(

              controller:
              quantity,


              keyboardType:
              TextInputType.number,


              decoration:

              const InputDecoration(

                labelText:
                "Quantity",

              ),

            ),




            actions:[



              TextButton(

                  onPressed:(){

                    Navigator.pop(context);

                  },


                  child:
                  const Text(
                      "Cancel"
                  )

              ),




              ElevatedButton(


                  child:
                  const Text(
                      "Reserve"
                  ),




                  onPressed:() async{


                    try{


                      await ApiService.reserveMedicine(


                        int.parse(
                            medicine["product"].toString()
                        ),



                        int.parse(
                            medicine["pharmacy"].toString()
                        ),



                        int.parse(
                            quantity.text
                        ),



                        DateTime.now()

                            .add(

                            const Duration(days:2)

                        )

                            .toIso8601String(),


                      );



                      Navigator.pop(context);



                      ScaffoldMessenger.of(context)
                          .showSnackBar(

                          const SnackBar(

                            content:
                            Text(
                                "Reservation sent"
                            ),

                            backgroundColor:
                            Colors.green,

                          )

                      );


                    }

                    catch(e){


                      ScaffoldMessenger.of(context)
                          .showSnackBar(

                          SnackBar(

                            content:
                            Text(
                                e.toString()
                            ),

                          )

                      );


                    }



                  }

              )



            ],



          );


        }

    );


  }








  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar:

      AppBar(

        title:
        const Text(
            "Available Medicines"
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


      Column(

        children:[



          Padding(

            padding:
            const EdgeInsets.all(15),



            child:

            TextField(


              controller:
              searchController,


              onChanged:
              searchMedicine,


              decoration:

              InputDecoration(

                hintText:
                "Search medicine...",


                prefixIcon:
                const Icon(Icons.search),



                border:

                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(15),

                ),

              ),


            ),


          ),





          Expanded(

            child:

            ListView.builder(


              itemCount:
              filtered.length,


              itemBuilder:(context,index){


                final medicine =
                filtered[index];



                return Card(


                  margin:
                  const EdgeInsets.all(10),


                  elevation:4,



                  child:

                  ListTile(



                    leading:

                    const CircleAvatar(

                      backgroundColor:
                      Color(0xff0A66FF),


                      child:
                      Icon(

                        Icons.medication,

                        color:
                        Colors.white,

                      ),

                    ),



                    title:

                    Text(

                      medicine["product_name"],


                      style:
                      const TextStyle(

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),



                    subtitle:

                    Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,


                      children:[



                        Text(

                          "${medicine["pharmacies"].length} pharmacies available",

                        ),




                        const SizedBox(height:5),




                        Text(

                          medicine["prescription"] == true

                              ?

                          "🔴 Prescription Required"

                              :

                          "🟢 No Prescription",


                        ),


                      ],


                    ),





                    trailing:

                    const Icon(

                      Icons.arrow_forward_ios,

                    ),





                    onTap:(){


                      showPharmacies(
                          medicine
                      );


                    },


                  ),



                );


              },


            ),


          )


        ],


      ),


    );


  }


}