import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/features/pages/pages.dart';
import 'package:pokemon_app/features/pages/pokemon/pokemon_page_riverpod.dart';
import 'package:pokemon_app/features/pages/pokemon/pokemon_view_model.dart';
import 'package:pokemon_app/features/states/provider/poke_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // Envolvemos la aplicación con ProviderScope.
    // Este widget almacena el estado de todos nuestros providers.
    const ProviderScope(
      child: MyApp(),
    ),

    // MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: ( _ ) => PokeProvider()),
    //     ChangeNotifierProvider(create: ( _ ) => PokemonViewModel()),
    //   ],
    //   child: const MyApp(),
    // ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,

      initialRoute: 'home',

      routes: {
        // Apuntamos la ruta 'home' a la nueva página con Riverpod.
        'home': (context) => const PokemonPageRiverpod(),
        // 'home': (context) => PokemonPage(),
      },
    );
  }
}

// class MyApppp extends ConsumerStatefulWidget {
//   const MyApppp({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _MyAppppState();
// }

// class _MyAppppState extends ConsumerState<MyApppp> {

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }