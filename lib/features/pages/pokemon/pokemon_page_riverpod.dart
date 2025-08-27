import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/features/states/riverpod/pokemon_providers.dart';

// **ConsumerWidget**
// Es un tipo de widget proporcionado por Riverpod que nos permite escuchar los cambios en los providers.
// Es una alternativa sin estado a `Consumer` y `StatefulWidget`.
// El método `build` nos da una instancia de `WidgetRef` (comúnmente llamado `ref`), que usamos para interactuar con los providers.
class PokemonPageRiverpod extends ConsumerWidget {
  const PokemonPageRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usamos `ref.watch` para escuchar los cambios en el `pokemonNotifierProvider`.
    // Cada vez que el estado de `PokemonNotifier` cambie, este widget se reconstruirá.
    final pokemonState = ref.watch(pokemonNotifierProvider);

    // Creamos un TextEditingController para el campo de texto.
    final _cantidadController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémones (Riverpod)'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Usamos `ref.read` para obtener el notifier y llamar a sus métodos.
              // `read` no escucha los cambios, solo obtiene el valor actual o el notifier.
              // Es ideal para usar dentro de callbacks como `onPressed`.
              ref.read(pokemonNotifierProvider.notifier).loadPokemons();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cantidadController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad de Pokémones',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_cantidadController.text.isNotEmpty) {
                      // Leemos el notifier del `cantidadPokemonProvider` y actualizamos su estado.
                      ref.read(cantidadPokemonProvider.notifier).state = _cantidadController.text;
                      // Volvemos a cargar los pokemons con la nueva cantidad.
                      ref.read(pokemonNotifierProvider.notifier).loadPokemons();
                    }
                  },
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ),
          Expanded(
            // Gestionamos la UI en función del estado de `pokemonState`.
            child: pokemonState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : pokemonState.errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(pokemonState.errorMessage!),
                            ElevatedButton(
                              onPressed: () {
                                ref.read(pokemonNotifierProvider.notifier).loadPokemons();
                              },
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: pokemonState.pokemons.length,
                        itemBuilder: (context, index) {
                          final pokemon = pokemonState.pokemons[index];
                          return ListTile(
                            leading: Image.network(pokemon.imageUrl),
                            title: Text(pokemon.name),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
