import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pokemons.dart';

class PokemonDetailBloc {
  final StreamController<Pokemon> _pokemonStreamController = StreamController<Pokemon>.broadcast();
  Stream<Pokemon> get pokemonStream => _pokemonStreamController.stream;

  void dispose() {
    _pokemonStreamController.close();
  }

  Future<void> fetchPokemonDetails(Pokemon pokemon) async {
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

      _pokemonStreamController.sink.add(pokemon);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
