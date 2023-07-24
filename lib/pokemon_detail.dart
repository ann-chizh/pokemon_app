import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'pokemons.dart';
import 'main.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokeDetail extends StatefulWidget {
  final Pokemon pokemon;

  PokeDetail({required this.pokemon});

  @override
  _PokeDetailState createState() => _PokeDetailState();
}

class _PokeDetailState extends State<PokeDetail> {
  late Future<Pokemon> futurePokemon;

  @override
  void initState() {
    super.initState();
    futurePokemon = fetchPokemonDetails(widget.pokemon);
  }

  Future<Pokemon> fetchPokemonDetails(Pokemon pokemon) async {
    final response = await http.get(Uri.parse(pokemon.url!));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      pokemon.height = jsonResponse['height'];
      pokemon.weight = jsonResponse['weight'];

      if (jsonResponse['types'] != null) {
        pokemon.types = List<String>.from(jsonResponse['types'].map((type) => type['type']['name'].toString()));
      } else {
        pokemon.types = [];
      }

      return pokemon;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl:
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.pokemon.url!.split("/").reversed.toList()[1]}.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                FutureBuilder<Pokemon>(
                  future: futurePokemon,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              widget.pokemon.name!,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Height: ${snapshot.data!.height}",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Weight: ${snapshot.data!.weight}",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "Types: ${snapshot.data!.types != null ? snapshot.data!.types!.join(", ") : ""}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
