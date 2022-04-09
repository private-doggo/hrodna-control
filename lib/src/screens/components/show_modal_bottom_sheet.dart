import 'package:flutter/material.dart';

void modalBottomSheet(context, titleStop, titleDirection) {
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
        height: 350,
        // color: Colors.amber,
        child: Stack(
          children: [
            Align(
              alignment: const FractionalOffset(0.1, 0.03),
              child: OutlinedButton(
                onPressed: () {
                  // Respond to button press
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 1, color: Colors.red.withOpacity(0.5)),
                ),
                child: const Text("Тревожная кнопка"),
              ),
            ),
            Align(
              alignment: const FractionalOffset(0.9, 0.03),
              child: OutlinedButton(
                onPressed: () {
                  // Respond to button press
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 1, color: Colors.green.withOpacity(0.5)),
                ),
                child: const Text("Отметить \"чисто\""),
              ),
            ),
            ListView(),
          ],
        ),
      );
    },
  );
}