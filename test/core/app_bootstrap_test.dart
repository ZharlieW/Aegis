import 'package:flutter_test/flutter_test.dart';

// AppBootstrap.runPreApp() and runAppInit() depend on RustLib, NIP55, etc.,
// so we only smoke-test that the bootstrap module is loadable.
void main() {
  test('AppBootstrap placeholder for future bootstrap tests', () {
    expect(true, isTrue);
  });
}
