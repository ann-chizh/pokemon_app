import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pokemon_detail.dart';
import 'pokemons.dart';

void main() {
  runApp(MaterialApp(
    title: "Pokemon App",
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  var url = "https://pokeapi.co/api/v2/pokemon";
  int _currentPage = 1;
  bool _isLoading = false;
  List<Pokemon> _pokemonList = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(_onScroll);
  }

  _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchData();
    }
  }

  _fetchData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final uri = Uri.parse(url + "?offset=${(_currentPage - 1) * 20}&limit=20");
    var res = await http.get(uri);
    var decodedJson = jsonDecode(res.body);

    setState(() {
      _pokemonList.addAll(List<Pokemon>.from(decodedJson['results'].map((x) => Pokemon.fromJson(x))));
      _currentPage++;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokemon App"),
        backgroundColor: Colors.cyan,
      ),
      body: _pokemonList.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : GridView.count(
        controller: _scrollController,
        crossAxisCount: 2,
        children: _pokemonList.indexed
            .map((entry) => Padding(
            padding: const EdgeInsets.all(2.0),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PokeDetail(
                            pokemon: entry.$2,
                          )));
                },
                child: Hero(
                    tag: Image.network(
                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${entry.$1 + 1}.png'),
                    child: Card(
                        elevation: 3.0,
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${entry.$1 + 1}.png'),
                            ),
                            Text(entry.$2.name ?? 'emptyName',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ))
                          ],
                        ))))))
            .toList(),
      ),
      drawer: Drawer(),
    );
  }
}
