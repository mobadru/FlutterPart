import 'package:flutter/material.dart';
import '../services/api_service.dart';


class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});


  @override
  State<RegisterScreen> createState() => _RegisterScreenState();

}



class _RegisterScreenState extends State<RegisterScreen>{


  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  bool loading=false;



  Future<void> register() async{


    if(usernameController.text.isEmpty ||
       passwordController.text.isEmpty){

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Username and password required"
          ),
        ),

      );

      return;

    }



    setState(() {

      loading=true;

    });



    try{


      await ApiService.registerPatient(

        usernameController.text.trim(),

        emailController.text.trim(),

        passwordController.text.trim(),

      );



      if(!mounted)return;


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Account created successfully"
          ),
        ),

      );


      Navigator.pop(context);



    }
    catch(error){


      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(
            error.toString()
          ),
        ),

      );


    }


    setState(() {

      loading=false;

    });


  }





@override
Widget build(BuildContext context){


return Scaffold(


appBar: AppBar(

title: const Text(
"Patient Registration"
),

backgroundColor:
const Color(0xff0A66FF),

),



body:Padding(

padding:
const EdgeInsets.all(20),



child:Column(

children:[



TextField(

controller:
usernameController,

decoration:
const InputDecoration(

labelText:"Username",

prefixIcon:
Icon(Icons.person),

),

),



TextField(

controller:
emailController,

decoration:
const InputDecoration(

labelText:"Email",

prefixIcon:
Icon(Icons.email),

),

),



TextField(

controller:
passwordController,

obscureText:true,

decoration:
const InputDecoration(

labelText:"Password",

prefixIcon:
Icon(Icons.lock),

),

),



const SizedBox(height:30),



SizedBox(

width:double.infinity,

height:50,


child:ElevatedButton(


onPressed:
loading ? null : register,


child:

loading

?

const CircularProgressIndicator()

:

const Text(
"REGISTER"
),


),


),



],


),


),


);


}



}