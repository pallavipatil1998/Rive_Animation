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
  StateMachineController? mController ;
  Artboard? mArtBoard;
  SMIInput<bool>? riveInput;


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
    await rootBundle.load(rivePath).then((riveByteData) {
      var file = RiveFile.import(riveByteData);
      var artboard = file.mainArtboard;
      mController = StateMachineController.fromArtboard(artboard, "StarFav");
      if (mController != null) {
        artboard.addController(mController!);
        riveInput = mController!.findInput("check");
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
          Column(children: [
            InkWell(
              onTap: (){
                if(riveInput!= null){
                  if(riveInput!.value==false  && riveInput!.controller.isActive==false){
                    riveInput!.value=true;
                  }else if(riveInput!.value==true && riveInput!.controller.isActive==false){
                    riveInput!.value=false;
                  }
                }
              },
              child: SizedBox(height: 200,width: 200,
                  child: Rive(artboard: mArtBoard!)),
            )
          ],)

    );
  }
}



