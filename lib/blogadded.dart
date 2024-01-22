import 'package:blog/homepage.dart';
import 'package:flutter/material.dart';

class Tick extends StatefulWidget {
  const Tick({super.key});

  @override
  State<Tick> createState() => _TickState();
}

class _TickState extends State<Tick> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 300,
          ),
          Center(
            child: Column(
              children: [
                Text('Blog Added'),
                IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const HomePage();
                      }));
                    },
                    icon: Icon(Icons.home))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
