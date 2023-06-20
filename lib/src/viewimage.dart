import 'package:alex/main.dart';
import 'package:alex/src/download.dart';
import 'package:alex/src/wallpaper_options.dart';
import 'package:flutter/material.dart';

class ViewImage extends StatefulWidget {
  final String url;
  final JsonFileManager jsonFileManager;

  ViewImage({required this.url, required this.jsonFileManager});

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  late bool isFavorite;
  bool isButtonListVisible = false;

  void initState() {
    super.initState();
    isFavorite = favorites.contains(widget.url);
  }

  void toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      favorites.add(widget.url);
      await widget.jsonFileManager.writeJsonData(favorites);
    } else {
      favorites.remove(widget.url);
      await widget.jsonFileManager.deleteJsonData(favorites, widget.url);
    }
  }

  void toggleButtonListVisibility() {
    setState(() {
      isButtonListVisible = !isButtonListVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Viewer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          // Hide the button list when tapping outside
          if (isButtonListVisible) {
            toggleButtonListVisibility();
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.url),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.url),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: FractionallySizedBox(
                  alignment: Alignment.bottomCenter,
                  widthFactor: 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_outline,
                          ),
                          iconSize: 33,
                          color: Colors.white,
                          onPressed: toggleFavorite,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_downward_rounded),
                          iconSize: 33,
                          color: Colors.white,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  DownloadingDialog(
                                url: widget.url,
                                location: -1,
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(0, 0, 0, 0.3),
                        ),
                        child: IconButton(
                          icon: Image.asset(
                            'assets/icons/wallpy.png',
                            fit: BoxFit.cover,
                            color: Colors.white,
                          ),
                          onPressed: toggleButtonListVisibility,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isButtonListVisible)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ButtonList(
                    url: widget.url,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}