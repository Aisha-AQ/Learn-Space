import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/signUp/controller/simple_ui_controller.dart';
import 'package:flutter_application_1/signUp/controller/views/login_view.dart';

import 'package:get/get.dart';

import '../constants.dart';
import 'package:flutter_application_1/allimports.dart';

class LoginPatient extends StatefulWidget {
  const LoginPatient({Key? key}) : super(key: key);

  @override
  State<LoginPatient> createState() => _LoginPatientState();
}
List<bool> _selected = [true, false];
class _LoginPatientState extends State<LoginPatient> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
late SimpleUIController simpleUIController;
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!Get.isRegistered<SimpleUIController>())
    {
      simpleUIController = Get.put(SimpleUIController());
    }else{
      simpleUIController=Get.find<SimpleUIController>();
    }
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
   // SimpleUIController simpleUIController = Get.put(SimpleUIController());
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildLargeScreen(size, simpleUIController);
            } else {
              return _buildSmallScreen(size, simpleUIController);
            }
          },
        ),
      ),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Row(
      children: [
        // Expanded(
        //   flex: 4,
        //   child: RotatedBox(
        //     quarterTurns: 3,
        //     child: Lottie.asset(
        //       'assets/coin.json',
        //       height: size.height * 0.3,
        //       width: double.infinity,
        //       fit: BoxFit.fill,
        //     ),
        //   ),
        // ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(
            size,
            simpleUIController,
          ),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Center(
      child: _buildMainBody(
        size,
        simpleUIController,
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        // size.width > 600
        //     ? Container()
        //     : Lottie.asset(
        //         'assets/wave.json',
        //         height: size.height * 0.2,
        //         width: size.width,
        //         fit: BoxFit.fill,
        //       ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Login',
            style: kLoginTitleStyle(size),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Welcome Back!',
            style: kLoginSubtitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                
                SizedBox(
                  height: size.height * 0.02,
                ),
                /// username or Gmail
                TextFormField(
                  style: kTextFormFieldStyle(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  controller: emailController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    } 
                    return null;
                  },
                ),
                
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// password
                Obx(
                  () => TextFormField(
                    style: kTextFormFieldStyle(),
                    controller: passwordController,
                    obscureText: simpleUIController.isObscure.value,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_open),
                      suffixIcon: IconButton(
                        icon: Icon(
                          simpleUIController.isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          simpleUIController.isObscureActive();
                        },
                      ),
                      hintText: 'Password',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } 
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// Login Button
                loginButton(),
                SizedBox(
                  height: size.height * 0.03,
                ),

                /// Navigate To Login Screen
                GestureDetector(
                  onTap: () {
                    //Navigator.pop(context);
                    nameController.clear();
                    emailController.clear();
                    passwordController.clear();
                    _formKey.currentState?.reset();
                    simpleUIController.isObscure.value = true;
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (ctx) => const LoginView()
                      ));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Log In as Doctor or Caregiver instead',
                      style: kHaveAnAccountStyle(size),
                      children: [
                      ],
                    ),
                  ),
                ),
              ],
              
            ),
          ),
        ),
      ],
    );
  }

  // Login Button
  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () async {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            
            var r= await APIHandler().loginPatient(emailController.text,passwordController.text);
            if(r.statusCode==200)
            {
              dynamic resobj=jsonDecode(r.body);
              Patient u=Patient.fromMap(resobj);
              globalPatient=u;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PatientHome()),
              );
               
            }else if(r.statusCode==404){
              showDialog(context: context, builder: (BuildContext context)=>warningDialog('Warning', 'Register patient first.', context));
              
            }else if(r.statusCode==203){
              showDialog(context: context, builder: (BuildContext context)=>warningDialog('Warning', 'Invalid Username / Password / Role', context));
              
            }else if(r.statusCode==500){
              showDialog(context: context, builder: (BuildContext context)=>warningDialog('Warning', 'We\'ve encountered an erroe\nPlease try logging in again.', context));
            }
            
          }
        },
        child: const Text('Login',style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
