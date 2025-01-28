import 'package:flutter/material.dart';
import 'package:hicodechildrights/color.dart';
import 'package:hicodechildrights/slidepuzzle_widget.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({super.key});

  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  // Default value for the slider
  int valueSlider = 2;
  double border = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Slide Puzzle ${valueSlider}x${valueSlider}"),
        foregroundColor: Colors.white,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SafeArea(
          child: Column(
            children: [
              // Puzzle area
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.purple,
                    border: Border.all(width: border, color: Colors.black),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Center(
                        child: Container(
                          //  width: size,
                          // height: size,
                          child: SlidePuzzleWidget(
                            size: constraints.biggest,
                            imageBckGround: Image(
                                image: AssetImage('lib/images/puzzle.png')),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Slider area
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Slider(
                  min: 2,
                  max: 15,
                  divisions: 13,
                  label: "${valueSlider.toString()}",
                  value: valueSlider.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      valueSlider = value.toInt();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
