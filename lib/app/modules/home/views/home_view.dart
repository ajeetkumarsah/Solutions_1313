import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/utils/language.dart';
import 'package:flutter_dialogflow/v2/auth_google.dart';
import 'package:flutter_dialogflow/v2/dialogflow_v2.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solutions_1313/app/modules/home/views/widgets/nm_box.dart';
import 'package:solutions_1313/app/routes/app_pages.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<String> data = [];
  TextEditingController messageInsert = TextEditingController();
  List<Map> messsages = [];
  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/service.json").build();
    debugPrint('==>API calling');
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    debugPrint('==>API project id' + authGoogle.getProjectId);

    AIResponse aiResponse = await dialogflow.detectIntent(query);
    if (aiResponse == null || aiResponse.getMessage() == null) {
      debugPrint('==>API response is null :(');
    } else {
      debugPrint(
          '==>API Response:' + aiResponse.getListMessage()[0].toString());
    }
    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });

    debugPrint(aiResponse.getListMessage()[0]["text"]["text"][0].toString());
  }

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _lastWords = result.recognizedWords;
    if (_lastWords.isEmpty) {
      print("empty message");
    } else {
      setState(() {
        messsages.insert(0, {"data": 1, "message": _lastWords});
      });
      response(_lastWords);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mC,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Neumorphic(
            style: NeumorphicStyle(
                intensity: 0.4,
                shape: NeumorphicShape.flat,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(24)),
                depth: 4,
                lightSource: LightSource.topLeft,
                color: Colors.white),
            child: Container(
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ListTile(
                    leading: Neumorphic(
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(24),
                          ),
                          depth: -8,
                          lightSource: LightSource.topLeft,
                          color: Colors.white),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        height: 50,
                        width: 50,
                        child: const CircleAvatar(
                          backgroundImage: AssetImage("assets/bot.png"),
                        ),
                      ),
                    ),
                    title: const Text(
                      'Solutions 1313',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'online',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Neumorphic(
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(24),
                          ),
                          depth: 4,
                          lightSource: LightSource.topLeft,
                          color: Colors.white),
                      child: IconButton(
                        icon: const Icon(
                          Icons.graphic_eq,
                          size: 24.0,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          Get.toNamed(Routes.GRAPH);
                          //
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: ListView.builder(
              reverse: true,
              itemCount: messsages.length,
              itemBuilder: (context, index) => chat(
                messsages[index]["message"].toString(),
                messsages[index]["data"],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Neumorphic(
              style: NeumorphicStyle(
                  shape: NeumorphicShape.flat,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
                  depth: 4,
                  lightSource: LightSource.topLeft,
                  shadowDarkColor: Colors.grey[300],
                  color: Colors.white),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                child: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Neumorphic(
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(32)),
                        depth: -5,
                        lightSource: LightSource.topLeft,
                        color: Colors.white),
                    child: IconButton(
                      icon: const Icon(
                        Icons.mic,
                        color: Colors.grey,
                        size: 24,
                      ),
                      onPressed: _speechToText.isNotListening
                          ? _startListening
                          : _stopListening,
                    ),
                  ),
                  title: Container(
                    height: 35,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      // color: Color.fromRGBO(220, 220, 220, 1),
                    ),
                    padding: const EdgeInsets.only(left: 2),
                    child: TextFormField(
                      controller: messageInsert,
                      decoration: const InputDecoration(
                        hintText: "Enter a Message...",
                        hintStyle: TextStyle(color: Colors.black26),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      onChanged: (value) {},
                    ),
                  ),
                  trailing: Neumorphic(
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.concave,
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(24),
                        ),
                        depth: 4,
                        lightSource: LightSource.topLeft,
                        color: Colors.white),
                    child: IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          size: 24.0,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          if (messageInsert.text.isEmpty) {
                            print("empty message");
                          } else {
                            setState(() {
                              messsages.insert(0,
                                  {"data": 1, "message": messageInsert.text});
                            });
                            response(messageInsert.text);
                            messageInsert.clear();
                          }
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        }),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15.0)
        ],
      ),
    );
  }

  //for better one i have use the bubble package check out the pubspec.yaml

  Widget chat(String message, int data) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment:
            data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0
              ? Container(
                  height: 30,
                  width: 30,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/bot.png"),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Neumorphic(
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(12),
                ),
                depth: 4,
                intensity: 0.6,
                lightSource: LightSource.topLeft,
                color: Colors.white,
              ),
              child: Bubble(
                radius: const Radius.circular(15.0),
                color: Colors.white,
                elevation: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Text(
                            message,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          data == 1
              ? Container(
                  height: 30,
                  width: 30,
                  child: const CircleAvatar(
                    backgroundImage: AssetImage("assets/user.png"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class NMButton extends StatelessWidget {
  final bool down;
  final IconData icon;
  const NMButton({required this.down, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 55,
      decoration: down ? nMboxInvert : nMbox,
      child: Icon(
        icon,
        color: down ? fCD : fCL,
      ),
    );
  }
}
