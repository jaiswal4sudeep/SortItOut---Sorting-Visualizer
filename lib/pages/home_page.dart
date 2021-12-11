import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF0E1419),
        child: Stack(
          alignment: Alignment.center,
          children: const [
            Center(
              child: Image(
                image: AssetImage('assets/images/splashlogo.png'),
              ),
            ),
            Positioned(
              bottom: 60,
              child: Text(
                'SortItOut',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD3D3D3),
                  letterSpacing: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentSortingTitle = 'Bubble Sort';
  String currentSortingDef =
      'Bubble Sort is the simplest sorting algorithm that works by repeatedly swapping the adjacent elements if they are in wrong order.';
  String currentSortingBestTimeComplexity = 'Θ(N)';
  String currentSortingWorstTimeComplexity = 'Θ(N^2)';
  String currentSortingAvgTimeComplexity = 'Θ(N^2)';
  String currentSortingSpaceComplexity = 'Θ(1)';
  String currentSortingCode = 'assets/images/bubblesort.png';

  bool isSorting = false;

  int initialDuration = 3;
  final double minDuration = 1.0;
  final double maxDuration = 5.0;
  final divisionDuration = 10;
  late int currentDuration = 3000;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Color preColor = const Color(0xFFCDD1CC);

  DateTime? lastPressed;

  List<int> numbers = [];
  int sampleSize = 100;

  randomize() {
    if (!isSorting) {
      preColor = const Color(0xFFCDD1CC);
      numbers = [];
      for (int i = 0; i < sampleSize / 2; ++i) {
        numbers.add(Random().nextInt(sampleSize));
      }
      setState(() {});
    }
  }

  setSortAlgo(String type) {
    setState(() {
      currentSortingTitle = type;
    });
  }

  sortItOut() async {
    Stopwatch stopwatch = Stopwatch()..start();
    switch (currentSortingTitle) {
      case "Bubble Sort":
        await bubbleSort();
        break;

      case "Selection Sort":
        await selectionSort();
        break;

      case "Insertion Sort":
        await insertionSort();
        break;

      case "Shell Sort":
        await shellSort();
        break;

      case "Odd-Even Sort":
        await oddEvenSort();
        break;
    }
    stopwatch.stop();
    scaffoldKey.currentState!.removeCurrentSnackBar();
    scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(
          "Sorting completed in ${stopwatch.elapsed.inMilliseconds} ms!",
        ),
      ),
    );
  }

  bubbleSort() async {
    isSorting = true;
    for (int i = 0; i < numbers.length; ++i) {
      for (int j = 0; j < numbers.length - i - 1; ++j) {
        if (numbers[j] > numbers[j + 1]) {
          int temp = numbers[j];
          numbers[j] = numbers[j + 1];
          numbers[j + 1] = temp;
        }
        await Future.delayed(Duration(microseconds: currentDuration));
        setState(() {});
      }
    }
    isSorting = false;
    preColor = const Color(0xFF0AB377);
  }

  selectionSort() async {
    isSorting = true;
    for (int i = 0; i < numbers.length; i++) {
      for (int j = i + 1; j < numbers.length; j++) {
        if (numbers[i] > numbers[j]) {
          int temp = numbers[j];
          numbers[j] = numbers[i];
          numbers[i] = temp;
        }
        await Future.delayed(Duration(microseconds: currentDuration));
        setState(() {});
      }
    }
    isSorting = false;
    preColor = const Color(0xFF0AB377);
  }

  insertionSort() async {
    isSorting = true;
    for (int i = 1; i < numbers.length; i++) {
      int temp = numbers[i];
      int j = i - 1;
      while (j >= 0 && temp < numbers[j]) {
        numbers[j + 1] = numbers[j];
        --j;
        await Future.delayed(Duration(microseconds: currentDuration));
        setState(() {});
      }
      numbers[j + 1] = temp;
      await Future.delayed(Duration(microseconds: currentDuration));
      setState(() {});
    }
    isSorting = false;
    preColor = const Color(0xFF0AB377);
  }

  shellSort() async {
    isSorting = true;
    for (int gap = numbers.length ~/ 2; gap > 0; gap ~/= 2) {
      for (int i = gap; i < numbers.length; i += 1) {
        int temp = numbers[i];
        int j;
        for (j = i; j >= gap && numbers[j - gap] > temp; j -= gap) {
          numbers[j] = numbers[j - gap];
        }
        numbers[j] = temp;
        await Future.delayed(Duration(microseconds: currentDuration));
        setState(() {});
      }
    }
    isSorting = false;
    preColor = const Color(0xFF0AB377);
  }

  int getNextGap(int gap) {
    gap = (gap * 10) ~/ 13;

    if (gap < 1) return 1;
    return gap;
  }

  oddEvenSort() async {
    isSorting = true;
    bool isSorted = false;

    while (!isSorted) {
      isSorted = true;

      for (int i = 1; i <= numbers.length - 2; i = i + 2) {
        if (numbers[i] > numbers[i + 1]) {
          int temp = numbers[i];
          numbers[i] = numbers[i + 1];
          numbers[i + 1] = temp;
          isSorted = false;
          await Future.delayed(Duration(microseconds: currentDuration));
          setState(() {});
        }
      }

      for (int i = 0; i <= numbers.length - 2; i = i + 2) {
        if (numbers[i] > numbers[i + 1]) {
          int temp = numbers[i];
          numbers[i] = numbers[i + 1];
          numbers[i + 1] = temp;
          isSorted = false;
          await Future.delayed(Duration(microseconds: currentDuration));
          setState(() {});
        }
      }
    }
    isSorting = false;
    preColor = const Color(0xFF0AB377);

    return;
  }

  @override
  void initState() {
    super.initState();
    randomize();
  }

  @override
  Widget build(BuildContext context) {
    int counter = 0;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          currentSortingTitle.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFFCDD1CC),
            letterSpacing: 2.0,
            wordSpacing: 2.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: const Color(0xFF0E1419),
        actions: [
          PopupMenuButton(
            initialValue: currentSortingTitle,
            color: const Color(0xFF0E1419),
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: Text(
                  'Bubble Sort',
                  style: TextStyle(
                    color: Color(0xFFCDD1CC),
                    fontFamily: 'Roboto',
                  ),
                ),
                value: '1',
              ),
              const PopupMenuItem(
                child: Text(
                  'Selection Sort',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xFFCDD1CC),
                  ),
                ),
                value: '2',
              ),
              const PopupMenuItem(
                child: Text(
                  'Insertion Sort',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xFFCDD1CC),
                  ),
                ),
                value: '3',
              ),
              const PopupMenuItem(
                child: Text(
                  'Shell Sort',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xFFCDD1CC),
                  ),
                ),
                value: '4',
              ),
              const PopupMenuItem(
                child: Text(
                  'Odd-Even Sort',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xFFCDD1CC),
                  ),
                ),
                value: '5',
              ),
            ],
            onSelected: (String newVal) {
              randomize();
              setSortAlgo(newVal);
              setState(() {
                switch (newVal) {
                  case '1':
                    currentSortingTitle = 'Bubble Sort';
                    currentSortingDef =
                        'Bubble Sort is the simplest sorting algorithm that works by repeatedly swapping the adjacent elements if they are in wrong order.';
                    currentSortingBestTimeComplexity = 'Θ(n)';
                    currentSortingWorstTimeComplexity = 'Θ(n^2)';
                    currentSortingAvgTimeComplexity = 'Θ(n^2)';
                    currentSortingSpaceComplexity = 'Θ(1)';
                    currentSortingCode = 'assets/images/bubblesort.png';
                    break;

                  case '2':
                    currentSortingTitle = 'Selection Sort';
                    currentSortingDef =
                        'The selection sort algorithm sorts an array by repeatedly finding the minimum element (considering ascending order) from unsorted part and putting it at the beginning. The algorithm maintains two subarrays in a given array. \n1) The subarray which is already sorted. \n2) Remaining subarray which is unsorted.\nIn every iteration of selection sort, the minimum element (considering ascending order) from the unsorted subarray is picked and moved to the sorted subarray. ';
                    currentSortingBestTimeComplexity = 'Θ(n^2)';
                    currentSortingWorstTimeComplexity = 'Θ(n^2)';
                    currentSortingAvgTimeComplexity = 'Θ(n^2)';
                    currentSortingSpaceComplexity = 'Θ(1)';
                    currentSortingCode = 'assets/images/selectionsort.png';
                    break;

                  case '3':
                    currentSortingTitle = 'Insertion Sort';
                    currentSortingDef =
                        'Insertion sort is a simple sorting algorithm that works similar to the way you sort playing cards in your hands. The array is virtually split into a sorted and an unsorted part. Values from the unsorted part are picked and placed at the correct position in the sorted part.';
                    currentSortingBestTimeComplexity = 'Θ(n)';
                    currentSortingWorstTimeComplexity = 'Θ(n^2)';
                    currentSortingAvgTimeComplexity = 'Θ(n^2)';
                    currentSortingSpaceComplexity = 'Θ(1)';
                    currentSortingCode = 'assets/images/insertionsort.png';
                    break;

                  case '4':
                    currentSortingTitle = 'Shell Sort';
                    currentSortingDef =
                        'Shell Sort is mainly a variation of Insertion Sort. In insertion sort, we move elements only one position ahead. When an element has to be moved far ahead, many movements are involved. The idea of shellSort is to allow exchange of far items. In shellSort, we make the array h-sorted for a large value of h. We keep reducing the value of h until it becomes 1. An array is said to be h-sorted if all sublists of every h’th element is sorted.';
                    currentSortingBestTimeComplexity = 'Θ(nlgon)';
                    currentSortingWorstTimeComplexity = 'Θ(n^2)';
                    currentSortingAvgTimeComplexity = 'Θ(nlgon)';
                    currentSortingSpaceComplexity = 'Θ(1)';
                    currentSortingCode = 'assets/images/shellsort.png';
                    break;

                  case '5':
                    currentSortingTitle = 'Odd-Even Sort';
                    currentSortingDef =
                        'This is basically a variation of bubble-sort. This algorithm is divided into two phases- Odd and Even Phase. The algorithm runs until the array elements are sorted and in each iteration two phases occurs- Odd and Even Phases.\nIn the odd phase, we perform a bubble sort on odd indexed elements and in the even phase, we perform a bubble sort on even indexed elements.';
                    currentSortingBestTimeComplexity = 'Θ(n)';
                    currentSortingWorstTimeComplexity = 'Θ(n^2)';
                    currentSortingAvgTimeComplexity = 'Θ(n^2)';
                    currentSortingSpaceComplexity = 'Θ(1)';
                    currentSortingCode = 'assets/images/oddevensort.png';
                    break;
                }
              });
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          final now = DateTime.now();
          final maxDuration = Duration(milliseconds: 2000);
          final isWarning =
              lastPressed == null || now.difference(lastPressed!) > maxDuration;
          if (isWarning) {
            lastPressed = DateTime.now();
            final snackBar = SnackBar(
              content: const Text('Press back again to exit SortItOut app.'),
              duration: maxDuration,
            );
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(snackBar);
            return false;
          } else {
            return true;
          }
        },
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFF28313B),
                    Color(0xFF000000),
                  ],
                ),
              ),
            ),
            Row(
              children: numbers.map((int number) {
                counter++;
                return CustomPaint(
                  painter: BarPainter(
                    width: MediaQuery.of(context).size.width / sampleSize * 2,
                    value: number,
                    index: counter,
                    barColor: preColor,
                  ),
                );
              }).toList(),
            ),
            DraggableScrollableSheet(
              initialChildSize: .21,
              minChildSize: .2,
              maxChildSize: 1,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF0E1419),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF25353F),
                        offset: Offset(5.0, 5.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      )
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width / 33),
                        child: const RotatedBox(
                          quarterTurns: 1,
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Color(0xFFCDD1CC),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.timer,
                            color: Color(0xFFCDD1CC),
                          ),
                          SliderTheme(
                            data: const SliderThemeData(
                              thumbColor: Color(0xFFCDD1CC),
                              activeTrackColor: Color(0xFFCDD1CC),
                              inactiveTrackColor: Color(0xFF8C8C94),
                              valueIndicatorColor: Color(0xFF8C8C94),
                              disabledActiveTrackColor: Color(0xFFCDD1CC),
                              disabledInactiveTrackColor: Color(0xFF8C8C94),
                              disabledThumbColor: Color(0xFFCDD1CC),
                              activeTickMarkColor: Colors.transparent,
                              inactiveTickMarkColor: Colors.transparent,
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: Slider(
                                value: initialDuration.toDouble(),
                                min: minDuration,
                                max: maxDuration,
                                divisions: divisionDuration,
                                label: initialDuration.round().toString() + 'x',
                                onChanged: isSorting
                                    ? null
                                    : (double value) {
                                        setState(
                                          () {
                                            initialDuration = value.round();
                                            if (initialDuration == 1) {
                                              currentDuration = 9000;
                                            } else if (initialDuration == 2) {
                                              currentDuration = 6000;
                                            } else if (initialDuration == 3) {
                                              currentDuration = 3000;
                                            } else if (initialDuration == 4) {
                                              currentDuration = 1000;
                                            } else if (initialDuration == 5) {
                                              currentDuration = 300;
                                            }
                                          },
                                        );
                                      },
                                // semanticFormatterCallback: (double newValue) {
                                //   return "${newValue.round()} dollars";
                                // },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: isSorting ? null : randomize,
                                  child: const Icon(
                                    Icons.refresh_outlined,
                                    size: 30,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFF2196F3),
                                    onSurface: const Color(0xFF2196F3),
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(10),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: isSorting ? null : sortItOut,
                                  child: Icon(
                                    isSorting ? Icons.pause : Icons.play_arrow,
                                    size: 30,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFF0AB377),
                                    onSurface: const Color(0xFFFF473C),
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Text(
                              currentSortingTitle,
                              style: const TextStyle(
                                color: Color(0xFF02B075),
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Roboto',
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Text(
                              currentSortingDef,
                              style: const TextStyle(
                                color: Color(0xFFCDD1CC),
                                fontSize: 15,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Time Complexity:',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color:
                                                Colors.white.withOpacity(0.75),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Best Case: ',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                              ),
                                            ),
                                            Text(
                                              currentSortingBestTimeComplexity,
                                              style: const TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Worst Case: ',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                              ),
                                            ),
                                            Text(
                                              currentSortingWorstTimeComplexity,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Average Case: ',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                              ),
                                            ),
                                            Text(
                                              currentSortingAvgTimeComplexity,
                                              style: const TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 135,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Space Complexity:',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color:
                                                Colors.white.withOpacity(0.75),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Worst Case: ',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.white
                                                    .withOpacity(0.9),
                                              ),
                                            ),
                                            Text(
                                              currentSortingSpaceComplexity,
                                              style: const TextStyle(
                                                fontFamily: 'Roboto',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Image(
                              image: AssetImage(currentSortingCode),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Made with ',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Color(0xFFCDD1CC),
                                    fontSize: 12,
                                  ),
                                ),
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const Text(
                                  ' By',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    color: Color(0xFFCDD1CC),
                                    fontSize: 12,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => launch(
                                      'https://www.instagram.com/jaiswal4sudeep/'),
                                  child: const Text(
                                    ' SuDeep Jaiswal',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Color(0xFFCDD1CC),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BarPainter extends CustomPainter {
  final double width;
  final int value;
  final int index;
  final Color barColor;
  BarPainter(
      {required this.width,
      required this.value,
      required this.index,
      required this.barColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = barColor;
    paint.strokeWidth = width;
    paint.strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(index * width, 0),
        Offset(index * width, value.ceilToDouble() * 5), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
