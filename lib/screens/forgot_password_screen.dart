import 'package:flutter/material.dart';
import '../services/api_service.dart';


class ForgotPasswordScreen extends StatefulWidget {

  const ForgotPasswordScreen({super.key});


  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();

}



class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {


  final emailController = TextEditingController();


  bool isLoading = false;



  Future<void> resetPassword() async {


    if(emailController.text.trim().isEmpty){


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(
            "Email is required"
          ),

        ),

      );


      return;

    }



    setState(() {

      isLoading = true;

    });



    try{
        await ApiService.forgotPassword(

        emailController.text.trim()

        );



      if(!mounted)return;



      setState(() {

        isLoading=false;

      });



      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text(
            "Password reset request sent"
          ),

        ),

      );



      Navigator.pop(context);



    }

    catch(error){


      setState(() {

        isLoading=false;

      });



      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text(
            error.toString()
          ),

        ),

      );


    }



  }





  @override
  void dispose(){

    emailController.dispose();

    super.dispose();

  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(


      body: Container(


        width:double.infinity,


        decoration:const BoxDecoration(


          gradient:LinearGradient(


            colors:[

              Color(0xff0A66FF),

              Color(0xff66B2FF),

            ],


            begin:Alignment.topCenter,

            end:Alignment.bottomCenter,


          ),

        ),



        child:Center(


          child:SingleChildScrollView(


            padding:
            const EdgeInsets.all(20),



            child:Container(


              padding:
              const EdgeInsets.all(25),



              decoration:BoxDecoration(


                color:Colors.white,


                borderRadius:
                BorderRadius.circular(25),



                boxShadow:const[


                  BoxShadow(

                    color:Colors.black12,

                    blurRadius:20,

                    offset:Offset(0,10),

                  )


                ],


              ),



              child:Column(


                mainAxisSize:
                MainAxisSize.min,



                children:[



                  const Icon(

                    Icons.lock_reset,

                    size:90,

                    color:Color(0xff0A66FF),

                  ),



                  const SizedBox(height:20),




                  const Text(

                    "Forgot Password",

                    style:TextStyle(

                      fontSize:28,

                      fontWeight:FontWeight.bold,

                      color:Color(0xff003366),

                    ),

                  ),





                  const SizedBox(height:10),




                  const Text(

                    "Enter your email to reset your password",

                    textAlign:TextAlign.center,

                    style:TextStyle(

                      color:Colors.grey,

                    ),

                  ),




                  const SizedBox(height:30),




                  TextField(


                    controller:
                    emailController,



                    decoration:
                    InputDecoration(


                      hintText:"Email",


                      prefixIcon:
                      const Icon(
                        Icons.email
                      ),



                      border:
                      OutlineInputBorder(


                        borderRadius:
                        BorderRadius.circular(15),


                      ),


                    ),


                  ),




                  const SizedBox(height:30),





                  SizedBox(


                    width:double.infinity,


                    height:55,



                    child:ElevatedButton(


                      onPressed:
                      isLoading
                      ? null
                      : resetPassword,



                      style:
                      ElevatedButton.styleFrom(


                        backgroundColor:
                        const Color(0xff0A66FF),



                        shape:
                        RoundedRectangleBorder(


                          borderRadius:
                          BorderRadius.circular(15),


                        ),


                      ),



                      child:isLoading



                      ?

                      const CircularProgressIndicator(

                        color:Colors.white,

                      )



                      :

                      const Text(

                        "RESET PASSWORD",

                        style:TextStyle(

                          color:Colors.white,

                          fontSize:17,

                          fontWeight:FontWeight.bold,

                        ),

                      ),



                    ),


                  ),





                  const SizedBox(height:15),




                  TextButton(


                    onPressed:(){


                      Navigator.pop(context);


                    },


                    child:const Text(

                      "Back to Login",

                      style:TextStyle(

                        color:Color(0xff0A66FF),

                      ),

                    ),


                  )



                ],


              ),


            ),


          ),


        ),


      ),


    );


  }


}