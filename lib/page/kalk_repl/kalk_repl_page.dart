import 'package:cmcalc/src/rust/api/kalk_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grid_button/flutter_grid_button.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/repl_message.dart';

enum ButtonState {
  normal,
  trigon,
  func,
  others,
}

class KalkReplPage extends StatefulWidget {
  static const page = "/kalk_repl_page";

  const KalkReplPage({super.key});

  @override
  State<KalkReplPage> createState() => _KalkReplState();
}

class _KalkReplState extends State<KalkReplPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  var _isComposing = false;
  ButtonState buttonState = ButtonState.normal;

  @override
  void initState() {
    _controller.selection = const TextSelection.collapsed(offset: 0);
    super.initState();
  }

  final rightButtonValues = [
    "trigon",
    "func",
    "others",
    "←",
    "→",
    "⌫",
    "7",
    "8",
    "9",
    "4",
    "5",
    "6",
    "1",
    "2",
    "3",
    "0",
    ".",
    "Help",
  ];

  final leftButtonDefault = [
    "abs",
    "!",
    "mod",
    "()",
    "⌈⌉",
    "+",
    "⌊⌋",
    "-",
    "^",
    "×",
    "%",
    "÷",
  ];

  final leftButtonTrigon = [
    "asin",
    "sin",
    "acos",
    "cos",
    "atan",
    "tan",
    "sqrt",
    "log",
    "exp",
    "ln",
    ",",
    "=",
  ];

  final leftButtonFunc = [
    "x",
    "∑",
    "y",
    "∫",
    "d",
    "'",
    "exp",
    "Γ",
    ";",
    "f()",
    ",",
    "=",
  ];

  final leftButtonOthers = [
    "π",
    "e",
    "τ",
    "ϕ",
    "≤",
    "≥",
    "<",
    ">",
    "and",
    "or",
    "not",
    "=",
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

  void _addChar(String string, {int? offset}) {
    int position = _controller.selection.base.offset;
    _controller.text = _controller.text.substring(0, position) +
        string +
        _controller.text.substring(position);
    if (offset == null) {
      _controller.selection =
          TextSelection.collapsed(offset: position + string.length);
    } else {
      _controller.selection =
          TextSelection.collapsed(offset: position + offset);
    }

    setState(() {
      _isComposing = _controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
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
        const Divider(height: 1.0),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: Row(
            children: [
              Text(
                '>>',
                style: GoogleFonts.firaCode(
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
              ),
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
        SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            constraints: const BoxConstraints(
              maxHeight: 240,
              maxWidth: 480,
            ),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Builder(builder: (context) {
                    late List<String> buttons;
                    switch (buttonState) {
                      case ButtonState.normal:
                        buttons = leftButtonDefault;
                      case ButtonState.trigon:
                        buttons = leftButtonTrigon;
                      case ButtonState.func:
                        buttons = leftButtonFunc;
                      case ButtonState.others:
                        buttons = leftButtonOthers;
                    }
                    return GridButton(
                      borderColor: Colors.transparent,
                      onPressed: (value) {
                        switch (value) {
                          case "asin":
                          case "sin":
                          case "acos":
                          case "cos":
                          case "atan":
                          case "tan":
                          case "sqrt":
                          case "log":
                          case "exp":
                          case "ln":
                          case '√':
                          case '∑':
                          case '∫':
                          case "Γ":
                            _addChar('$value()', offset: '$value()'.length - 1);
                            break;
                          case "f()":
                            _addChar(value, offset: '$value'.length - 1);
                          case 'abs':
                            _addChar("||", offset: 1);
                            break;
                          case '()':
                            _addChar("()", offset: 1);
                            break;
                          case '⌈⌉':
                            _addChar("⌈⌉", offset: 1);
                            break;
                          case '⌊⌋':
                            _addChar("⌊⌋", offset: 1);
                            break;
                          default:
                            _addChar(value);
                            break;
                        }
                      },
                      items: List<List<GridButtonItem>>.generate(
                        buttons.length ~/ 2,
                        (index) => [
                          GridButtonItem(
                            title: buttons[index * 2],
                          ),
                          GridButtonItem(
                            title: buttons[index * 2 + 1],
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                Flexible(
                  flex: 4,
                  child: GridButton(
                    borderColor: Colors.transparent,
                    onPressed: (value) {
                      switch (value) {
                        case "←":
                          if (_controller.selection.base.offset >= 1) {
                            _controller.selection = TextSelection.collapsed(
                              offset: _controller.selection.base.offset - 1,
                            );
                          }
                          break;
                        case "→":
                          if (_controller.selection.base.offset !=
                              _controller.text.length) {
                            _controller.selection = TextSelection.collapsed(
                              offset: _controller.selection.base.offset + 1,
                            );
                          }
                          break;
                        case '⌫':
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
                        case 'trigon':
                          setState(() {
                            if (buttonState == ButtonState.trigon) {
                              buttonState = ButtonState.normal;
                            } else {
                              buttonState = ButtonState.trigon;
                            }
                          });
                          break;
                        case 'func':
                          setState(() {
                            if (buttonState == ButtonState.func) {
                              buttonState = ButtonState.normal;
                            } else {
                              buttonState = ButtonState.func;
                            }
                          });
                          break;
                        case 'others':
                          setState(() {
                            if (buttonState == ButtonState.others) {
                              buttonState = ButtonState.normal;
                            } else {
                              buttonState = ButtonState.others;
                            }
                          });
                          break;
                        case 'Help':
                          context.go('help');
                          break;
                        default:
                          _addChar(value);
                          break;
                      }
                    },
                    items: List<List<GridButtonItem>>.generate(
                      rightButtonValues.length ~/ 3,
                      (index) => [
                        GridButtonItem(
                          title: rightButtonValues[index * 3],
                        ),
                        GridButtonItem(
                          title: rightButtonValues[index * 3 + 1],
                        ),
                        GridButtonItem(
                          title: rightButtonValues[index * 3 + 2],
                        ),
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
