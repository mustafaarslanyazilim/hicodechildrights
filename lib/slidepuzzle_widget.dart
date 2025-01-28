import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hicodechildrights/color.dart';
import 'package:image/image.dart' as image;

class SlidePuzzleWidget extends StatefulWidget {
  final Size size;
  final double innerPadding;
  final Image imageBckGround;

  const SlidePuzzleWidget({
    super.key,
    required this.size,
    this.innerPadding = 5,
    required this.imageBckGround,
  });

  @override
  State<SlidePuzzleWidget> createState() => _SlidePuzzleWidgetState();
}

class _SlidePuzzleWidgetState extends State<SlidePuzzleWidget> {
  final GlobalKey _globalKey = GlobalKey();
  late Size size;
  late List<SlideObject> slideObjects;
  late image.Image fullImage;
  bool success = false;

  @override
  void initState() {
    super.initState();
    slideObjects = [];
  }

  @override
  Widget build(BuildContext context) {
    size = Size(
      widget.size.width - widget.innerPadding * 2,
      widget.size.height - widget.innerPadding * 2,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Single RepaintBoundary widget, to avoid multiple nested boundaries
        RepaintBoundary(
          key: _globalKey,
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            width: widget.size.width,
            height: widget.size.width,
            padding: EdgeInsets.all(widget.innerPadding),
            child: Stack(
              children: [
                // Display image background only when necessary
                if (slideObjects.isEmpty)
                  Positioned.fill(
                    child: widget.imageBckGround,
                  ),
                //2nd show puzzle with empty
                if (slideObjects.isNotEmpty)
                  ...slideObjects
                      .where((slideObject) => slideObject.empty == false)
                      .map(
                    (slideObject) {
                      return Positioned(
                          left: slideObject.posCurrent.dx,
                          top: slideObject.posCurrent.dy,
                          child: SizedBox(
                            width: slideObject.size.width,
                            height: slideObject.size.height,
                            child: Container(
                              color: Colors.yellow,
                            ),
                          ));
                    },
                  ).toList(),
                //this for box with not empty
                if (slideObjects.isNotEmpty)
                  ...slideObjects
                      .where((slideObject) => slideObject.empty == false)
                      .map(
                    (slideObject) {
                      return Positioned(
                          left: slideObject.posCurrent.dx,
                          top: slideObject.posCurrent.dy,
                          child: SizedBox(
                            width: slideObject.size.width,
                            height: slideObject.size.height,
                            child: Container(
                              color: Colors.blue,
                            ),
                          ));
                    },
                  ).toList(),
                //now not show at all because dont generate slidedobjected yet
              ],
            ),
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () => generatePuzzle(), child: Text("Oluştur")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: () {}, child: Text("Geri Al")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: () {}, child: Text("Temizle")),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Resmi almak için post-frame callback ekliyoruz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePuzzle();
    });
  }

  // Puzzle'ı başlatmak için görüntü yükleme işlemi
  Future<void> _initializePuzzle() async {
    // Render işleminin tamamlanmasını bekleyin
    await Future.delayed(
        Duration(milliseconds: 50)); // Kısa bir bekleme süresi ekleyin

    final img = await _getImageFromWidget();
    if (img != null) {
      fullImage = img;
      // Puzzle oluşturulabilir, burada işlem yapılabilir
    }
  }

  // Widget'tan görüntü alma işlemi
  Future<image.Image?> _getImageFromWidget() async {
    if (_globalKey.currentContext == null) {
      throw Exception("GlobalKey'in BuildContext'i null.");
    }

    final RenderRepaintBoundary? boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      throw Exception("RenderRepaintBoundary bulunamadı.");
    }

    // Görüntü alınmadan önce render edilmesini bekle
    if (boundary.debugNeedsPaint) {
      await Future.delayed(Duration(
          milliseconds: 100)); // Render işlemi tamamlanana kadar bekleyin
    }

    final img = await boundary.toImage();
    final byteData = await img.toByteData(format: ImageByteFormat.png);
    if (byteData == null) {
      throw Exception("ByteData null döndü.");
    }

    final pngBytes = byteData.buffer.asUint8List();
    return image.decodeImage(pngBytes);
  }

  // Puzzle'ı oluşturmak için kullanılacak metot
  void generatePuzzle() {
    // Puzzle oluşturulacak fonksiyonu burada yazabilirsiniz
  }
}

class SlideObject {
  final Offset posDefault;
  Offset posCurrent;
  final int indexDefault;
  int indexCurrent;
  final bool empty;
  final Size size;
  final Image image;

  SlideObject({
    this.empty = false,
    required this.image,
    required this.indexCurrent,
    required this.indexDefault,
    required this.posCurrent,
    required this.posDefault,
    required this.size,
  });
}
