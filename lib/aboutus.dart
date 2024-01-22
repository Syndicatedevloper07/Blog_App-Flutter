import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher_string.dart';

class aboutus extends StatefulWidget {
  const aboutus({super.key});

  @override
  State<aboutus> createState() => _aboutusState();
}

class _aboutusState extends State<aboutus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        backgroundColor: Colors.blue[100],
        title: Text('About the developer'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: SizedBox(
                    height: 200,
                    width: 150,
                    child: Container(
                      color: Colors.grey,
                      child: Image.asset('assets/developer.jpg'),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  'Ajith Bhaskaran',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                  "👋 Hello, I'm Ajith Bhaskaran, an aspiring Flutter developer 🚀 on a journey to explore the boundless world of mobile app development. 💻 Passionate about creating seamless and visually appealing user experiences, I am dedicated to mastering the art of Flutter to build robust and dynamic applications. Through continuous learning 📚 and hands-on projects, I am honing my skills in crafting elegant and efficient code. Join me on this exciting adventure 🌟 as I embrace the challenges and innovations in the ever-evolving landscape of Flutter development. 🚀✨"),
              Text('Connect with me on: '),
              SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () => launchUrlString(
                  'https://www.linkedin.com/in/ajith-bhaskaran-404600297/',
                ),
                child: SizedBox(
                  height: 50,
                  width: 155,
                  child: Container(
                    color: Colors.blue[50],
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/ln.png',
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('My LinkedIn Profile')
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
