import 'package:flutter/material.dart';
import 'package:image_guesser/image_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> vehicleNames = [
    'car1',
    'car2',
    'car3',
    'car4',
    'car5',
    'car6',
    'car7',
    'car8',
    'car9',
    'car10'
  ];
  String currentVehicleName = '';
  double scrollPercent = 0.0;
  late Offset startDrag;
  double startDragPercentScroll = 0.0;
  double finishScrollStart = 0.0;
  double finishScrollEnd = 0.0;

  List<Widget> buildCards() {
    List<Widget> cardsList = [];
    for (int i = 0; i < vehicleNames.length; i++) {
      cardsList.add(buildCard(i, scrollPercent));
    }
    return cardsList;
  }

  Widget buildCard(int cardIndex, double scrollPercent) {
    final cardScrollPercent = scrollPercent / (1 / vehicleNames.length);
    return FractionalTranslation(
      translation: Offset(cardIndex - cardScrollPercent, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ImageCard(
          imageName: vehicleNames[cardIndex],
          onTap: () {},
        ),
      ),
    );
  }

  onHorizontalDragStart(DragStartDetails details) {
    startDrag = details.globalPosition;
    startDragPercentScroll = scrollPercent;
  }

  onHorizontalDragUpdate(DragUpdateDetails details) {
    final currentDrag = details.globalPosition;
    final dragDistance = currentDrag.dx - startDrag.dx;
    final singleCardDragPercent = dragDistance / context.size!.width;
    setState(() {
      scrollPercent = (startDragPercentScroll +
              (-singleCardDragPercent / vehicleNames.length))
          .clamp(0.0, 1.0 - (1 / vehicleNames.length));
      currentVehicleName =
          vehicleNames[(scrollPercent * vehicleNames.length).round()];
    });
  }

  onHorizontalDragEnd(DragEndDetails details) {
    finishScrollStart = scrollPercent;
    finishScrollEnd =
        (scrollPercent * vehicleNames.length).round() / vehicleNames.length;
    setState(() {
      startDrag = Offset.zero;
      startDragPercentScroll = 0.0;
      currentVehicleName = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onHorizontalDragStart: onHorizontalDragStart,
              onHorizontalDragUpdate: onHorizontalDragUpdate,
              onHorizontalDragEnd: onHorizontalDragEnd,
              behavior: HitTestBehavior.translucent,
              child: Stack(
                children: buildCards(),
              ),
            ),
            OutlinedButton(
                onPressed: () => {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(10.0),
                  side: const BorderSide(width: 4.0, color: Colors.black),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                child: const Text(
                  'Short Answer',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
            Text(
              currentVehicleName,
              style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  letterSpacing: 2),
            ),
          ],
        ),
      ),
    );
  }
}
