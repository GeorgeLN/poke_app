
import 'package:flutter/material.dart';
import 'package:pokemon_app/data/model/pokemon_model.dart';
import 'package:pokemon_app/data/repository/pokemon_repository.dart';
import 'package:pokemon_app/features/states/provider/poke_provider.dart';
import 'package:provider/provider.dart';

enum PokemonState {loading, content, error}

class PokemonViewModel with ChangeNotifier {
  List<PokemonModel> _pokemonList = [];
  List<PokemonModel> get pokemonList => _pokemonList;

  PokemonState state = PokemonState.loading;

  Future<void> loadPokemons({BuildContext? context}) async {
    try {
      showLoading();

      String? cantidad = context?.read<PokeProvider>().getCantidad;
      final pokemons = await PokemonRepository().getPokemons(limit: int.tryParse(cantidad ?? '20') ?? 20);
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