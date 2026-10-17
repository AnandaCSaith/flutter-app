import 'package:flutter/material.dart';
import 'package:flutterapp/components/big_card.dart';
import 'package:flutterapp/main.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var menuSelecionado = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget pagina;
    switch (menuSelecionado) {
      case 0:
        {
          pagina = TelaHome();
          break;
        }
      case 1:
        {
          pagina = TelaFavoritos();
          break;
        }
      default:
        throw UnimplementedError('Sem widget para $menuSelecionado');
    }

    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: pagina,
        ),
      );

    return LayoutBuilder(
      builder: (context, constraints) {
        if(constraints.maxWidth < 450){
        return Column(
            children: [
              Expanded(child: mainArea),
              SafeArea(
                child: BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      label: 'Favoritos',
                    )
                  ],
                  currentIndex: menuSelecionado,
                  onTap: (selecionado) {
                    setState((){
                      menuSelecionado = selecionado;
                    });
                  },
                ),
              )
              
            ],
          );
        } else {
          return Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text("Home"),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text("Favoritos"),
                    ),
                  ],
                  selectedIndex: menuSelecionado,
                  onDestinationSelected: (selecionado) => {
                    setState(() {
                      menuSelecionado = selecionado;
                    }),
                  },
                  
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: pagina,
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class TelaHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainAppState>();
    var favoritas = appState.palavrasFavoritas;

    IconData icone;
    if (favoritas.contains(appState.palavraAtual)) {
      icone = Icons.favorite;
    } else {
      icone = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: HistoryListView(),
          ),
          SizedBox(height: 15),
          BigCard(appState: appState),
          SizedBox(height: 15,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: appState.marcarComoFavorito,
                label: Text("Like"),
                icon: Icon(icone),
              ),
              SizedBox(width: 15),
              ElevatedButton(
                onPressed: appState.gerarNovaPalavra,
                child: Text("Próxima palavra"),
              ),
            ],
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}

class TelaFavoritos extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
      var appState = context.watch<MainAppState>();

    if(appState.palavrasFavoritas.isEmpty){
      return Center(
        child:Text("Nenhum favorito localizado"),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(30),
          child: Text("Você tem ${appState.palavrasFavoritas.length} favoritos"),
        ),
        Expanded(
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400, 
              childAspectRatio: 400 / 80,
            ),
            children: [
              for(var item in appState.palavrasFavoritas)
                ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
                    color: theme.colorScheme.primary,
                    onPressed: () {
                      appState.removerFavoritas(item);
                    }
                  ),
                  title: Text(
                    item.asLowerCase,
                    semanticsLabel: item.asPascalCase,
                  ),
                )
            ],
          )
        )
      ]
    );
    
  }
}

class HistoryListView extends StatefulWidget{
  const HistoryListView({Key? key}) : super(key: key);

  @override
  State<HistoryListView> createState() => _HistoryListViewState();

}

class _HistoryListViewState extends State<HistoryListView> {

  final _key = GlobalKey();

  static const Gradient _maskingGradient = LinearGradient(
    colors: [Colors.transparent, Colors.black],
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MainAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final palavra = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
              child: TextButton.icon(
                onPressed: (){
                  appState.marcarComoFavorito();
                }, 
                icon: appState.palavrasFavoritas.contains(palavra)
                  ? Icon(Icons.favorite, size: 12)
                  : SizedBox(),
                label: Text(
                  palavra.asLowerCase,
                  semanticsLabel: palavra.asPascalCase,
                )),
              )
          );
        }
        ),
    );
  }
}


