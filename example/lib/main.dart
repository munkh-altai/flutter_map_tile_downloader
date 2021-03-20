import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_downloader/flutter_map_tile_downloader.dart';


import 'package:latlong/latlong.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _tileSelecting = false;
  bool _offline = false;

  OfflineTile _off_line_tile = OfflineTile(
      minZoom:0,
      maxZoom:0,
      urlTemplate:"",
  );

  @override
  void initState()  {
    super.initState();
    getOfflineTile();
  }
  void getOfflineTile() async {

        OfflineTile off_line_tile =  await getOfflineTileData();
        setState(() {
          _off_line_tile = off_line_tile;
        });

  }
  void startTileSelect(bool value) async {
    setState(() {
      _tileSelecting = value;
    });

  }
  void onCompleted() async {

    getOfflineTile();
    setState(() {
      _tileSelecting : false;
    });
  }

  void showOffline() async {
      setState(() {
        _offline = !_offline;
      });
  }

  @override
  Widget build(BuildContext context)  {


    List<LayerOptions> layers = [];

    if (_offline && _off_line_tile.urlTemplate != null) {
      layers.add(
          TileLayerOptions(
            tileProvider: FileTileProvider(),
            maxZoom: _off_line_tile.maxZoom,
            urlTemplate: _off_line_tile.urlTemplate,
          )
      );
    } else {
      layers.add(
      TileLayerOptions(
        urlTemplate: 'https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
        subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
      )
      );
    }

    if(_tileSelecting){
      layers.add(
          TileDownloadLayerOptions(
            onComplete: onCompleted,
            urlTemplate: 'https://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
            subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
            minZoom: 8,
            maxZoom: 12,
            downloadTxt: "Download",
            selectZoomLevelTxt: "Please select zoom levels"
          )
      );
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Tile downloader example')),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  center: LatLng(32.91081899999999, -92.734876),
                  zoom: 8.0,
                  minZoom: _offline && _off_line_tile.urlTemplate != null ? _off_line_tile.minZoom : 0,
                  maxZoom: _offline && _off_line_tile.urlTemplate != null ? _off_line_tile.maxZoom :18,
                  plugins: [
                    TileDownloaderPlugin()
                  ],
                ),
                layers: layers,
              ),
              Positioned(
                  bottom: 65,
                  right: 10,
                  child: ElevatedButton(
                      onPressed: () {
                        startTileSelect(!_tileSelecting);
                      },

                      child: _tileSelecting
                          ? Text("Stop tile download")
                          : Text("Tile download")
                  )),
              Visibility(
                child: Positioned(
                    bottom: 120,
                    right: 10,
                    child: ElevatedButton(
                      onPressed: (_off_line_tile.urlTemplate != null)
                          ? () {
                        showOffline();
                      }
                          : null,

                      child: _offline
                          ? Text("Show online tile")
                          : Text("Show offline tile" ),
                    )),
                visible: (_off_line_tile.urlTemplate != null),
              )
            ],
          ),
        ),
      ),
    );
  }
}
