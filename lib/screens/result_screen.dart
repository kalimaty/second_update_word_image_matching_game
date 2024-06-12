 

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          final totalAttempts =
              gameState.correctAnswers + gameState.wrongAttempts;
          final percentage = totalAttempts > 0
              ? (gameState.correctAnswers / totalAttempts) * 100
              : 0;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Summary',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    DataTable(
                      columnSpacing: 20,
                      headingRowHeight: 60,
                      dataRowHeight: 60,
                      border: TableBorder.all(color: Colors.green, width: 2),
                      columns: [
                        DataColumn(
                          label: Text(
                            'Metric',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Value',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text(
                            'Correct Answers',
                            style: TextStyle(fontSize: 16),
                          )),
                          DataCell(Text(
                            '${gameState.correctAnswers}',
                            style: TextStyle(fontSize: 16),
                          )),
                        ]),
                        DataRow(cells: [
                          DataCell(Text(
                            'Wrong Attempts',
                            style: TextStyle(fontSize: 16),
                          )),
                          DataCell(Text(
                            '${gameState.wrongAttempts}',
                            style: TextStyle(fontSize: 16),
                          )),
                        ]),
                        DataRow(cells: [
                          DataCell(Text(
                            'Percentage',
                            style: TextStyle(fontSize: 20),
                          )),
                          DataCell(Text(
                            '${percentage.toStringAsFixed(2)}%',
                            style: TextStyle(fontSize: 20),
                          )),
                        ]),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Detailed Results',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    DataTable(
                      columnSpacing: 20,
                      headingRowHeight: 60,
                      dataRowHeight: 60,
                      border: TableBorder.all(color: Colors.blue, width: 2),
                      columns: [
                        DataColumn(
                          label: Text(
                            'Word',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Result',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      rows: gameState.answers.map((answer) {
                        return DataRow(
                          cells: [
                            DataCell(Text(
                              answer['word'],
                              style: TextStyle(fontSize: 20),
                            )),
                            DataCell(
                              Text(
                                answer['isCorrect'] ? 'Correct' : 'Wrong',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: answer['isCorrect']
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: () {
                        context.read<GameState>().resetGame();
                        Navigator.of(context)
                            .pushReplacementNamed('/questions');
                      },
                      child: Text(
                        'Restart',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
