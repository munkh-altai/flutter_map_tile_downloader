import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';

class TileDownloadLayerOptions extends LayerOptions {
  final Color color;

  final void Function() onComplete;
  String urlTemplate;
  List<String> subdomains;

  final String downloadTxt;
  final String selectZoomLevelTxt;
  final double maxZoom;
  final double minZoom;

  TileDownloadLayerOptions({
    this.color,
    this.onComplete,
    this.urlTemplate,
    this.subdomains,
    this.minZoom = 8,
    this.maxZoom = 12,
    this.downloadTxt = "Download",
    this.selectZoomLevelTxt = "Please select zoom levels",
  });
}
