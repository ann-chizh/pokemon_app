import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pokemons.dart';

class PokemonBloc {
  final StreamController<List<Pokemon>> _pokemonStreamController = StreamController<List<Pokemon>>.broadcast();
  Stream<List<Pokemon>> get pokemonStream => _pokemonStreamController.stream;

  int _currentPage = 1;
  bool _isLoading = false;
  List<Pokemon> _pokemonList = [];
  final String _baseUrl = "https://pokeapi.co/api/v2/pokemon";

  void fetchPokemonList() async {
    if (_isLoading) return;

    _isLoading = true;

    final uri = Uri.parse("$_baseUrl?offset=${(_currentPage - 1) * 20}&limit=20");
    var res = await http.get(uri);
    var decodedJson = jsonDecode(res.body);

    List<Pokemon> newPokemonList = List<Pokemon>.from(decodedJson['results'].map((x) => Pokemon.fromJson(x)));
    _pokemonList.addAll(newPokemonList);
    _currentPage++;

    _pokemonStreamController.sink.add(_pokemonList);
    _isLoading = false;
  }

  void dispose() {
    _pokemonStreamController.close();
  }
}
