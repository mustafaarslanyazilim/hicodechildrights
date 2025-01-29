import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hicodechildrights/color.dart';
import 'package:hicodechildrights/puzzlesuccess_page.dart';
import 'package:image/image.dart' as image;

class SlidePuzzle extends StatefulWidget {
  SlidePuzzle({Key? key}) : super(key: key);

  @override
  _SlidePuzzleState createState() => _SlidePuzzleState();
}

class _SlidePuzzleState extends State<SlidePuzzle> {
  int valueSlider = 2;
  GlobalKey<_SlidePuzzleWidgetState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double border = 5;

    return Scaffold(
      extendBodyBehindAppBar: true,
      /*
      appBar: AppBar(
        title: const Text('Giriş Yap'),
        foregroundColor: Colors.white,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient,
          ),
        ),
      ),
       */
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Slide Puzzle ${valueSlider}x$valueSlider",
        ),
        foregroundColor: Colors.white,
        actions: [
          InkWell(
            child: Icon(Icons.refresh),
            onTap: () => globalKey.currentState?.generatePuzzle(),
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient,
          ),
        ),
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            // Stack widget'ı ile ekleme yapıyoruz
            children: [
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(width: border, color: AppColors.color2),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          width: constraints.biggest.width,
                          child: SlidePuzzleWidget(
                            key: globalKey,
                            size: constraints.biggest,
                            sizePuzzle: valueSlider,
                            imageBckGround: Image(
                              image: AssetImage("lib/images/puzzle.png"),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    child: Slider(
                      min: 2,
                      max: 15,
                      divisions: 13,
                      activeColor: AppColors.purple,
                      label: "${valueSlider.toString()}",
                      value: valueSlider.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          valueSlider = value.toInt();
                        });
                        globalKey.currentState
                            ?.generatePuzzle(); // Puzzle'ı tekrar oluştur
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 10,
                right: 0,
                child: Image.asset(
                  'lib/images/puzzleFlamingo1.png',
                  width: 120,
                  height: 150,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SlidePuzzleWidget extends StatefulWidget {
  final Size size;
  final double innerPadding;
  final Image imageBckGround;
  final int sizePuzzle;

  SlidePuzzleWidget({
    Key? key,
    required this.size,
    this.innerPadding = 5,
    required this.imageBckGround,
    required this.sizePuzzle,
  }) : super(key: key);

  @override
  _SlidePuzzleWidgetState createState() => _SlidePuzzleWidgetState();
}

class _SlidePuzzleWidgetState extends State<SlidePuzzleWidget> {
  GlobalKey _globalKey = GlobalKey();
  Size? size;

  List<SlideObject>? slideObjects;
  image.Image? fullImage;
  bool success = false;
  bool startSlide = false;
  List<int>? process;
  bool finishSwap = false;

  @override
  Widget build(BuildContext context) {
    size = Size(widget.size.width - widget.innerPadding * 2,
        widget.size.width - widget.innerPadding);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(color: AppColors.color2),
          width: widget.size.width,
          height: widget.size.width,
          padding: EdgeInsets.all(widget.innerPadding),
          child: Stack(
            children: [
              if (widget.imageBckGround != null && slideObjects == null) ...[
                RepaintBoundary(
                  key: _globalKey,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    height: double.maxFinite,
                    child: widget.imageBckGround,
                  ),
                )
              ],
              if (slideObjects != null)
                ...slideObjects!.where((slideObject) => slideObject.empty).map(
                  (slideObject) {
                    return Positioned(
                      left: slideObject.posCurrent.dx,
                      top: slideObject.posCurrent.dy,
                      child: SizedBox(
                        width: slideObject.size.width,
                        height: slideObject.size.height,
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(2),
                          color: Colors.white24,
                          child: Stack(
                            children: [
                              if (slideObject.image != null)
                                Opacity(
                                  opacity: success ? 1 : 0.3,
                                  child: Image(image: slideObject.image!.image),
                                )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              if (slideObjects != null)
                ...slideObjects!.where((slideObject) => !slideObject.empty).map(
                  (slideObject) {
                    return AnimatedPositioned(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease,
                      left: slideObject.posCurrent.dx,
                      top: slideObject.posCurrent.dy,
                      child: GestureDetector(
                        onTap: () => changePos(slideObject.indexCurrent),
                        child: SizedBox(
                          width: slideObject.size.width,
                          height: slideObject.size.height,
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.all(2),
                            color: Colors.blue,
                            child: Stack(
                              children: [
                                if (slideObject.image != null)
                                  Image(image: slideObject.image!.image),
                                Center(
                                  child: Text(
                                    "${slideObject.indexDefault}",
                                    style: TextStyle(
                                      color: Color(0xff225f87),
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ).toList()
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => generatePuzzle(),
                  child: Text("Generate",
                      style: TextStyle(color: AppColors.purple)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: startSlide ? null : () => reversePuzzle(),
                  child: Text("Reverse",
                      style: TextStyle(color: AppColors.purple)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => clearPuzzle(),
                  child:
                      Text("Clear", style: TextStyle(color: AppColors.purple)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<image.Image> _getImageFromWidget() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    size = boundary.size;
    var img = await boundary.toImage();
    var byteData = await img.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData!.buffer.asUint8List();

    return image.decodeImage(pngBytes)!;
  }

  generatePuzzle() async {
    finishSwap = false;
    setState(() {});

    if (widget.imageBckGround != null && this.fullImage == null)
      this.fullImage = await _getImageFromWidget();

    print(this.fullImage!.width);

    Size sizeBox =
        Size(size!.width / widget.sizePuzzle, size!.width / widget.sizePuzzle);

    slideObjects =
        List.generate(widget.sizePuzzle * widget.sizePuzzle, (index) {
      Offset offsetTemp = Offset(
        index % widget.sizePuzzle * sizeBox.width,
        index ~/ widget.sizePuzzle * sizeBox.height,
      );

      image.Image? tempCrop;
      if (widget.imageBckGround != null && this.fullImage != null)
        tempCrop = image.copyCrop(
          fullImage!,
          x: offsetTemp.dx.round(),
          y: offsetTemp.dy.round(),
          width: sizeBox.width.round(),
          height: sizeBox.height.round(),
        );

      return SlideObject(
        posCurrent: offsetTemp,
        posDefault: offsetTemp,
        indexCurrent: index,
        indexDefault: index + 1,
        size: sizeBox,
        image: tempCrop == null
            ? null
            : Image.memory(
                image.encodePng(tempCrop),
                fit: BoxFit.contain,
              ),
      );
    });

    slideObjects!.last.empty = true;

    bool swap = true;
    process = [];

    for (var i = 0; i < widget.sizePuzzle * 20; i++) {
      for (var j = 0; j < widget.sizePuzzle / 2; j++) {
        SlideObject slideObjectEmpty = getEmptyObject();

        int emptyIndex = slideObjectEmpty.indexCurrent;
        process!.add(emptyIndex);
        int randKey;

        if (swap) {
          int row = emptyIndex ~/ widget.sizePuzzle;
          randKey =
              row * widget.sizePuzzle + new Random().nextInt(widget.sizePuzzle);
        } else {
          int col = emptyIndex % widget.sizePuzzle;
          randKey =
              widget.sizePuzzle * new Random().nextInt(widget.sizePuzzle) + col;
        }

        changePos(randKey);
        swap = !swap;
      }
    }

    startSlide = false;
    finishSwap = true;
    setState(() {});
  }

  SlideObject getEmptyObject() {
    return slideObjects!.firstWhere((element) => element.empty);
  }

  changePos(int indexCurrent) {
    SlideObject slideObjectEmpty = getEmptyObject();

    int emptyIndex = slideObjectEmpty.indexCurrent;

    int minIndex = min(indexCurrent, emptyIndex);
    int maxIndex = max(indexCurrent, emptyIndex);

    List<SlideObject> rangeMoves = [];

    if (indexCurrent % widget.sizePuzzle == emptyIndex % widget.sizePuzzle) {
      rangeMoves = slideObjects!
          .where((element) =>
              element.indexCurrent % widget.sizePuzzle ==
              indexCurrent % widget.sizePuzzle)
          .toList();
    } else if (indexCurrent ~/ widget.sizePuzzle ==
        emptyIndex ~/ widget.sizePuzzle) {
      rangeMoves = slideObjects!;
    } else {
      rangeMoves = [];
    }

    rangeMoves = rangeMoves
        .where((puzzle) =>
            puzzle.indexCurrent >= minIndex &&
            puzzle.indexCurrent <= maxIndex &&
            puzzle.indexCurrent != emptyIndex)
        .toList();

    if (emptyIndex < indexCurrent)
      rangeMoves.sort((a, b) => a.indexCurrent < b.indexCurrent ? 1 : 0);
    else
      rangeMoves.sort((a, b) => a.indexCurrent < b.indexCurrent ? 0 : 1);

    if (rangeMoves.length > 0) {
      int tempIndex = rangeMoves[0].indexCurrent;

      Offset tempPos = rangeMoves[0].posCurrent;

      for (var i = 0; i < rangeMoves.length - 1; i++) {
        rangeMoves[i].indexCurrent = rangeMoves[i + 1].indexCurrent;
        rangeMoves[i].posCurrent = rangeMoves[i + 1].posCurrent;
      }

      rangeMoves.last.indexCurrent = slideObjectEmpty.indexCurrent;
      rangeMoves.last.posCurrent = slideObjectEmpty.posCurrent;

      slideObjectEmpty.indexCurrent = tempIndex;
      slideObjectEmpty.posCurrent = tempPos;
    }

    if (slideObjects!
                .where((slideObject) =>
                    slideObject.indexCurrent == slideObject.indexDefault - 1)
                .length ==
            slideObjects!.length &&
        finishSwap) {
      print("Success");
      success = true;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PuzzlesuccessPage()),
      );
    } else {
      success = false;
    }

    startSlide = true;
    setState(() {});
  }

  clearPuzzle() {
    setState(() {
      startSlide = true;
      slideObjects = null;
      finishSwap = true;
    });
  }

  reversePuzzle() async {
    startSlide = true;
    finishSwap = true;
    setState(() {});

    await Stream.fromIterable(process!.reversed)
        .asyncMap((event) async =>
            await Future.delayed(Duration(milliseconds: 50))
                .then((value) => changePos(event)))
        .toList();

    process = [];
    setState(() {});
  }
}

class SlideObject {
  Offset posDefault;
  Offset posCurrent;
  int indexDefault;
  int indexCurrent;
  bool empty;
  Size size;
  Image? image;

  SlideObject({
    this.empty = false,
    this.image,
    required this.indexCurrent,
    required this.indexDefault,
    required this.posCurrent,
    required this.posDefault,
    required this.size,
  });
}
