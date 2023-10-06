import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController totalPalitosController = TextEditingController();
  TextEditingController limitePalitosController = TextEditingController();
  TextEditingController moveController =
      TextEditingController(); // Novo controller para a jogada do usuário
  int numberOfPieces = 0;
  int limit = 0;
  bool computerPlay = false;
  List<String> moveHistory = [];

  @override
  void initState() {
    super.initState();
  }

  void startGame() {
    numberOfPieces = int.tryParse(totalPalitosController.text) ?? 0;
    limit = int.tryParse(limitePalitosController.text) ?? 0;

    if (numberOfPieces < 2) {
      showMessage('Campo inválido',
          'Quantidade de palitos inválida! Informe um valor maior ou igual a 2.');
      return;
    }

    if (limit <= 0 || limit >= numberOfPieces) {
      showMessage('Campo inválido',
          'Limite de palitos inválido! Informe um valor maior que zero e menor que o total de palitos.');
      return;
    }

    setState(() {
      computerPlay = (numberOfPieces % (limit + 1)) == 0;
    });

    if (!computerPlay) {
      userPlay();
    } else {
      computerMove();
    }
  }

  void userPlay() {
    setState(() {
      moveHistory.add("\nSua vez.\nQuantos palitos você vai tirar?\n");
    });
  }

  void updateGame(int move) {
    setState(() {
      numberOfPieces -= move;
      moveHistory
          .add("Você tirou $move palito(s). Restam $numberOfPieces palitos.");
      if (numberOfPieces == 1) {
        endGame();
      } else {
        computerPlay = !computerPlay;
        if (computerPlay) {
          computerMove();
        } else {
          userPlay();
        }
      }
    });
  }

  void computerMove() {
    int computerMove = computerChoosesMove(numberOfPieces, limit);
    setState(() {
      numberOfPieces -= computerMove;
      moveHistory.add(
          "O computador tirou $computerMove palito(s). Restam $numberOfPieces palitos.");

      // Voltar para dentro do else
      computerPlay = !computerPlay;

      if (numberOfPieces == 1) {
        endGame();
      } else {
        userPlay();
      }
    });
  }

  int computerChoosesMove(int numberOfPieces, int limit) {
    int remainder = numberOfPieces % (limit + 1);
    // int move = (remainder == 0) ? 1 : remainder;
    if (remainder == 0) {
      return limit;
    } else {
      return (remainder - 1) == 0 ? limit : (remainder - 1);
    }
    // return move;
  }

  void showMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void endGame() {
    // moveHistory.add("\n\nSobraram $numberOfPieces peças e a o computador joga? $computerPlay\n\n");
    String result = computerPlay ? "Você ganhou!" : "O computador ganhou!";
    showMessage('Fim de jogo', result);
  }

  void restartGame() {
    setState(() {
      numberOfPieces = 0;
      limit = 0;
      moveHistory.clear();
    });
  }

  void processUserMove() {
    int move = int.tryParse(moveController.text) ?? 0;
    if (move < 1 || move > limit) {
      showMessage(
          'Jogada inválida', 'Lembre-se de inserir um número entre 1 e $limit');
    } else {
      updateGame(move);
      setState(() {
        moveController.text = ""; // Limpa o campo de entrada
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Row(children: [
            Text('Jogo NIM', style: TextStyle(color: Colors.white)),
            Expanded(
              child: SizedBox(),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(
                'Isabelle Vicente Oliveira',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'RA: 1431432312016',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ]),
          ]),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: restartGame,
                    child: Text(
                      'Jogar de Novo',
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: totalPalitosController,
                  decoration: InputDecoration(labelText: 'Total de palitos?'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: limitePalitosController,
                  decoration: InputDecoration(labelText: 'Limite de palitos?'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: startGame,
                      child: Text('Começar o jogo'),
                    ),
                  ),
                ]),
                SizedBox(height: 20),
                TextField(
                  controller: moveController,
                  decoration: InputDecoration(labelText: 'Sua jogada'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: processUserMove,
                    child: Text('Jogar'),
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 400,
                      // decoration: BoxDecoration(
                      //   // border: Border.all(color: Colors.grey),
                      //   borderRadius: BorderRadius.circular(10),
                      // ),
                      child: ListView.builder(
                        itemCount: moveHistory.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              moveHistory[index],
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )));
  }
}
