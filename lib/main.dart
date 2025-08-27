import 'package:flutter/material.dart';
import 'package:pokemon_app/features/pages/pages.dart';
import 'package:pokemon_app/features/pages/pokemon/pokemon_view_model.dart';
import 'package:pokemon_app/features/states/provider/poke_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => PokeProvider()),
        ChangeNotifierProvider(create: ( _ ) => PokemonViewModel()),
      ],
      child: const MyApp(),
    ),
    // const ProviderScope(
    //   child: MyApp(),
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
        'home': (context) => PokemonPage(),
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