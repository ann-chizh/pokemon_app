class Pokemon {
  String? name;
  String? url;
  int? height;
  int? weight;
  List<String>? types;
  int? id;

  Pokemon({this.name, this.url, this.height, this.weight, this.types, this.id}) {
    if (url != null) {
      final uriSegments = Uri.parse(url!).pathSegments;
      id = int.parse(uriSegments[uriSegments.length - 2]);
    } else {
      id = 0;
    }
  }

  Pokemon.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
    if (url != null) {
      final uriSegments = Uri.parse(url!).pathSegments;
      id = int.parse(uriSegments[uriSegments.length - 2]);
    } else {
      id = 0;
    }
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

