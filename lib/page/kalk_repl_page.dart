import 'package:cmcalc/src/rust/api/kalk_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
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

  final functionDict = {
    "ceil": "⌈⌉",
    "deg": "°",
    "floor": "⌊⌋",
    "gamma": "Γ",
    "sum": "Σ()",
    "prod": "∏()",
    "integrate": "∫()",
    "integral": "∫()",
    "phi": "ϕ",
    "pi": "π",
    "sqrt": "√",
    "tau": "τ",
    "(": "()",
    "[[": "⟦⟧",
    "!=": "≠",
    ">=": "≥",
    "<=": "≤",
    " and": " ∧",
    " or": " ∨",
    " not": " ¬",
    "*": "×",
    "/": "÷",
    "^T": "ᵀ",
    "asin": "sin⁻¹()",
    "acos": "cos⁻¹()",
    "atan": "tan⁻¹()",
    "acot": "cot⁻¹()",
    "acosec": "cosec⁻¹()",
    "asec": "sec⁻¹()",
    "asinh": "sinh⁻¹()",
    "acosh": "cosh⁻¹()",
    "atanh": "tanh⁻¹()",
    "acoth": "coth⁻¹()",
    "acosech": "cosech⁻¹()",
    "asech": "sech⁻¹()",
    "cbrt": "∛",
  };

  final buttonRowValues = [
    ...List.generate(10, (index) => index.toString()),
    "+",
    "-",
    "×",
    "÷",
    "^",
    "=",
    ".",
    "(",
    "←",
    "→",
    "√",
    "π",
    ",",
    "%",
    "∑",
    "⌊",
    "⌈",
    "∫",
    "x",
    "DEL"
  ];

  List<ReplMessage> messages = [
    ReplMessage.response(
      "Welcome to Kalk Read–eval–print loop terminal. "
      "It is not completed, rewriting from kalker rust code.",
    ),
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

  void _addChar(String string, {int offset = 1}) {
    int position = _controller.selection.base.offset;
    _controller.text = _controller.text.substring(0, position) +
        string +
        _controller.text.substring(position);
    _controller.selection = TextSelection.collapsed(offset: position + offset);
    setState(() {
      _isComposing = _controller.text.isNotEmpty;
    });
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
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
          const Divider(height: 1.0),
          SafeArea(
            top: false,
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildSymbolButtonGrid(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymbolButtonGrid() => Container(
        margin: const EdgeInsets.all(4),
        child: LayoutGrid(
          rowSizes: List.generate(3, (index) => auto),
          columnSizes: List.generate(10, (index) => auto),
          gridFit: GridFit.expand,
          children: List<Widget>.generate(
            buttonRowValues.length,
            (index) => ReplButton(
              text: buttonRowValues[index],
              onPressed: () {
                switch (buttonRowValues[index]) {
                  case "←":
                    if (_controller.selection.base.offset >= 1) {
                      _controller.selection = TextSelection.collapsed(
                        offset: _controller.selection.base.offset - 1,
                      );
                    }
                    break;
                  case "→":
                    if (index == 1 &&
                        _controller.selection.base.offset !=
                            _controller.text.length) {
                      _controller.selection = TextSelection.collapsed(
                        offset: _controller.selection.base.offset + 1,
                      );
                    }
                    break;
                  case 'DEL':
                    int position = _controller.selection.base.offset;
                    if (position == 0) break;
                    _controller.text = _controller.text
                        .replaceRange(position - 1, position, "");
                    _controller.selection =
                        TextSelection.collapsed(offset: position - 1);
                    setState(() {
                      _isComposing = _controller.text.isNotEmpty;
                    });
                    break;
                  case '√':
                  case '∑':
                  case '∫':
                    _addChar("${buttonRowValues[index]}()", offset: 2);
                    break;
                  case '(':
                    _addChar("()");
                    break;
                  case '⌈':
                    _addChar("⌈⌉");
                    break;
                  case '⌊':
                    _addChar("⌊⌋");
                    break;
                  default:
                    _addChar(buttonRowValues[index]);
                    break;
                }
              },
            ).withGridPlacement(),
          ),
        ),
      );

  Widget _buildTextComposer() => IconTheme(
        data: IconThemeData(
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Container(
            margin: const EdgeInsets.all(4),
            child: Row(
              children: [
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
            )),
      );
}

class ReplButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const ReplButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      icon: Text(text),
    );
  }
}
