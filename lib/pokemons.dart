import 'package:flutter/foundation.dart';

/*class Pokemon {
  final String name;
  final String url;

  Pokemon({required this.name, required this.url});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      url: json['url'],
    );
  }
}*/

class Pokemon {
  String? name;
  String? url;
  int? height; // Добавляем поле для хранения роста
  int? weight;
  List<String>? types;
  Pokemon({this.name, this.url, this.height, this.weight, this.types});

  Pokemon.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

class PokeHub {
  int? count;
  String? next;
  Null? previous;
  List<Pokemon>? pokemons;



  PokeHub({this.count, this.next, this.previous, this.pokemons});

  PokeHub.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      pokemons = <Pokemon>[];
      json['results'].forEach((v) {
        pokemons!.add(new Pokemon.fromJson(v));
      });
    }
  }

 // List<Pokemons> get pokemonsList => pokemons;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.pokemons != null) {
      data['results'] = this.pokemons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

