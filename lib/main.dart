import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 33, 93, 172),
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = "ambili";
  var b = 0;

  void getNext() {
    var h = WordPair.random();
    current = h.toString();
    notifyListeners();
  }

  var favorites = <String>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    print(favorites);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // ← Add this property.

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = FavouritePage();
      case 2:
        page = RegPage();
      case 3:
        page = TesyApp();

      case 4:
        page = Gender();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  //extended: false,
                  extended: constraints.maxWidth >= 600,

                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.app_registration_sharp),
                      label: Text('Reg Here'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.textsms_sharp),
                      label: Text('Test Here'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.find_replace_rounded),
                      label: Text('Gender Finder With Name'),
                    ),
                  ],

                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    print('selected: $value');
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SHOwText(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SHOwText extends StatelessWidget {
  const SHOwText({super.key, required this.pair});

  final String pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // ↓ Add this.
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        // ↓ Change this line.
        child: Text((pair).toString(), style: style),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text("A Random Idea"),
      ),
    );
  }
}

class FavouritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var fav = appState.favorites;

    return Center(
      child: Column(
        children: [
          HeadingFav(),
          for (var item in fav) // "item" is a variable for each element
            favItems(item: item), // Display the item in a Text widget
        ],
      ),
    );
  }
}

class favItems extends StatelessWidget {
  const favItems({super.key, required this.item});

  final String item;

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(Icons.star), title: Text(item));
  }
}

class HeadingFav extends StatelessWidget {
  const HeadingFav({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(style: TextStyle(fontSize: 50), "Fav Items "));
  }
}

// class RegPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     final _formKey = GlobalKey<FormState>();

//     return Form(
//       key: _formKey,
//       child: const Column(
//         children: <Widget>[
//           // Add TextFormFields and ElevatedButton here.

//         ],
//       ),
//     );
//   }
// }

class RegPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, process the data
                    String name = _nameController.text;
                    String email = _emailController.text;
                    // TODO: Implement your data processing logic here
                    print('Name: $name, Email: $email');
                    // You can add a snackbar to show the result
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Registration successful!')),
                    );
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TesyApp extends StatelessWidget {
  const TesyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Root widget
      home: Scaffold(
        appBar: AppBar(title: const Text('My Home Page')),
        body: Center(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  const Text('Hello, World!'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('Click!');
                    },
                    child: const Text('A button'),
                  ),
                  PaddedText(),
                  CounterWidget(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class PaddedText extends StatelessWidget {
  const PaddedText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: const Text('Hello, World!'),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  @override
  // Widget build(BuildContext context) {
  //   return BorderedImage();
  // }
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text("data"),
        Text("data"),
        Text("data"),

        BorderedImage(),
        // BorderedImage(),
        // BorderedImage(),
        // BorderedImage(),
        // BorderedImage(),
        // BorderedImage(),
        // BorderedImage(),
      ],
    );
    //;
  }
}

class BorderedImage extends StatelessWidget {
  const BorderedImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network('https://picsum.photos/250?image=9');
  }
}

class Gender extends StatefulWidget {
  const Gender({super.key});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  Map<String, dynamic> data = {};
  final _inputName = TextEditingController();

  @override
  void initState() {
    super.initState();
    // main("ambili");
  }

  void main(String name) async {
    final response = await http.get(
      Uri.parse('https://api.genderize.io?name=$name'),
    );
    setState(() {
      data = jsonDecode(response.body);
    });
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gender Checker")),
      body: Column(
        children: [
          TextFormField(
            controller: _inputName,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                main(_inputName.text);
              },
              child: Text('Find Gender'),
            ),
          ),
          ShowGenderResults(data: data),
        ],
      ),
    );
  }
}

class ShowGenderResults extends StatelessWidget {
  const ShowGenderResults({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 243, 254, 248),
      child: Center(
        child: data.isEmpty
            // ? const CircularProgressIndicator()
            ? const Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Text("Gender: ${data['gender']}"),
                    ),
                    Text(
                      " ${((data['probability']) * 100)}% Probability to Become ${data['gender']} for name ${data['name']}",
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

// Define a custom Form widget.
