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



  // ===============================
  // LOAD MEDICINES FROM DJANGO
  // ===============================

  Future<void> loadMedicines() async {


    try{


      final data =
      await ApiService.getMedicines();



      setState((){


        medicines = data;

        filtered = data;

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

          content: Text(
            e.toString()
          ),

        )

      );


    }


  }





  // ===============================
  // SEARCH
  // ===============================

  void searchMedicine(String value){


    setState((){


      filtered =
      medicines.where((m){


        String name =
        m["product_name"]
        .toString()
        .toLowerCase();



        return name.contains(
          value.toLowerCase()
        );


      }).toList();


    });


  }





  // ===============================
  // OPEN MAP
  // ===============================
     Future<void> openMap(double lat, double lng) async {
  final url = Uri.parse(
    "https://www.google.com/maps?q=$lat,$lng",
  );

  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
}


  // ===============================
  // RESERVATION DIALOG
  // ===============================

  void reserveDialog(Map medicine){



    TextEditingController quantityController =
    TextEditingController();



    showDialog(

      context: context,


      builder:(context){


        return AlertDialog(


          title: Text(

            "Reserve ${medicine["product_name"]}"

          ),



          content: TextField(


            controller:
            quantityController,


            keyboardType:
            TextInputType.number,


            decoration:
            const InputDecoration(

              labelText:
              "Quantity"

            ),


          ),



          actions:[



            TextButton(

              onPressed:(){

                Navigator.pop(context);

              },

              child:
              const Text("Cancel"),

            ),





            ElevatedButton(


              child:
              const Text("Reserve"),



              onPressed:() async{


                int qty =
                int.parse(
                  quantityController.text
                );



                try{


                  await ApiService.reserveMedicine(

                    medicine["product"],

                    medicine["pharmacy"],

                    qty,

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
                        "Reservation sent successfully"
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



              },


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
          "Medicines"
        ),

      ),




      body:


      loading

      ?

      const Center(

        child:
        CircularProgressIndicator()

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
                const Icon(
                  Icons.search
                ),


                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(15)

                )

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



                  child:
                  ListTile(



                    leading:
                    const Icon(

                      Icons.medication,

                      color:
                      Colors.blue,

                    ),



                    title:
                    Text(

                      medicine["product_name"]

                    ),



                    subtitle:
                    Column(

                      crossAxisAlignment:
                      CrossAxisAlignment.start,


                      children:[


                        Text(

                          medicine["pharmacy_name"]

                        ),



                        Text(

                          medicine["pharmacy_location"]

                        ),



                        Text(

                          medicine["prescription"]

                          ?

                          "Prescription Required"

                          :

                          "No Prescription"

                        ),


                      ],

                    ),




                    trailing:
                    ElevatedButton(


                      child:
                      const Text(
                        "Reserve"
                      ),



                      onPressed:(){

                        reserveDialog(
                          medicine
                        );

                      },


                    ),



                   


                    onTap: () {
                      openMap(
                        (medicine["latitude"] as num).toDouble(),
                        (medicine["longitude"] as num).toDouble(),
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