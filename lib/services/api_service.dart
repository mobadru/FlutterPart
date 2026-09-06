import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ApiService {


  static const String baseUrl =
      "http://172.20.10.4:8000/api";


  // ==========================
  // LOGIN PATIENT + STAFF
  // ==========================

  static Future<Map<String,dynamic>> patientLogin(
      String username,
      String password
  ) async {


    final url = Uri.parse(
      "$baseUrl/token/"
    );


    final response = await http.post(

      url,

      headers:{
        "Content-Type":"application/json",
      },


      body:jsonEncode({

        "username":username,

        "password":password

      }),

    );



    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");



    if(response.statusCode == 200){


      final data=jsonDecode(response.body);



      final prefs =
      await SharedPreferences.getInstance();



      await prefs.setString(
          "access",
          data["access"]
      );


      await prefs.setString(
          "refresh",
          data["refresh"]
      );


      await prefs.setString(
          "username",
          data["username"]
      );


      await prefs.setString(
          "role",
          data["role"]
      );



      return data;


    }

    else{


      throw Exception(
        response.body
      );


    }


  }


static Future registerPatient(

String username,

String email,

String password,

) async{


final url = Uri.parse(

"$baseUrl/register/"

);



final response = await http.post(

url,

headers:{

"Content-Type":"application/json"

},


body:jsonEncode({

"username":username,

"email":email,

"password":password

}),


);



if(response.statusCode==201){


return jsonDecode(response.body);


}

else{


throw Exception(

response.body

);


}


}


static Future forgotPassword(
String email
) async{


final url = Uri.parse(

"$baseUrl/forgot-password/"

);



final response = await http.post(

url,

headers:{

"Content-Type":
"application/json"

},


body:jsonEncode({

"email":email

}),


);



if(response.statusCode==200){

return jsonDecode(response.body);

}


else{

throw Exception(
response.body
);

}


}


static Future<Map<String,dynamic>> changePassword(
String currentPassword,
String newPassword,
String confirmPassword,
) async {


final url = Uri.parse(
  "$baseUrl/change-password/"
);


final token = await getToken();


final response = await http.post(

url,

headers:{

"Content-Type":"application/json",

"Authorization":"Bearer $token"

},


body:jsonEncode({

"current_password":currentPassword,

"new_password":newPassword,

"confirm_password":confirmPassword

}),


);


if(response.statusCode == 200){

return jsonDecode(response.body);

}


throw Exception(response.body);

}

// ==========================
// GET MEDICINES
// ==========================

static Future<List<dynamic>> getMedicines() async {


  final url = Uri.parse(
    "$baseUrl/stocks/"
  );


  final token = await getToken();



  final response = await http.get(

    url,

    headers: {

      "Content-Type":"application/json",

      "Authorization":"Bearer $token"

    },

  );



  print("MEDICINE STATUS: ${response.statusCode}");
  print("MEDICINE BODY: ${response.body}");



  if(response.statusCode == 200){


    return jsonDecode(response.body);


  }

  else{


    throw Exception(
      response.body
    );


  }


}





// ==========================
// CREATE RESERVATION
// ==========================

static Future<Map<String,dynamic>> reserveMedicine(

int productId,

int pharmacyId,

int quantity,

String expiryTime,

) async {



final url = Uri.parse(

"$baseUrl/reservations/"

);



final token = await getToken();



final response = await http.post(


url,


headers:{


"Content-Type":"application/json",


"Authorization":
"Bearer $token"


},



body:jsonEncode({


"product":productId,


"pharmacy":pharmacyId,


"quantity":quantity,


"expiry_time":expiryTime


}),


);




print("RESERVATION STATUS: ${response.statusCode}");

print("RESERVATION BODY: ${response.body}");




if(response.statusCode==201){


return jsonDecode(response.body);


}


else{


throw Exception(

response.body

);


}


}


// ==========================
// GET PHARMACIES
// ==========================

static Future<List<dynamic>> getPharmacies() async {

  final url = Uri.parse(
    "$baseUrl/pharmacies/"
  );


  final token = await getToken();


  final response = await http.get(

    url,

    headers: {

      "Content-Type":"application/json",

      "Authorization":
      "Bearer $token"

    },

  );


  print("PHARMACY STATUS: ${response.statusCode}");
  print("PHARMACY BODY: ${response.body}");



  if(response.statusCode == 200){

    return jsonDecode(response.body);

  }

  else{

    throw Exception(
      response.body
    );

  }


}


static Future<List<dynamic>> getMyReservations() async {

  final url = Uri.parse(
    "$baseUrl/reservations/"
  );


  final token = await getToken();


  final response = await http.get(

    url,

    headers: {

      "Content-Type":"application/json",

      "Authorization":"Bearer $token"

    },

  );


  print("RESERVATION STATUS: ${response.statusCode}");
  print("RESERVATION BODY: ${response.body}");



  if(response.statusCode == 200){

    return jsonDecode(response.body);

  }

  else{

    throw Exception(
      response.body
    );

  }

}


// ==========================
// GET LOGGED USER PROFILE
// ==========================

static Future<Map<String,dynamic>> getProfile() async {


  final url = Uri.parse(
    "$baseUrl/profile/"
  );


  final token = await getToken();



  final response = await http.get(

    url,

    headers: {

      "Content-Type":"application/json",

      "Authorization":
      "Bearer $token",

    },

  );



  print("PROFILE STATUS: ${response.statusCode}");
  print("PROFILE BODY: ${response.body}");



  if(response.statusCode == 200){


    return jsonDecode(response.body);


  }


  else{


    throw Exception(
      response.body
    );


  }


}


static Future<Map<String,dynamic>> updateProfile(
String email,
String phone,
String address,
String gender,
String? dateOfBirth,
) async {


final url = Uri.parse(
  "$baseUrl/profile/"
);


final token = await getToken();


final response = await http.patch(

url,

headers: {
  "Content-Type":"application/json",
  "Authorization":"Bearer $token",
},


body: jsonEncode({
  "email": email,
  "phone": phone,
  "address": address,
  "gender": gender,
  "date_of_birth": dateOfBirth,
}),


);


if(response.statusCode == 200){
  return jsonDecode(response.body);
}


throw Exception(response.body);

}


  // ==========================
  // GET ACCESS TOKEN
  // ==========================

  static Future<String?> getToken() async{


    final prefs =
    await SharedPreferences.getInstance();


    return prefs.getString(
      "access"
    );

  }



  // ==========================
  // LOGOUT
  // ==========================

  static Future<void> logout() async{


    final prefs =
    await SharedPreferences.getInstance();


    await prefs.clear();


  }


}