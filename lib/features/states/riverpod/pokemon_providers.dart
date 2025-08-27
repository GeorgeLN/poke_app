import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/data/model/pokemon_model.dart';
import 'package:pokemon_app/data/repository/pokemon_repository.dart';

// **StateProvider**
// Es un proveedor ideal para almacenar estados simples, como un String, un booleano, un número, o incluso objetos inmutables.
// En este caso, lo usamos para almacenar la cantidad de Pokémon que el usuario quiere ver.
// Cada vez que su valor cambia, los widgets que lo escuchan se reconstruyen.
final cantidadPokemonProvider = StateProvider<String>((ref) {
  // El valor inicial es '20'.
  return '20';
});

// **State Notifier y StateNotifierProvider**
// StateNotifier es una clase que permite gestionar un estado más complejo que puede cambiar con el tiempo en respuesta a eventos.
// Es el reemplazo recomendado para ChangeNotifier de Provider.
// Se combina con StateNotifierProvider para hacerlo disponible en toda la aplicación.

// 1. Definimos el estado que gestionará nuestro Notifier.
// Usamos una clase inmutable para representar el estado.
class PokemonState {
  final List<PokemonModel> pokemons;
  final bool isLoading;
  final String? errorMessage;

  PokemonState({
    this.pokemons = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  // Creamos un método copyWith para facilitar la creación de nuevos estados a partir de uno existente.
  // Esto es una práctica común para mantener la inmutabilidad.
  PokemonState copyWith({
    List<PokemonModel>? pokemons,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PokemonState(
      pokemons: pokemons ?? this.pokemons,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// 2. Creamos la clase Notifier, que extiende de StateNotifier<T>, donde T es el tipo de nuestro estado.
class PokemonNotifier extends StateNotifier<PokemonState> {
  final PokemonRepository _repository;
  final Ref ref;

  // El constructor del Notifier recibe el estado inicial.
  PokemonNotifier(this._repository, this.ref) : super(PokemonState()) {
    // Podemos llamar a métodos aquí al inicializar si es necesario.
    loadPokemonsProvider();
  }

  // Método para cargar los Pokémon.
  Future<void> loadPokemonsProvider() async {
    // Actualizamos el estado para indicar que la carga está en curso.
    // Usamos `state` para acceder y modificar el estado actual.
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Leemos el valor actual del `cantidadPokemonProvider` para saber cuántos Pokémon cargar.
      final cantidad = ref.read(cantidadPokemonProvider);
      final pokemons = await _repository.getPokemons(limit: int.parse(cantidad));

      // Si la carga es exitosa, actualizamos el estado con la nueva lista de Pokémon.
      state = state.copyWith(pokemons: pokemons, isLoading: false);
    } catch (e) {
      // Si ocurre un error, lo guardamos en el estado.
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

// 3. Creamos el StateNotifierProvider.
// Este provider creará una instancia de nuestro PokemonNotifier y permitirá que la UI interactúe con él.
// El `ref` dentro del provider nos permite acceder a otros providers, como el `cantidadPokemonProvider`.
final pokemonNotifierProvider = StateNotifierProvider<PokemonNotifier, PokemonState>((ref) {
  final repository = PokemonRepository();
  return PokemonNotifier(repository, ref);
});
