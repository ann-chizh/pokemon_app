import 'package:flutter/material.dart';
import 'pokemons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'pokemon_detail_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:connectivity/connectivity.dart';

class PokeDetail extends StatefulWidget {
  final Pokemon pokemon;
  final PokemonDetailBloc pokemonDetailBloc;
  //final PokemonDetailBloc pokemonDetailBloc;
  PokeDetail({required this.pokemon, required this.pokemonDetailBloc});

  @override
  _PokeDetailState createState() => _PokeDetailState();
}

class _PokeDetailState extends State<PokeDetail> {
  late final PokemonDetailBloc _pokemonDetailBloc;
  @override
  void initState() {
    super.initState();
    _pokemonDetailBloc = PokemonDetailBloc(); // Создаем новый экземпляр PokemonDetailBloc
    _pokemonDetailBloc.fetchPokemonDetails(widget.pokemon.id!);
   /* if (widget.pokemon.id != null) {
      widget.pokemonDetailBloc.fetchPokemonDetails(widget.pokemon.id!);
    } else {
      print('error');
    }*/
  }

  @override
  void dispose() {
    _pokemonDetailBloc.dispose();
    super.dispose();
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.cyan,
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
                  SizedBox(height: 20),
                  StreamBuilder<Pokemon>(
                    stream: _pokemonDetailBloc.pokemonStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final pokemon = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    pokemon.name!,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
                                  _buildInfoRow('Height:', pokemon.height.toString()),
                                  _buildInfoRow('Weight:', pokemon.weight.toString()),
                                  _buildInfoRow('Types:', pokemon.types != null ? pokemon.types!.join(", ") : ""),
                                ],
                              ),
                            ),
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
      ),
    );
  }
}
