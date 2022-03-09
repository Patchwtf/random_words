import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Se crea una variable para almacenar el par de palabras
    final palabras = WordPair.random();
    return MaterialApp(home: RandomWords());
  }
} //Crearemos un widget

class RandomWords extends StatefulWidget {
  RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _sugerencias = <WordPair>[];
  final salvadas = <WordPair>{};
  final letraGrande = TextStyle(fontSize: 18);

  Widget crearFilas(WordPair par) {
    final yasalvadas = salvadas.contains(par);
    return ListTile(
      title: Text(
        par.asPascalCase,
        style: letraGrande,
      ),
      trailing: Icon(yasalvadas ? Icons.favorite : Icons.favorite_border,
          color: yasalvadas ? Colors.red : null),
      onTap: () =>
          setState(() => yasalvadas ? salvadas.remove(par) : salvadas.add(par)),
    );
  }

  Widget crearSugerencias() {
    return ListView.builder(
        padding: EdgeInsets.all(15),
        itemBuilder: (context, i) {
          //Si es impar coloca division (linea)
          if (i.isOdd) {
            return Divider();
          }
          //Si llego a final, creo otros 10
          final index = i;
          if (index >= _sugerencias.length) {
            _sugerencias.addAll(generateWordPairs().take(10));
          }
          //si es par
          return crearFilas(_sugerencias[index]);
        });
  }

  void pantallaSalvados() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      final filas = salvadas.map((par) {
        return ListTile(
          title: Text(
            par.asPascalCase,
            style: letraGrande,
          ),
        );
      });
      final divide = filas.isNotEmpty
          ? ListTile.divideTiles(
              context: context,
              tiles: filas,
            ).toList()
          : <Widget>[];
      return Scaffold(
        appBar: AppBar(title: Text('Lista Favs')),
        body: ListView(children: divide),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: pantallaSalvados,
            icon: Icon(
              Icons.list,
            ),
          )
        ],
        title: Text("Name Generator",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
        backgroundColor: Color.fromARGB(255, 0, 255, 76),
      ),
      body: crearSugerencias(),
    );
  }
}
