import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:RiveHomePage(),
    );
  }
}


class RiveHomePage extends StatefulWidget {
  const RiveHomePage({super.key});

  @override
  State<RiveHomePage> createState() => _RiveHomePageState();
}

class _RiveHomePageState extends State<RiveHomePage> {

  final rivePath="assets/rive/star_animation.riv";
  final loginBearPath="assets/rive/loginBear.riv";
  StateMachineController? mController ;
  Artboard? mArtBoard;
  SMIInput<bool>? riveInput;
  SMIBool? isChecking;
  SMIBool? isHandsUp;
  SMITrigger? trigSuccess;
  SMITrigger? trigFail;


  var emailController=TextEditingController();
  var passController=TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _initializeRive();


  }





  Future<void> _initializeRive()async{
    await RiveFile.initialize();
    _loadRiveFile();
  }

  Future<void> _loadRiveFile()async{
    await rootBundle.load(loginBearPath).then((riveByteData) {
      var file = RiveFile.import(riveByteData);
      var artboard = file.mainArtboard;
      mController = StateMachineController.fromArtboard(artboard, "Login Machine");
      if (mController != null) {
        artboard.addController(mController!);
        // riveInput = mController!.findInput("check");
        isChecking=mController!.findSMI("isChecking");
        isHandsUp=mController!.findSMI("isHandsUp");
        trigSuccess=mController!.findSMI("trigSuccess");
        trigFail=mController!.findSMI("trigFail");
        setState(() {
          mArtBoard = artboard;
        });

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Rive Animation"),),
        body: mArtBoard==null ? Container(width: 100,height: 100,color: Colors.blue,):
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                children: [
                  Expanded(child: Rive(artboard: mArtBoard!)),
                  SizedBox(height: 50),
                  TextField(
                    decoration: InputDecoration(
                      label: Text("Enter Email")
                    ),
                    onTap: (){
                      isChecking!.value=false;
                      isHandsUp!.value=false;
                      },
                    onChanged: (value){
                      isChecking!.value=true;
                      isHandsUp!.value=false;
                    },
                    onEditingComplete: (){
                      isChecking!.value=false;
                    },
                    onTapOutside: (event){
                      isChecking!.value=false;
                    },
                    onSubmitted: (event){
                      isChecking!.value=false;
                    },

                  ),
                  TextField(
                    decoration: InputDecoration(
                      label: Text("Enter Password")
                    ),
                    onTap: (){
                      isChecking!.value=false;
                      isHandsUp!.value=false;
                    },
                    onChanged: (value){
                      isHandsUp!.value=true;
                      isChecking!.value=false;
                    },

                    onTapOutside: (event){
                      isHandsUp!.value=false;
                      isChecking!.value=false;
                    },
                    onSubmitted: (event){
                      isHandsUp!.value=false;
                    },


                  ),

                  ElevatedButton(onPressed: (){
                    var email=emailController.text.toString();
                    var pass = passController.text.toString();

                    if(email=="Admin" && pass=="12345"){

                      trigSuccess!.value=true;
                     /* if(isHandsUp!.value){     // if true
                        isHandsUp!.value=false;
                        trigSuccess!.value=true;
                      }else{
                        trigSuccess!.value=true;
                      }*/
                    }else {

                      trigFail!.value=true;
                     /* if(isHandsUp!.value){
                        isHandsUp!.value=false;
                        trigFail!.value=true;
                      }else{
                        trigFail!.value=true;
                      }*/
                    }


                  },
                      child: Text("Login")
                  )
                ],
              ),
            )
       

    );
  }
}


