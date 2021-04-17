#pragma once
#include <iostream>
//单元测试时编写
class Utils {
 friend class UtilsTest;
 public:
  static int addFiveForTest(int num);
  static int addThree(int num);
};
