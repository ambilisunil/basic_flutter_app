import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';

class GenderMysticApp extends StatelessWidget {
  const GenderMysticApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mystic Gender Oracle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: GoogleFonts.cinzelTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
      ),
      home: const Gender(),
    );
  }
}

class Gender extends StatefulWidget {
  const Gender({super.key});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  final Map<String, dynamic> _genderData = {};
  final TextEditingController _nameController = TextEditingController();

  Future<void> fetchGenderData(String name) async {
    final response = await http.get(
      Uri.parse('https://api.genderize.io?name=$name'),
    );
    if (response.statusCode == 200) {
      setState(() {
        _genderData.clear();
        _genderData.addAll(jsonDecode(response.body));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/mystic_bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              "Mystic Gender Oracle",
              style: GoogleFonts.cinzelDecorative(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.black.withOpacity(0.6),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Enter a Magical Name',
                    labelStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final name = _nameController.text.trim();
                    if (name.isNotEmpty) {
                      fetchGenderData(name);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "✨ Reveal Gender ✨",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 40),
                ShowGenderResults(data: _genderData),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ShowGenderResults extends StatelessWidget {
  const ShowGenderResults({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: const Text(
          "🪄 Enter a name to unveil its mystery...",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purpleAccent.withOpacity(0.6),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "🧙 Gender: ${data['gender']?.toString().toUpperCase()}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "${(data['probability'] * 100).toStringAsFixed(2)}% chance that '${data['name']}' is ${data['gender']}.",
            style: const TextStyle(fontSize: 16, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


// class Gender extends StatefulWidget {
//   const Gender({super.key});

//   @override
//   State<Gender> createState() => _GenderState();
// }

// class _GenderState extends State<Gender> {
//   final Map<String, dynamic> _genderData = {};
//   final TextEditingController _nameController = TextEditingController();

//   Future<void> fetchGenderData(String name) async {
//     final response = await http.get(
//       Uri.parse('https://api.genderize.io?name=$name'),
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         _genderData.clear();
//         _genderData.addAll(jsonDecode(response.body));
//       });
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Failed to fetch data')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Gender Checker")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Enter Name',
//                 border: OutlineInputBorder(),
//               ),
//               validator: (value) => value == null || value.isEmpty
//                   ? 'Please enter your name'
//                   : null,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 final name = _nameController.text.trim();
//                 if (name.isNotEmpty) fetchGenderData(name);
//               },
//               child: const Text('Find Gender'),
//             ),
//             const SizedBox(height: 30),
//             ShowGenderResults(data: _genderData),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ShowGenderResults extends StatelessWidget {
//   const ShowGenderResults({super.key, required this.data});

//   final Map<String, dynamic> data;

//   @override
//   Widget build(BuildContext context) {
//     if (data.isEmpty) {
//       return const Text("No data to display yet.");
//     }

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 243, 254, 248),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         children: [
//           Text(
//             "Gender: ${data['gender']}",
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             "${(data['probability'] * 100).toStringAsFixed(2)}% chance that '${data['name']}' is ${data['gender']}.",
//             style: const TextStyle(fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }