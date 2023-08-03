import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pokemons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonDetailBloc extends BlocBase<Object> {
  final StreamController<Pokemon> _pokemonStreamController = StreamController<Pokemon>.broadcast();

  PokemonDetailBloc() : super(Object());
  Stream<Pokemon> get pokemonStream => _pokemonStreamController.stream;

  void dispose() {
    _pokemonStreamController.close();
  }

  Future<void> fetchPokemonDetails(int pokemonId) async {
    final response = await http.get(Uri.parse("https://pokeapi.co/api/v2/pokemon/$pokemonId/"));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      final height = jsonResponse['height'];
      final weight = jsonResponse['weight'];
      final types = jsonResponse['types'];

      final pokemon = Pokemon.fromJson(jsonResponse);
      pokemon.height = height;
      pokemon.weight = weight;
      if (types != null && types is List) {
        pokemon.types = types.map((type) => type['type']['name'].toString()).toList();
      } else {
         pokemon.types = [];
      }

      _pokemonStreamController.sink.add(pokemon);
      savePokemonDetailsToStorage(pokemon);
    } else {
      final cachedPokemon = await getPokemonDetailsFromStorage();
      _pokemonStreamController.sink.add(cachedPokemon);
      throw Exception('Failed to load data');
    }
  }
  Future<void> savePokemonDetailsToStorage(Pokemon pokemon) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('pokemon_id', pokemon.id!);
    prefs.setInt('pokemon_height', pokemon.height!);
    prefs.setInt('pokemon_weight', pokemon.weight!);
    prefs.setStringList('pokemon_types', pokemon.types ?? []  );
  }

  // Метод для получения данных покемона из shared_preferences
  Future<Pokemon> getPokemonDetailsFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('pokemon_id');
    final height = prefs.getInt('pokemon_height');
    final weight = prefs.getInt('pokemon_weight');
    final types = prefs.getStringList('pokemon_types');

    return Pokemon(
      id: id,
      height: height,
      weight: weight,
      types: types,
    );
  }
}



