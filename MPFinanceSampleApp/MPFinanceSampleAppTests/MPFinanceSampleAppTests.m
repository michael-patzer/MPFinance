//
//  MPFinanceSampleAppTests.m
//  MPFinanceSampleAppTests
//
//  Created by Michael Patzer on 6/29/13.
//  Copyright (c) 2013 Michael Patzer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MPFinanceUtilities.h"

#define kAcceptableFloatingPointTestAccuracy 0.01

@interface MPFinanceSampleAppTests : XCTestCase

@end

@implementation MPFinanceSampleAppTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testInflation {
    double inflatedValue = MPInflate(100.0, 0.05, 7);
    XCTAssertEqualsWithAccuracy(inflatedValue, 140.71, kAcceptableFloatingPointTestAccuracy, @"Inflating 100 by 5 percent over 7 periods equals about %f", inflatedValue);
}

- (void)testDeflation {
    double deflatedValue = MPDeflate(80.0, 0.05, 13);
    XCTAssertEqualsWithAccuracy(deflatedValue, 42.43, kAcceptableFloatingPointTestAccuracy, @"Deflating 80 by 5 percent over 13 periods equals about %f", deflatedValue);
}

@end
