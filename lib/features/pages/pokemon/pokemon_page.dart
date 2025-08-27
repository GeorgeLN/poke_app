
import 'package:flutter/material.dart';
import 'package:pokemon_app/features/pages/pokemon/pokemon_view_model.dart';
import 'package:pokemon_app/features/states/provider/poke_provider.dart';
import 'package:provider/provider.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  late PokemonViewModel pokemonModel;
  final _cantidadController = TextEditingController();

  @override
  void initState() {
    super.initState();
    pokemonModel = context.read<PokemonViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      pokemonModel.loadPokemons();
    });
  }

  @override
  Widget build(BuildContext context) {
    pokemonModel = context.watch<PokemonViewModel>();
    PokeProvider pokeProvider = Provider.of<PokeProvider>(context);

    return Scaffold(
      //Appbar con botón de recargar la lista de Pokémones.
      appBar: AppBar(
        title: const Text('Pokémones'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              pokemonModel.loadPokemons();
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
                          String cantidad = _cantidadController.text;
                          pokeProvider.setCantidad(cantidad);
                          pokemonModel.loadPokemons();
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
                      case PokemonState.loading:
                        return const Center(child: CircularProgressIndicator());
                      case PokemonState.content:
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
                      case PokemonState.error:
                        return Center(
                          child: ElevatedButton(
                            onPressed: () {
                              pokemonModel.loadPokemons();
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
