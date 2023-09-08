import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nixieappflutter/models/chatmodel.dart';
import 'package:nixieappflutter/provider/model_provider.dart';
import 'package:nixieappflutter/services/aimodelscreen.dart';
import 'package:nixieappflutter/services/api.dart';
import 'package:nixieappflutter/widgets/chat_widget.dart';
import 'package:nixieappflutter/widgets/text_widget.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isTyping = false;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  late TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController();
    _listScrollController = ScrollController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '#Nixie',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await AiModel.showModalSheet(context: context);
            },
            icon: Icon(Icons.menu),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: _listScrollController,
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatList[index].msg,
                    chatIndex: chatList[index].chatIndex,
                  );
                },
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.deepPurple,
                size: 18,
              )
            ],
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: focusNode,
                      controller: textEditingController,
                      onSubmitted: (value) async {
                        await sendMessageFCT(modelsProvider: modelsProvider);
                      },
                      decoration: InputDecoration(
                        hintText: 'Ask me anything',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            await sendMessageFCT(
                                modelsProvider: modelsProvider);
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void scrollListToEnd() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 50),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT({required ModelsProvider modelsProvider}) async {
    if (textEditingController.text.isEmpty) {
      return;
    }
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You can't send multiple messages at the same time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        chatList.add(ChatModel(msg: msg, chatIndex: 0));
        textEditingController.clear();
        focusNode.unfocus();
      });
      chatList.addAll(
        await Api.sendMessage(
            message: msg, modelId: modelsProvider.getCurrentModel),
      );
      setState(() {});
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        scrollListToEnd();
        _isTyping = false;
      });
    }
  }
}
