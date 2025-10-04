import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecipeListScreen(),
    );
  }
}

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List list = [];

  @override
  void initState() {
    super.initState();
    apicall();
  }

  void apicall() async {
    
       http.Response response = await http.get(Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?s=fish"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        list = data["meals"];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( backgroundColor: Color(0xFF8B0000), 

  centerTitle: true,
   title: const Text("Recipe App",
    style: TextStyle(
      fontSize: 22, 
      fontWeight: FontWeight.bold, 
      color: Colors.white, 
    ),
  ),
    ),  body:  ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                    list[index]["strMealThumb"],
                    width: 50,
                    height: 50,
                 
                  ),
                  title: Text(list[index]["strMeal"]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipeDetailScreen(list[index]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class RecipeDetailScreen extends StatelessWidget {
  var  recipe;

   RecipeDetailScreen(this.recipe, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
 backgroundColor: const Color(0xFF8B0000), 

  centerTitle: true, 
  title: Text(
    recipe["strMeal"],
    style: const TextStyle(
      fontSize: 22, 
      fontWeight: FontWeight.bold, 
      color: Colors.white, 
    ),
  ),
),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(recipe["strMealThumb"]),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                recipe["strInstructions"],
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
