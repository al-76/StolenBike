#!/bin/sh

APP_NAME=StolenBike
XCODE_DERIVED_DATA=~/Library/Developer/Xcode/DerivedData/$APP_NAME-*/Build
PROFDATA=`readlink -f $XCODE_DERIVED_DATA/ProfileData/*/Coverage.profdata`
COVERAGE=`readlink -f $XCODE_DERIVED_DATA/Products/Debug-iphonesimulator/$APP_NAME.app/$APP_NAME`

xcrun llvm-cov export -format=lcov -instr-profile=$PROFDATA $COVERAGE > coverage.lcov
