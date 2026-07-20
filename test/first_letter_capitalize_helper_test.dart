import 'package:flutter_test/flutter_test.dart';
import 'package:masterfabric_core/src/helper/first_letter_capitalize_helper.dart';

void main() {
  test('capitalizes first letter', () {
    expect(FirstLetterCapitalizeHelper.capitalize('hello'), 'Hello');
    expect(FirstLetterCapitalizeHelper.capitalize(''), '');
  });
}
