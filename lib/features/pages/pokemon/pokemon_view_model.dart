
import 'package:flutter/material.dart';
import 'package:pokemon_app/data/model/pokemon_model.dart';
import 'package:pokemon_app/data/repository/pokemon_repository.dart';

enum PokemonState {loading, content, error}

class PokemonViewModel with ChangeNotifier {
  List<PokemonModel> _pokemonList = [];
  List<PokemonModel> get pokemonList => _pokemonList;

  PokemonState state = PokemonState.loading;

  Future<void> loadPokemons() async {
    try {
      showLoading();

      final pokemons = await PokemonRepository().getPokemons();
      _pokemonList = pokemons;
      
      showContent();
    }
    catch (e) {
      showError();
    }
  }

  Future<void> showLoading() async {
    state = PokemonState.loading;
    notifyListeners();
  }

  Future<void> showContent() async {
    state = PokemonState.content;
    notifyListeners();
  }

  Future<void> showError() async {
    state = PokemonState.error;
    notifyListeners();
  }
}