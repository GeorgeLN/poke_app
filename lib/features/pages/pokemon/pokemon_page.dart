
import 'package:flutter/material.dart';
import 'package:pokemon_app/features/pages/pokemon/pokemon_view_model_provider.dart';
import 'package:provider/provider.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  late PokemonViewModelProvider pokemonModel;
  final _cantidadController = TextEditingController(text: '30');

  @override
  void initState() {
    super.initState();
    pokemonModel = context.read<PokemonViewModelProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      pokemonModel.loadPokemons(cantidad: _cantidadController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    pokemonModel = context.watch<PokemonViewModelProvider>();

    return Scaffold(
      //Appbar con botón de recargar la lista de Pokémones.
      appBar: AppBar(
        title: const Text('Pokémones'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              pokemonModel.loadPokemons(cantidad: _cantidadController.text);
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),

      body: Builder(
        builder: (context) {
          return Column(
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
                          pokemonModel.loadPokemons(cantidad: _cantidadController.text);
                        }
                      },
                      child: const Text('Buscar'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    switch (pokemonModel.state) {
                      case PokemonStateProvider.loading:
                        return const Center(child: CircularProgressIndicator());
                      case PokemonStateProvider.content:
                        return Container(
                          width: double.infinity,
                          child: ListView.builder(
                            itemCount: pokemonModel.pokemonList.length,
                            itemBuilder: (context, index) {
                              final pokemon = pokemonModel.pokemonList[index];
                              return ListTile(
                                leading: Image.network(pokemon.imageUrl),
                                title: Text(pokemon.name),
                              );
                            },
                          ),
                        );
                      case PokemonStateProvider.error:
                        return Center(
                          child: ElevatedButton(
                            onPressed: () {
                              pokemonModel.loadPokemons(cantidad: _cantidadController.text);
                            },
                            child: const Text('Reintentar'),
                          ),
                        );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
