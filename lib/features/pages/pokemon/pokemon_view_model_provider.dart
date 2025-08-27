import 'package:flutter/material.dart';
import 'package:pokemon_app/data/model/pokemon_model.dart';
import 'package:pokemon_app/data/repository/pokemon_repository_provider.dart';

enum PokemonStateProvider {loading, content, error}

class PokemonViewModelProvider with ChangeNotifier {
  final PokemonRepositoryProvider _pokemonRepository = PokemonRepositoryProvider();

  List<PokemonModel> _pokemonList = [];
  List<PokemonModel> get pokemonList => _pokemonList;

  PokemonStateProvider state = PokemonStateProvider.loading;

  Future<void> loadPokemons({String cantidad = '30'}) async {
    try {
      showLoading();
      final pokemons = await _pokemonRepository.getPokemons(cantidad: cantidad);
      _pokemonList = pokemons;
      showContent();
    }
    catch (e) {
      showError();
    }
  }

  void showLoading() {
    state = PokemonStateProvider.loading;
    notifyListeners();
  }

  void showContent() {
    state = PokemonStateProvider.content;
    notifyListeners();
  }

  void showError() {
    state = PokemonStateProvider.error;
    notifyListeners();
  }
}
