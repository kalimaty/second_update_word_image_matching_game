import 'package:flutter/material.dart';

class OptionsDialogWidget extends StatelessWidget {
  final List<String> wordOptions;
  final bool showDialog;
  final bool hideDialog;
  final bool canInteract;
  final String? selectedWord;
  final String correctWord;
  final Function(String) handleSelection;

  const OptionsDialogWidget({
    required this.wordOptions,
    required this.showDialog,
    required this.hideDialog,
    required this.canInteract,
    required this.selectedWord,
    required this.correctWord,
    required this.handleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      top: hideDialog ? 600 : (showDialog ? 250 : 600),
      left: 20,
      right: 20,
      child: showDialog
          ? Container(
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                border: Border.all(width: 6, color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.maxFinite,
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: wordOptions.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: canInteract
                          ? () => handleSelection(wordOptions[index])
                          : null,
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              border: Border.all(width: 5, color: Colors.white),
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                                child: Text(
                              wordOptions[index],
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                          if (selectedWord != null)
                            if (wordOptions[index] == correctWord &&
                                wordOptions[index] == selectedWord)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.green,
                                    size: 25,
                                  ),
                                ),
                              )
                            else if (wordOptions[index] != correctWord &&
                                wordOptions[index] == selectedWord)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
