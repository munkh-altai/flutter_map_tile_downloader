import 'package:flutter_map_tile_downloader/utils/util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('template', () {
    expect(
      template(
        'http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
        {
          'x': '1',
          'y': '2',
          'z': '3',
          's': 'mt0',
        },
      ),
      'http://mt0.google.com/vt/lyrs=m&x=1&y=2&z=3',
    );
  });
}
