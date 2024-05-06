import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instattendance/controller/attendance_controller.dart';
import 'package:instattendance/controller/teacher_controller.dart';
import 'package:instattendance/helper/bottom_navigation/bottom_navigation.dart';
import 'package:instattendance/models/teacher.dart';
import 'package:instattendance/widgets/custom_button.dart';
import 'package:instattendance/widgets/custom_heading_text.dart';

class AuthenticationView extends StatelessWidget {
  AuthenticationView({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TeacherController _teacherController = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Material(
              child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(30.0),
        color: Colors.white,
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const HeadingText(
              headingText: "Instattendance", color: Colors.indigoAccent),
          Image.network(
            "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTxoKGaAp_0c2MV5TTAuA1FI_DH15gErpNuUJm35yuMplHU2xpe",
            fit: BoxFit.contain,
            height: 120,
            width: 200,
          ),
          const Padding(padding: EdgeInsets.only(top: 30.0)),
          Text('Faculty Login',
              style: GoogleFonts.ubuntu(fontSize: 20, color: Colors.indigo)),
          const Padding(padding: EdgeInsets.only(top: 14.0)),
          Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    constraints:
                        const BoxConstraints(maxWidth: 280.0, maxHeight: 55.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Enter Email",
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(),
                        ),
                      ),
                      validator: emailValidator,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20.0)),
                  Container(
                    constraints:
                        const BoxConstraints(maxWidth: 280.0, maxHeight: 55.0),
                    child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Enter Password",
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(),
                          ),
                        ),
                        validator: passwordValidator,
                        keyboardType: TextInputType.visiblePassword),
                  ),
                ],
              )),
          const Padding(padding: EdgeInsets.only(top: 20.0)),
          CustomButton(
              msg: 'Login',
              icon: Icons.login,
              onTap: () {
                isValidForm(context);
              }),
        ])),
      ))),
    );
  }

  String? emailValidator(String? val) {
    if (val!.isEmpty) {
      return 'Oops,Email number is empty';
    }
    emailController.text = val;
  }

  String? passwordValidator(String? val) {
    if (val!.isEmpty) {
      return 'Oops,password is empty';
    }
    passwordController.text = val;
  }

  isValidForm(BuildContext context) async {
    final FormState? state = formKey.currentState;
    if (state!.validate()) {
      print('vaild');
      authenticateTeacher(context);
      /*_teacherController.authenticateTeacher(
                    emailController.text, passwordController.text);*/
    } else {
      print('invalid');
    }
  }

  authenticateTeacher(BuildContext context) async {
    Teacher? teacher = await _teacherController.authenticateTeacher(
        emailController.text, passwordController.text,context);
    if (teacher != null) {
      _teacherController.onSave();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const BottomNavigation()),
          (Route<dynamic> route) => false);
    }
  }
}
