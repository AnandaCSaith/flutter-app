import 'package:flutter/material.dart';
import 'package:flutterapp/components/big_card.dart';
import 'package:flutterapp/main.dart';
import 'package:provider/provider.dart';

class LinhasColunasPage extends StatelessWidget{
  const LinhasColunasPage({super.key, required this.appState,});

  final MainAppState appState;


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();

    return Scaffold(
      appBar: AppBar(title: Text("Feed de Notícias"), backgroundColor: Colors.black87),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNewsItem ("Flutter é Incrível", "Descubra como criar apps rápidos.", Colors.blue),

              Divider(),

              Row(
                children:[
                  Expanded(
                    flex: 7,
                    child: Container(
                      height: 100,
                      color: Colors.green[100],
                      padding: EdgeInsets.all(10),
                      child: Center(child: Text("Manchete Principal: Ocupa 70% da tela")),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 100,
                      color: Colors.red[100],
                      child: Center(child: Text("Ads (30%)")),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      )
    );
  }

  Widget _buildNewsItem(String title, String subtitle, Color color){
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.image, color: Colors.white),
          ),

          SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  subtitle + "Texto longo de exemplo para mostrar que ele quebra de linha automaticamente graças ao Expanded.",
                  style: TextStyle(color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
    );
  }
}
