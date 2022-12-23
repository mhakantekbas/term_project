import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool favorite = false;
  final List<String> _filters = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(255, 53, 83, 88),
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              "Pick 3 Genres to Get Started!",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 5.0),
              Wrap(
                spacing: 5.0,
                children: ExerciseFilter.values.map((ExerciseFilter exercise) {
                  return FilterChip(
                    selectedColor: Color.fromARGB(255, 255, 205, 55),
                    backgroundColor: Color.fromARGB(255, 53, 83, 88),
                    label: Text(
                      exercise.name,
                      style: TextStyle(color: Colors.white),
                    ),
                    selected: _filters.contains(exercise.name),
                    onSelected: (bool value) {
                      setState(() {
                        if (value) {
                          if (!_filters.contains(exercise.name)) {
                            _filters.add(exercise.name);
                          }
                        } else {
                          _filters.removeWhere((String name) {
                            return name == exercise.name;
                          });
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    _filters.length < 4
                        ? Colors.grey
                        : Color.fromARGB(255, 255, 205, 55))),
            onPressed: (() {}),
            icon: Icon(Icons.done_outline),
            label: Text("LET'S START 4/${_filters.length}"))
      ],
    )));
  }
}

enum ExerciseFilter {
  Fantasy,
  Philosophy,
  Psychology,
  Horror,
  Dystopian,
  Biography,
  Science_Fiction,
  Non_Fiction,
  Mystery,
  Thriller,
}
