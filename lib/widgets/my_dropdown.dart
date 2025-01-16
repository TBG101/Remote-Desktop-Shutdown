import 'package:flutter/material.dart';

class MyDropdown extends StatelessWidget {
  final String dropDownValue;

  final List<String> listOfHosts;

  final ValueSetter<String?> onChanged;

  const MyDropdown(
      {super.key,
      required this.dropDownValue,
      required this.listOfHosts,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width - 20 - 100 - 5 * 2,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          alignment: Alignment.center,
          isExpanded: true,
          value: dropDownValue,
          padding: const EdgeInsets.all(2),
          hint: const Text("Select Host"),
          items: ["Broadcast", ...listOfHosts].map((host) {
            return DropdownMenuItem<String>(
              value: host,
              child: Text(host),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownColor: Colors.grey[850],
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
