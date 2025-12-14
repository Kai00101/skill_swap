import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:skill_swap/pages/auth/sign_in_page.dart';
import 'package:skill_swap/pages/auth/sign_up_page.dart';


class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: LayoutBuilder(builder:
                  (context, BoxConstraints constraints) {
                return FractionallySizedBox(
                  //widthFactor:constraints.maxWidth>500? 0.5: 1.0,
                  widthFactor:width>500? 0.5: 1.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // HeroWidget(),
                      Lottie.asset('assets/lottie/Welcome.json'),
                      SizedBox(height: 10,),
                       Text('Learn anything Teach anything',
                         textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight:FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 40,
                          ),
                        ),

                      SizedBox(height: 5,),
                    Text(
                        textAlign: TextAlign.center,
                          'Connect with real people who share skills with you',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[500],
                        ),
                    ),

                      SizedBox(height: 30,),

                      ElevatedButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return SignUpPage();
                        },
                        )
                        );
                      },
                        style:ElevatedButton.styleFrom(
                            minimumSize: Size(340,60),
                            //backgroundColor: Color(0xFF39186D),
                          backgroundColor: Colors.deepPurpleAccent

                        ),
                        child: Text(
                            'GET STARTED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        ),

                      ),
                      SizedBox(height: 10,),

                      TextButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          //  return LoginPage(title: 'Login');
                         return SignInPage();
                        },
                        )
                        );
                      },

                        style:TextButton.styleFrom(
                          minimumSize: Size(340,40),
                         //backgroundColor: Color.fromRGBO(135, 206, 235, 100),
                         // backgroundColor: Color(0xFFD6A5D2)
                          backgroundColor: Colors.grey[200]


                        ),
                        child: Text('Login',style: TextStyle(
                            fontSize: 16,
                            color: Colors.deepPurple),),

                      ),

                    ],
                  ),
                );

              },)
          ),
        ),
      ),
    );
  }
}
