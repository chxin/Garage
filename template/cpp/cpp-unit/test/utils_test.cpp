#include <cppunit/extensions/HelperMacros.h>
#include <iostream>
#include <cstring>

#include "test.h"
#include "utils.h"
using namespace std;

void UtilsTest::testAddFive() {
  CPPUNIT_ASSERT(Utils::addFiveForTest(2)==7);
}

void UtilsTest::testAddThree() {
  CPPUNIT_ASSERT(Utils::addThree(2)==5);
}
