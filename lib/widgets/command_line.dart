import 'package:flutter/material.dart';

class CommandLineInputWidget extends StatelessWidget {
  final ValueSetter<String> onCommandSent;
  final List<String> commandLineHistory;
  final TextEditingController texteditingController;

  const CommandLineInputWidget(
      {super.key,
      required this.onCommandSent,
      required this.commandLineHistory,
      required this.texteditingController});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...commandLineHistory.map(
                  (e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        e,
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  },
                ),
                TextField(
                  controller: texteditingController,
                  onSubmitted: onCommandSent,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    contentPadding: EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    hintText: '>',
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
