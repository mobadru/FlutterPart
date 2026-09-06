import 'dart:convert';
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

  final TextEditingController emailController =
      TextEditingController();


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
        emailController.text = data["email"] ?? "";

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


  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }


  Future<void> editProfile() async {
    final emailEditController = TextEditingController(
      text: emailController.text,
    );
    final phoneController = TextEditingController(
      text: profile?["phone"]?.toString() ?? "",
    );
    final addressController = TextEditingController(
      text: profile?["address"]?.toString() ?? "",
    );
    final genderController = TextEditingController(
      text: profile?["gender"]?.toString() ?? "",
    );
    final dateOfBirthController = TextEditingController(
      text: profile?["date_of_birth"]?.toString() ?? "",
    );
    String? errorMessage;

    final values = await showDialog<Map<String, String?>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Update Profile"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailEditController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    errorText: errorMessage,
                  ),
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: "Phone"),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: "Address"),
                ),
                TextField(
                  controller: genderController,
                  decoration: const InputDecoration(labelText: "Gender"),
                ),
                TextField(
                  controller: dateOfBirthController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: "Date of birth",
                    hintText: "YYYY-MM-DD",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final value = emailEditController.text.trim();
                final validEmail = RegExp(
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                ).hasMatch(value);

                if (value.isEmpty) {
                  setDialogState(() => errorMessage = "Email is required.");
                  return;
                }

                if (!validEmail) {
                  setDialogState(() => errorMessage = "Enter a valid email address.");
                  return;
                }

                Navigator.pop(dialogContext, {
                  "email": value,
                  "phone": phoneController.text.trim(),
                  "address": addressController.text.trim(),
                  "gender": genderController.text.trim(),
                  "date_of_birth": dateOfBirthController.text.trim().isEmpty
                      ? null
                      : dateOfBirthController.text.trim(),
                });
              },
              child: const Text("Update Profile"),
            ),
          ],
        ),
      ),
    );

    emailEditController.dispose();
    phoneController.dispose();
    addressController.dispose();
    genderController.dispose();
    dateOfBirthController.dispose();

    if (values == null || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    try {
      final updated = await ApiService.updateProfile(
        values["email"]!,
        values["phone"] ?? "",
        values["address"] ?? "",
        values["gender"] ?? "",
        values["date_of_birth"],
      );

      if (!mounted) return;

      setState(() {
        profile = updated;
        emailController.text = updated["email"] ?? values["email"]!;
      });

      messenger.showSnackBar(
        const SnackBar(content: Text("Profile updated successfully.")),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text(error.toString().replaceFirst("Exception: ", ""))),
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


  Future<void> showChangePasswordDialog() async {
    final messenger = ScaffoldMessenger.of(context);

    final changed = await showDialog<bool>(
      context: context,
      builder: (_) => const _ChangePasswordDialog(),
    );

    if (!mounted || changed != true) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text("Password changed successfully.")),
      );
    });
  }







  Widget profileCard(

      IconData icon,

      String title,

      String value,

      {VoidCallback? onTap}

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

        onTap: onTap,


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





            // profileCard(

            //   Icons.badge,

            //   "User ID",

            //   profile?["id"]
            //       ?.toString()
            //       ??
            //       "-",

            // ),






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

              onTap: editProfile,

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
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("Update Profile"),
                onPressed: editProfile,
              ),
            ),


            const SizedBox(height:12),


            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.lock_reset),
                label: const Text("Change Password"),
                onPressed: showChangePasswordDialog,
              ),
            ),


            const SizedBox(height:12),






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


class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}


class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final currentController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;
  bool submitting = false;
  String? errorMessage;

  @override
  void dispose() {
    currentController.dispose();
    newController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final currentPassword = currentController.text;
    final newPassword = newController.text;
    final confirmPassword = confirmController.text;

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() => errorMessage = "All password fields are required.");
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() => errorMessage = "New passwords do not match.");
      return;
    }

    setState(() {
      submitting = true;
      errorMessage = null;
    });

    try {
      await ApiService.changePassword(
        currentPassword,
        newPassword,
        confirmPassword,
      );

      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;

      var message = error.toString().replaceFirst("Exception: ", "");
      try {
        final decoded = jsonDecode(message);
        final detail = decoded["detail"];
        message = detail is List ? detail.join("\n") : detail.toString();
      } catch (_) {
        // Keep the server message when it is not JSON.
      }

      setState(() {
        submitting = false;
        errorMessage = message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change Password"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _passwordField(
              controller: currentController,
              label: "Current Password",
              obscure: obscureCurrent,
              onToggle: () => setState(() => obscureCurrent = !obscureCurrent),
            ),
            const SizedBox(height: 12),
            _passwordField(
              controller: newController,
              label: "New Password",
              obscure: obscureNew,
              onToggle: () => setState(() => obscureNew = !obscureNew),
            ),
            const SizedBox(height: 12),
            _passwordField(
              controller: confirmController,
              label: "Confirm New Password",
              obscure: obscureConfirm,
              onToggle: () => setState(() => obscureConfirm = !obscureConfirm),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: submitting ? null : () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: submitting ? null : submit,
          child: submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text("Change Password"),
        ),
      ],
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggle,
        ),
      ),
    );
  }
}