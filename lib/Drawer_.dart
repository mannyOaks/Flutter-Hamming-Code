import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                'El Team',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            decoration: BoxDecoration(color: Theme.of(context).accentColor),
          ),
          ListTile(
            title: Text('Manuel Ernesto Robles Hernández'),
            leading: Icon(Icons.person_outline),
            onTap: () => this._openInWeb(
                context,
                'https://www.facebook.com/manito0198',
                'Manuel Ernesto Robles Hernández'),
          ),
          ListTile(
            title: Text('Manuel Robles Meza'),
            leading: Icon(Icons.person_add),
            onTap: () => this._openInWeb(
                context,
                'https://www.facebook.com/manuel.robles.568',
                'Manuel Robles Meza'),
          ),
          ListTile(
            title: Text('Miriam Bonilla Tamayo'),
            leading: Icon(Icons.person_pin_circle),
            onTap: () => this._openInWeb(
                context, 'https://github.com/Milys17', 'Miriam Bonilla Tamayo'),
          ),
        ],
      ),
    );
  }

  Future<Null> _openInWeb(context, url, person) async {
    if (await url_launcher.canLaunch(url)) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => WebviewScaffold(
                initialChild: Center(
                  child: CircularProgressIndicator(),
                ),
                url: url,
                appBar: AppBar(title: Text(person)),
              ),
        ),
      );
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("No se pudo abrir la url."),
      ));
    }
  }
}
