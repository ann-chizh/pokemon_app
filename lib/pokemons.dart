import 'package:flutter/foundation.dart';

class Pokemons {
  final String name;
  final String url;

  Pokemons({required this.name, required this.url});

  factory Pokemons.fromJson(Map<String, dynamic> json) {
    return Pokemons(
      name: json['name'],
      url: json['url'],
    );
  }
}

class PokeHub {
  int? count;
  String? next;
  Null? previous;
  List<Results>? results;



  PokeHub({this.count, this.next, this.previous, this.results});

  PokeHub.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
  }

 // List<Pokemons> get pokemonsList => pokemons;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String? name;
  String? url;

  Results({this.name, this.url});

  Results.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}