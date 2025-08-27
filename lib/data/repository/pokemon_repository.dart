
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_app/data/model/pokemon_model.dart';

class PokemonRepository {
  Future<List<PokemonModel>> getPokemons({int limit = 20}) async {

    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$limit'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List result = data['results'];

      List<PokemonModel> loadedPokemon = [];
      for (int i = 0; i < result.length; i++) {
        final name = result[i]['name'];
        final id = i + 1;
        final imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

        loadedPokemon.add(
          PokemonModel(
            name: name,
            imageUrl: imageUrl,
          ),
        );
      }

      return loadedPokemon;
    } else {
      throw Exception('Error al cargar los Pokemones');
    }
  }
}