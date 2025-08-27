import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokemon_app/data/model/pokemon_model.dart';

class PokemonRepositoryProvider {
  Future<List<PokemonModel>> getPokemons({String cantidad = '30'}) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$cantidad'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List result = data['results'];

      List<PokemonModel> loadedPokemon = [];
      for (int i = 0; i < result.length; i++) {
        final name = result[i]['name'];
        // The pokemon ID can be extracted from the URL for more robustness
        final urlParts = result[i]['url'].split('/');
        final id = urlParts[urlParts.length - 2];
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
