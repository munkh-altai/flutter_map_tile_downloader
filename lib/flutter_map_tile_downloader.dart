library flutter_map_tile_downloader;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
export 'tileDownloader/tile_download_layer.dart';
export 'tileDownloader/tile_download_layer_options.dart';
export './tile_downloader_plugin.dart';

class OfflineTile {
  final String urlTemplate;
  final double minZoom;
  final double maxZoom;
  const OfflineTile({
    this.urlTemplate = "",
    this.minZoom = 0,
    this.maxZoom = 0,
  });
}

Future<OfflineTile> getOfflineTileData() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return OfflineTile(
        minZoom:prefs.getDouble('offline_min_zoom'),
        maxZoom:prefs.getDouble('offline_max_zoom'),
        urlTemplate:prefs.getString('offline_template_url'),
  );
}