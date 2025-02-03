// Copyright 2025 BenderBlog Rodriguez
// SPDX-License-Identifier: LGPL-2.1-or-later

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../calculator_bridge/calculator_bridge.g.dart';
import '../../model/repl_message.dart';

enum ButtonState {
  normal,
  trigon,
  func,
  others,
}

class ReplPage extends StatefulWidget {
  static const page = "/repl_page";

  const ReplPage({super.key});

  @override
  State<ReplPage> createState() => _ReplState();
}

class _ReplState extends State<ReplPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final CalculatorWrapper _api = CalculatorWrapper();

  var _isComposing = false;
  ButtonState buttonState = ButtonState.normal;

  @override
  void initState() {
    _controller.selection = const TextSelection.collapsed(offset: 0);

    super.initState();
  }

  final rightButtonValues = [
    "trig",
    "f(x)",
    "cons",
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
      "Welcome to Qalculate! 5.5.0 on Flutter!",
    ),
  ];

  Future<String?> formatResponse = Future.value(null);

  Future<void> _handleSubmitted(String input) async {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
    formatResponse = Future.value(null);
    setState(() {
      messages = [
        ReplMessage.evaluate(input),
        ...messages,
      ];
    });
    ReplMessage? message;
    try {
      CalcResult result = await _api.calculate(input);
      switch (result.resultType) {
        case ResultType.failure: message = ReplMessage.error(
          "Error: ${result.message}"
        );break;
        case ResultType.warning: message = ReplMessage.response(
          "Warn: ${result.message}\n"
          "Result: ${result.parsed} -> ${result.result}"
        );break;
        case ResultType.success: message = ReplMessage.response(
          "Result: ${result.parsed} -> ${result.result}"
        );break;
      }
    } catch (e) {
      message = ReplMessage.error(e.toString());
    }
    if (mounted) {
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

  void _buttonCallback(String value) {
    switch (value) {
      case "←":
        if (_controller.selection.base.offset >= 1) {
          _controller.selection = TextSelection.collapsed(
            offset: _controller.selection.base.offset - 1,
          );
        }
        break;
      case "→":
        if (_controller.selection.base.offset != _controller.text.length) {
          _controller.selection = TextSelection.collapsed(
            offset: _controller.selection.base.offset + 1,
          );
        }
        break;
      case '⌫':
        int position = _controller.selection.base.offset;
        if (position == 0) break;
        _controller.text =
            _controller.text.replaceRange(position - 1, position, "");
        _controller.selection = TextSelection.collapsed(offset: position - 1);
        setState(() {
          _isComposing = _controller.text.isNotEmpty;
        });
        break;
      case 'trig':
        setState(() {
          if (buttonState == ButtonState.trigon) {
            buttonState = ButtonState.normal;
          } else {
            buttonState = ButtonState.trigon;
          }
        });
        break;
      case 'f(x)':
        setState(() {
          if (buttonState == ButtonState.func) {
            buttonState = ButtonState.normal;
          } else {
            buttonState = ButtonState.func;
          }
        });
        break;
      case 'cons':
        setState(() {
          if (buttonState == ButtonState.others) {
            buttonState = ButtonState.normal;
          } else {
            buttonState = ButtonState.others;
          }
        });
        break;
      case 'Help':
        launchUrl(Uri.parse("https://qalculate.github.io/manual/qalc.html"));
        break;
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
        _addChar('$value()', offset: '$value()'.length - 1);
        break;
      case '√':
        _addChar('sqrt()', offset: 6);
        break;
      case '∑':
        _addChar('sum()', offset: 4);
        break;
      case '∫':
        _addChar('integrate()', offset: 10);
        break;
      case "Γ":
        _addChar('gamma()', offset: 6);
        break;
      case "f()":
        _addChar(value, offset: value.length - 1);
      case 'abs':
        _addChar("||", offset: 1);
        break;
      case '()':
        _addChar("()", offset: 1);
        break;
      case '⌈⌉':
        _addChar("floor()", offset: 6);
        break;
      case '⌊⌋':
        _addChar("round()", offset: 8);
        break;
      default:
        _addChar(value);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: SafeArea(
            bottom: false,
            child: SelectionArea(
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
        ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, TextEditingValue value, Widget? child) {
            formatResponse = _api.parseCommand(_controller.text);
            return FutureBuilder(
                future: formatResponse,
                builder: (context, response) {
                  return Text(response.data ?? "No data");
                }
            );
          },
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
        const Divider(height: 1.0),
        SafeArea(
          top: false,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(builder: (context) {
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
                  return Column(
                    children: List.generate(
                      buttons.length ~/ 2,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () =>
                                  _buttonCallback(buttons[index * 2]),
                              child: Text(buttons[index * 2]),
                            ),
                            TextButton(
                              onPressed: () =>
                                  _buttonCallback(buttons[index * 2 + 1]),
                              child: Text(buttons[index * 2 + 1]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                Column(
                  children: List.generate(
                    rightButtonValues.length ~/ 3,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          TextButton(
                            style: index * 3 == 0 &&
                                    buttonState == ButtonState.trigon
                                ? FilledButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : null,
                            onPressed: () =>
                                _buttonCallback(rightButtonValues[index * 3]),
                            child: Text(rightButtonValues[index * 3]),
                          ),
                          TextButton(
                            style: index * 3 == 0 &&
                                    buttonState == ButtonState.func
                                ? FilledButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : null,
                            onPressed: () => _buttonCallback(
                                rightButtonValues[index * 3 + 1]),
                            child: Text(rightButtonValues[index * 3 + 1]),
                          ),
                          TextButton(
                            style: index * 3 == 0 &&
                                    buttonState == ButtonState.others
                                ? FilledButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : null,
                            onPressed: () => _buttonCallback(
                                rightButtonValues[index * 3 + 2]),
                            child: Text(rightButtonValues[index * 3 + 2]),
                          ),
                        ],
                      ),
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