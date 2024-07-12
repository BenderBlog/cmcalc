import 'package:cmcalc/src/rust/api/kalk_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/repl_message.dart';

class KalkReplPage extends StatefulWidget {
  const KalkReplPage({super.key});

  @override
  State<KalkReplPage> createState() => _KalkReplState();
}

class _KalkReplState extends State<KalkReplPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  var _isComposing = false;
  List<ReplMessage> messages = [
    ReplMessage.response(
        "It is not not completed, rewriting from kalker rust code."),
    ReplMessage.response("Welcome to Kalk Read–eval–print loop terminal."),
  ];

  void _handleSubmitted(String input) {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
    setState(() {
      messages = [
        ReplMessage.evaluate(input),
        ...messages,
      ];
    });
    ReplMessage? message;
    try {
      KalkResult result = calcStr(input: input);
      if (result.isError) {
        message = ReplMessage.error(result.content);
      } else if (result.content.isNotEmpty) {
        message = ReplMessage.response(result.content);
      }
    } catch (e) {
      message = ReplMessage.error(e.toString());
    }
    if (message != null) {
      setState(() {
        messages = [
          message!,
          ...messages,
        ];
      });
    }
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Patchouli REPL'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Column(
        children: [
          Flexible(
            child: Ink(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: SafeArea(
                bottom: false,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  reverse: true,
                  itemBuilder: (context, idx) => messages[idx].when(
                    evaluate: (str) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '>> $str',
                        style: GoogleFonts.firaCode(
                          textStyle: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    response: (str) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        str,
                        style: GoogleFonts.firaCode(
                          textStyle: Theme.of(context).textTheme.titleMedium,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                    error: (str) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        str,
                        style: GoogleFonts.firaCode(
                          textStyle: Theme.of(context).textTheme.titleSmall,
                          color: Colors.red[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  itemCount: messages.length,
                ),
              ),
            ),
          ),
          const Divider(height: 1.0),
          SafeArea(
            top: false,
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Text('>', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(width: 4),
            Flexible(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                onSubmitted: _isComposing ? _handleSubmitted : null,
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _isComposing
                    ? () => _handleSubmitted(_controller.text)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
