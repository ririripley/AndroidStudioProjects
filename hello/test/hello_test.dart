import 'package:flutter_test/flutter_test.dart';

import 'package:hello/main.dart';

void main() {
  test('adds one to input values', () {
    print('begin delay');


    // final calculator = Calculator();
    // expect(calculator.addOne(2), 3);
    // expect(calculator.addOne(-7), -6);
    // expect(calculator.addOne(0), 1);
    // expect(() => calculator.addOne(null), throwsNoSuchMethodError);
  });
  Future.delayed(Duration(milliseconds: 1), (){
    print('进入WECOM延时搜索:'  + 'hello');

  });
}
