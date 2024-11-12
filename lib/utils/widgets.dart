import 'package:flutter/material.dart';

List<Color> colors = [
  const Color(0xFFFFFFFF),
  const Color(0xffF28B83),
  const Color(0xFFFCBC05),
  const Color(0xFFFFF476),
  const Color(0xFFCBFF90)
];

class PriorityPicker extends StatefulWidget {
  final Function(int) onTap;
  final int selectedIndex;

  const PriorityPicker({
    Key? key,
    required this.onTap,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  _PriorityPickerState createState() => _PriorityPickerState();
}

class _PriorityPickerState extends State<PriorityPicker> {
  late int selectedIndex;

  final List<String> priorityText = ['Low', 'High', 'Very High'];
  final List<Color> priorityColor = [
    Colors.green,
    Colors.lightGreen,
    Colors.red
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 75,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: priorityText.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  widget.onTap(index);
                },
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  width: 110,
                  height: 70,
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? priorityColor[index]
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      width: selectedIndex == index ? 3.0 : 1.0,
                      color:
                          selectedIndex == index ? Colors.black : Colors.grey,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      priorityText[index],
                      style: TextStyle(
                        color: selectedIndex == index
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ColorPicker extends StatefulWidget {
  final Function(int) onTap;
  final int selectedIndex;

  const ColorPicker({
    Key? key,
    required this.onTap,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onTap(index);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colors[index],
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: Colors.black),
              ),
              child: Center(
                child: selectedIndex == index
                    ? const Icon(Icons.done, color: Colors.white)
                    : Container(),
              ),
            ),
          );
        },
      ),
    );
  }
}
