import 'package:flutter/material.dart';
import 'pokemons.dart';
import 'main.dart';
class PokeDetail extends StatelessWidget {


  final Pokemon pokemon;
  PokeDetail({required this.pokemon});

  bodyWidget()=>Stack(
    children: [
      Container(
        child: Card(
          child: Column(
            children: [
              Text(pokemon.name.toString()),
             Text("Height:"),
              Text("Weight: "),
              Text("Types"),
             Row(
               children: [

               ],
             )
            ],
          ),
        ),
      )
    ],
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(pokemon.name.toString()),
        backgroundColor: Colors.cyan,
      ),

      body: bodyWidget(),
    );
  }
}
