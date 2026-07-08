import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'login_screen.dart';



class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});


  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();

}





class _ProfileScreenState extends State<ProfileScreen>{


  Map<String,dynamic>? profile;


  bool loading = true;



  @override
  void initState(){

    super.initState();

    loadProfile();

  }





  Future<void> loadProfile() async{


    try{


      final data =
      await ApiService.getProfile();



      setState((){

        profile = data;

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
          Text(
              e.toString()
          ),

        ),

      );


    }


  }





  Future<void> logout() async{


    await ApiService.logout();



    Navigator.pushAndRemoveUntil(


      context,


      MaterialPageRoute(

        builder: (_) =>
        const LoginScreen(),

      ),


          (route)=>false,


    );


  }







  Widget profileCard(

      IconData icon,

      String title,

      String value

      ){



    return Card(


      elevation:3,


      shape:
      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(15),

      ),



      margin:
      const EdgeInsets.only(

          bottom:12

      ),



      child:
      ListTile(


        leading:
        CircleAvatar(


          backgroundColor:
          const Color(0xff0A66FF)
              .withOpacity(.1),


          child:
          Icon(

            icon,

            color:
            const Color(0xff0A66FF),

          ),


        ),



        title:
        Text(

          title,

          style:
          const TextStyle(

            fontWeight:
            FontWeight.bold,

          ),

        ),



        subtitle:
        Text(

          value,

          style:
          const TextStyle(

            fontSize:16,

          ),

        ),



      ),


    );


  }









  @override
  Widget build(BuildContext context){


    return Scaffold(



      appBar:
      AppBar(


        title:
        const Text(

          "My Profile",

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



      SingleChildScrollView(



        padding:
        const EdgeInsets.all(20),




        child:
        Column(



          children:[





            const CircleAvatar(


              radius:60,


              backgroundColor:
              Color(0xff0A66FF),



              child:
              Icon(

                Icons.person,

                size:70,

                color:
                Colors.white,

              ),


            ),






            const SizedBox(height:15),





            Text(


              profile?["username"]
                  ??
                  "Patient",



              style:
              const TextStyle(


                fontSize:24,


                fontWeight:
                FontWeight.bold,


              ),


            ),





            const SizedBox(height:30),





            profileCard(

              Icons.badge,

              "User ID",

              profile?["id"]
                  ?.toString()
                  ??
                  "-",

            ),






            profileCard(

              Icons.person,

              "Username",

              profile?["username"]
                  ??
                  "-",

            ),






            profileCard(

              Icons.email,

              "Email",

              profile?["email"]
                  ??
                  "-",

            ),






            profileCard(

              Icons.security,

              "Role",

              profile?["role"]
                  ??
                  "patient",

            ),







            const SizedBox(height:20),






            SizedBox(


              width:
              double.infinity,



              child:
              ElevatedButton.icon(



                icon:
                const Icon(

                  Icons.logout,

                  color:
                  Colors.white,

                ),




                label:
                const Text(

                  "Logout",

                  style:
                  TextStyle(

                    color:
                    Colors.white,

                    fontSize:17,

                  ),

                ),





                style:
                ElevatedButton.styleFrom(



                  backgroundColor:
                  Colors.red,



                  padding:
                  const EdgeInsets.all(15),



                  shape:
                  RoundedRectangleBorder(


                    borderRadius:
                    BorderRadius.circular(15),


                  ),



                ),





                onPressed:
                logout,



              ),


            ),




          ],


        ),


      ),




    );


  }


}