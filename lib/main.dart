import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon_app/pokemon_detail.dart';
import 'package:pokemon_app/pokemons.dart';
import 'home_screen.dart';
import 'dart:convert';
import 'pokemon_detail.dart';

void main(){
  runApp(MaterialApp(
    title: "Pokemon App",
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget{
  @override
  HomePageState createState(){
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage>{

  var url = "https://pokeapi.co/api/v2/pokemon";

  @override
   initState()  {
    super.initState();
  fetchData();
  }

  PokeHub? pokeHub = null;

  fetchData() async{
    final uri = Uri.parse(url);
    var res = await http.get(uri);
    var decodedJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodedJson);
    setState(() {
      print('setState 1');
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokemon App"),
        backgroundColor: Colors.cyan,
      ),
      body: pokeHub == null
          ? Center(
        child: CircularProgressIndicator(),
      ): GridView.count(
        crossAxisCount: 2,
        children: pokeHub != null
            ? pokeHub!.pokemons!.indexed.map((poke)=>Padding(
            padding: const EdgeInsets.all(2.0),
            child: InkWell(
              onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>PokeDetail(pokemon: poke.,)));
              },
                child: Hero(
                  tag: Image.network('https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${poke.$1 + 1}.png'),
                 child: Card(
              elevation: 3.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                  child: Image.network('https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${poke.$1 + 1}.png'),
              ),
                  Text(poke.$2.name ?? 'emptyName',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ))
                ],
              )
            ))))).toList()
            : [],
      ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.cyan,
        child: Icon(Icons.refresh),
      ),
    );
  }
}