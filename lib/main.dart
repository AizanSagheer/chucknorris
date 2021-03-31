import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MyApiApp());
}

class MyApiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _mySelection;

  String value;
  final String url = "https://api.chucknorris.io/jokes/categories";
  bool isLoding = false;
  bool newQuoteLoading = false;
  List data = List();
Future getCategoryJoke(String value)async{
  var response = await Dio()
      .get('https://api.chucknorris.io/jokes/random?category=$value');
 print(response.data['value']);
 final data=await response.data['value'];
  setState(() {
    value=data;
  });
  print(value);
  return value;


}
  Future<String> getSWData() async {
    setState(() {
      isLoding = true;
    });
    var res = await Dio().get(
      Uri.encodeFull(url),
    );
    var resBody = res.data;
    setState(() {
      _mySelection = resBody[0];
      isLoding = false;
      data = resBody;
    });

    print(resBody);
    await getData();
    return 'success';
  }

  void getData() async {
    setState(() {
      newQuoteLoading = true;
    });
    var response = await Dio()
        .get('https://api.chucknorris.io/jokes/random?category=$_mySelection');
    if (response.statusCode == 200) {
      setState(() {
        newQuoteLoading = false;
        value = response.data['value'];
        print(value);
      });
    } else {
      newQuoteLoading = false;
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    this.getSWData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Container(
              height: 300,
              padding: EdgeInsets.all(40.0),
              child: Image(
                image: NetworkImage(
                  'https://api.chucknorris.io/img/chucknorris_logo_coloured_small@2x.png',
                ),
              ),
            ),
            Container(
              child: isLoding
                  ? Container(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                      value,
                      style:
                          TextStyle(fontSize: 30.0, color: Colors.yellowAccent),
                    )),
            ),
            Container(
              child: newQuoteLoading
                  ? Container(
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.deepOrange),
                      child: Text(
                        'Again Random Joke',
                        style: TextStyle(
                          color: Colors.yellowAccent,
                        ),
                      ),
                      onPressed: () => getData(),
                    ),
            ),
            DropdownButton(
              dropdownColor: Colors.white,
              items: data.map((item) {
                return  DropdownMenuItem(
                  child:  Text(item),
                  value: item,
                );
              }).toList(),
              onChanged: (newVal)async {
             final data=  await getCategoryJoke(newVal);
                // print(newVal);
                // setState(() {
                //   _mySelection = newVal;
                // });
          // setState(() {
          //   value=data;
          // });
              },
              value: _mySelection,
            ),
          ],
        ),
      ),
    ));
  }
}
