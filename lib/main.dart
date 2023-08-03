import 'package:flutter/material.dart';
import 'pokemon_detail.dart';
import 'pokemons.dart';
import 'pokemon_detail_bloc.dart';
import 'pokemon_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<PokemonDetailBloc>(create: (context) => PokemonDetailBloc()),
      ],
      child: MaterialApp(
        title: "Pokemon App",
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

/*void main() {
  runApp(MaterialApp(
    title: "Pokemon App",
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}*/

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  PokemonBloc _pokemonBloc = PokemonBloc();
  Map<int, PokemonDetailBloc?> _pokemonDetailBlocs = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _pokemonBloc.fetchPokemonList();
    _scrollController.addListener(_onScroll);
  }

  _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _pokemonBloc.fetchPokemonList();
    }
  }

  @override
  void dispose() {
    _pokemonBloc.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokemon App"),
        backgroundColor: Colors.cyan,
      ),
      body: StreamBuilder<List<Pokemon>>(
    stream: _pokemonBloc.pokemonStream,
      builder: (context, snapshot){
        if (snapshot.hasData) {
          List<Pokemon> pokemonList = snapshot.data!;
          return GridView.count(
            controller: _scrollController,
            crossAxisCount: 2,
            children: pokemonList
                .map(
                  (pokemon) => Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  onTap: () {
                    if (!_pokemonDetailBlocs.containsKey(pokemon.id)) {
                      _pokemonDetailBlocs[pokemon.id!] = PokemonDetailBloc();
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokeDetail(
                          pokemon: pokemon,
                          pokemonDetailBloc: _pokemonDetailBlocs[pokemon.id]!,
                        ),
                      ),
                    );
                  },
                  child: Hero(
                    tag: Image.network(
                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${pokemon.id}.png',
                    ),
                    child: Card(
                      elevation: 3.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.network(
                              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${pokemon.id}.png',
                            ),
                          ),
                          Text(
                            pokemon.name ?? 'emptyName',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
                .toList(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        return Center(child: CircularProgressIndicator());
      },
      ),
    );
  }
}