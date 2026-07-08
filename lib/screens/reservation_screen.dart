import 'package:flutter/material.dart';
import '../services/api_service.dart';



class ReservationScreen extends StatefulWidget {

  const ReservationScreen({super.key});


  @override
  State<ReservationScreen> createState() =>
      _ReservationScreenState();

}



class _ReservationScreenState extends State<ReservationScreen> {


  List reservations = [];

  bool loading = true;



  @override
  void initState(){

    super.initState();

    loadReservations();

  }





  // ============================
  // GET LOGGED USER RESERVATIONS
  // ============================

  Future<void> loadReservations() async {


    try{


      final data =
      await ApiService.getMyReservations();



      setState((){


        reservations = data;

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






  Color getStatusColor(String status){


    switch(status.toLowerCase()){


      case "approved":

        return Colors.green;


      case "pending":

        return Colors.orange;


      case "rejected":

        return Colors.red;


      case "completed":

        return Colors.blue;


      default:

        return Colors.grey;

    }


  }






  IconData getStatusIcon(String status){


    switch(status.toLowerCase()){


      case "approved":

        return Icons.check_circle;


      case "pending":

        return Icons.schedule;


      case "rejected":

        return Icons.cancel;


      case "completed":

        return Icons.done_all;


      default:

        return Icons.info;


    }


  }







  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar:

      AppBar(

        title:
        const Text(
          "My Reservations"
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



      reservations.isEmpty



      ?


      const Center(

        child:
        Text(

          "No reservations found",

          style:
          TextStyle(

            fontSize:18

          ),

        ),

      )




      :



      ListView.builder(


        padding:
        const EdgeInsets.all(15),



        itemCount:
        reservations.length,



        itemBuilder:(context,index){


          final item =
          reservations[index];



          String status =
          item["status"] ?? "pending";



          Color color =
          getStatusColor(status);




          return Card(


            elevation:3,


            margin:
            const EdgeInsets.only(
              bottom:15
            ),



            shape:
            RoundedRectangleBorder(

              borderRadius:
              BorderRadius.circular(15),

            ),





            child:
            Padding(

              padding:
              const EdgeInsets.all(15),



              child:
              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children:[




                  Row(

                    children:[


                      const CircleAvatar(

                        radius:25,

                        child:
                        Icon(
                          Icons.medication
                        ),

                      ),



                      const SizedBox(
                        width:12
                      ),



                      Expanded(

                        child:
                        Text(

                          item["product_name"]
                          ??
                          "Medicine",


                          style:
                          const TextStyle(

                            fontSize:19,

                            fontWeight:
                            FontWeight.bold,

                          ),

                        ),

                      )


                    ],

                  ),




                  const Divider(
                    height:30
                  ),




                  Text(

                    "🏥 Pharmacy: ${item["pharmacy_name"] ?? ""}",

                  ),




                  const SizedBox(
                    height:10
                  ),




                  Text(

                    "💊 Category: ${item["category"] ?? ""}",

                  ),




                  const SizedBox(
                    height:10
                  ),




                  Text(

                    "📦 Quantity: ${item["quantity"]}",

                  ),




                  const SizedBox(
                    height:10
                  ),




                  Text(

                    "📅 Date: ${item["reservation_date"]}",

                  ),




                  const SizedBox(
                    height:15
                  ),





                  Align(

                    alignment:
                    Alignment.centerRight,


                    child:
                    Container(

                      padding:
                      const EdgeInsets.symmetric(

                        horizontal:16,

                        vertical:8,

                      ),



                      decoration:
                      BoxDecoration(

                        color:
                        color.withOpacity(.15),

                        borderRadius:
                        BorderRadius.circular(25),

                      ),



                      child:
                      Row(

                        mainAxisSize:
                        MainAxisSize.min,


                        children:[



                          Icon(

                            getStatusIcon(status),

                            color:
                            color,

                            size:18,

                          ),




                          const SizedBox(
                            width:6
                          ),




                          Text(

                            status.toUpperCase(),

                            style:
                            TextStyle(

                              color:
                              color,

                              fontWeight:
                              FontWeight.bold,

                            ),

                          )



                        ],

                      ),

                    ),

                  )


                ],


              ),


            ),


          );


        },


      ),



    );


  }


}