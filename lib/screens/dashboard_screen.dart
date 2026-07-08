import 'package:flutter/material.dart';

import '../services/api_service.dart';

import 'medicines_screen.dart';
import 'pharmacy_screen.dart';
import 'reservation_screen.dart';
import 'profile_screen.dart';



class DashboardScreen extends StatefulWidget {

  const DashboardScreen({super.key});


  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();

}



class _DashboardScreenState extends State<DashboardScreen>{


int index = 0;



final pages = [

const HomeDashboard(),

const MedicinesScreen(),

const PharmacyScreen(),

const ReservationScreen(),

const ProfileScreen(),

];



@override
Widget build(BuildContext context){


return Scaffold(


body: pages[index],



bottomNavigationBar:
BottomNavigationBar(


currentIndex:index,


type:BottomNavigationBarType.fixed,


selectedItemColor:
const Color(0xff0A66FF),



onTap:(value){


setState((){


index=value;


});


},



items:const[


BottomNavigationBarItem(

icon:Icon(Icons.home),

label:"Home"

),



BottomNavigationBarItem(

icon:Icon(Icons.medication),

label:"Medicine"

),



BottomNavigationBarItem(

icon:Icon(Icons.local_pharmacy),

label:"Pharmacy"

),



BottomNavigationBarItem(

icon:Icon(Icons.event),

label:"Reservation"

),



BottomNavigationBarItem(

icon:Icon(Icons.person),

label:"Profile"

),


],


),


);


}



}









class HomeDashboard extends StatefulWidget{


const HomeDashboard({super.key});



@override
State<HomeDashboard> createState() =>
_HomeDashboardState();



}



class _HomeDashboardState extends State<HomeDashboard>{



Map<String,dynamic>? profile;


List reservations=[];


bool loading=true;




@override
void initState(){

super.initState();

loadDashboard();


}





Future<void> loadDashboard() async{


try{


final user =
await ApiService.getProfile();



final myReservations =
await ApiService.getMyReservations();



setState((){


profile=user;


reservations=myReservations;


loading=false;


});



}

catch(e){


print(e);


setState((){


loading=false;


});



}



}






Color getStatusColor(String status){


switch(status.toLowerCase()){


case "approved":

return Colors.green;



case "rejected":

return Colors.red;



case "completed":

return Colors.blue;



default:

return Colors.orange;


}



}








@override
Widget build(BuildContext context){



return Scaffold(


backgroundColor:
Colors.grey.shade100,



appBar:AppBar(

title:
const Text(
"Patient Dashboard"
),

centerTitle:true,

),




body:


loading

?

const Center(

child:CircularProgressIndicator()

)



:

RefreshIndicator(


onRefresh:loadDashboard,



child:SingleChildScrollView(


physics:
const AlwaysScrollableScrollPhysics(),



padding:
const EdgeInsets.all(16),



child:Column(


crossAxisAlignment:
CrossAxisAlignment.start,



children:[




Container(


width:double.infinity,


padding:
const EdgeInsets.all(22),



decoration:
BoxDecoration(

gradient:
const LinearGradient(

colors:[

Color(0xff0A66FF),

Color(0xff0047AB)

]

),


borderRadius:
BorderRadius.circular(20)


),



child:Column(


crossAxisAlignment:
CrossAxisAlignment.start,


children:[


Text(

"Welcome ${profile?["username"] ?? "Patient"}",

style:
const TextStyle(

color:Colors.white,

fontSize:23,

fontWeight:FontWeight.bold

),

),



const SizedBox(height:8),




const Text(

"Manage your medicines and reservations easily",

style:
TextStyle(

color:Colors.white70,

fontSize:15

),

),



],


),


),





const SizedBox(height:20),





Row(


children:[



Expanded(

child:
DashboardCard(

icon:
Icons.medication,

title:
"Medicines",

number:
"Find",

)

),




const SizedBox(width:15),




Expanded(

child:
DashboardCard(

icon:
Icons.event,

title:
"My Reservations",

number:
reservations.length.toString(),

)

),



],



),





const SizedBox(height:25),





const Text(

"Recent Reservations",

style:
TextStyle(

fontSize:20,

fontWeight:FontWeight.bold

),

),




const SizedBox(height:10),






reservations.isEmpty

?

const Center(

child:Text(
"No reservation found"
)

)



:

ListView.builder(


shrinkWrap:true,


physics:
const NeverScrollableScrollPhysics(),



itemCount:
reservations.length > 5
?
5
:
reservations.length,



itemBuilder:(context,index){



final item =
reservations[index];



return Card(


elevation:3,


margin:
const EdgeInsets.only(
bottom:12
),



shape:
RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(15)

),



child:
ListTile(



leading:
const CircleAvatar(

backgroundColor:
Color(0xff0A66FF),

child:
Icon(

Icons.medication,

color:Colors.white

)

),



title:
Text(

item["product_name"] ??
"Medicine",

style:
const TextStyle(

fontWeight:
FontWeight.bold

),

),




subtitle:
Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children:[


Text(

item["pharmacy_name"] ??
"Pharmacy"

),



Text(

item["reservation_date"] ??
""

)


],

),





trailing:
Container(


padding:
const EdgeInsets.symmetric(

horizontal:10,

vertical:5

),


decoration:
BoxDecoration(

color:
getStatusColor(

item["status"]

)
.withOpacity(.15),


borderRadius:
BorderRadius.circular(20)

),




child:
Text(

item["status"]
.toString()
.toUpperCase(),



style:
TextStyle(

color:
getStatusColor(
item["status"]
),

fontWeight:
FontWeight.bold

),

),



),



),



);



},




)






],



),


),


),



);



}



}









class DashboardCard extends StatelessWidget{


final IconData icon;

final String title;

final String number;



const DashboardCard({

super.key,

required this.icon,

required this.title,

required this.number

});





@override
Widget build(BuildContext context){


return Container(


padding:
const EdgeInsets.all(18),



decoration:
BoxDecoration(

color:Colors.white,

borderRadius:
BorderRadius.circular(18),

boxShadow:[

BoxShadow(

color:Colors.black12,

blurRadius:6

)

]


),



child:Column(


children:[


Icon(

icon,

size:35,

color:
const Color(0xff0A66FF)

),



const SizedBox(height:10),




Text(

number,

style:
const TextStyle(

fontSize:22,

fontWeight:FontWeight.bold

),

),




Text(title)



],


),



);



}



}