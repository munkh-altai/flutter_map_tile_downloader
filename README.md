# flutter_map_tile_downloader

Tile download  by drag draw area

## Features
##### Area selection by drag draw
##### Download multiple zoom levels
##### Show download progress
##### Download completed event
##### Custom Texts

## Example image
<p align="center">
  <img width="300"  src="https://raw.githubusercontent.com/munkh-altai/flutter_map_tile_downloader/master/example.png">
</p>

## Usage

Add flutter_map, dio and  flutter_map_arcgis to your pubspec:

```yaml
dependencies:
  flutter_map: any
  flutter_map_arcgis: any
  dio: any 
  permission_handler: any 
  flutter_range_slider: any 
  path_provider: any 
  shared_preferences: any 
  percent_indicator: any 
```

Usage example

```dart
  import 'package:flutter/material.dart';
  import 'dart:async';
  import 'package:flutter/services.dart';
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
          urlTemplate: 'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
          subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
          tileProvider: CachedNetworkTileProvider(),
        )
        );
      }
  
      if(_tileSelecting){
        layers.add(
            TileDownloadLayerOptions(
              onComplete: onCompleted,
              urlTemplate: 'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
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
          appBar: AppBar(title: Text('Tile downloader exmample')),
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
                    child: RaisedButton(
                        onPressed: () {
                          startTileSelect(!_tileSelecting);
                        },
  
                        child: _tileSelecting
                            ? Text("Tile download")
                            : Text("Stop tile download")
                    )),
                Visibility(
                  child: Positioned(
                      bottom: 120,
                      right: 10,
                      child: RaisedButton(
                        onPressed: (_off_line_tile.urlTemplate != null)
                            ? () {
                          showOffline();
                        }
                            : null,
  
                        child: _offline
                            ? Text("Show online tile")
                            : Text("Show offine tile" ),
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

```

### Run the example

See the `example/` folder for a working example app.
