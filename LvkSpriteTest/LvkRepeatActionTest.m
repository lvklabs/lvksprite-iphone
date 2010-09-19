//
//  LvkSprite.m
//  LvkSpriteProject
//
//  Created by Mario Tambos on 05/09/10.
//  Copyright 2010 LavandaInk. All rights reserved.
//

#import "LvkRepeatActionTest.h"


@implementation LvkRepeatActionTest
- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
	return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}   

- (void)testFoo {
    // Assert a is not NULL, with no custom error description
	NSString* a;
	NSString* b;
	NSString* bar;
	
    GHAssertNotNULL(a, nil);
	
    // Assert equal objects, add custom error description
    GHAssertEqualObjects(a, b, @"Foo should be equal to: %@. Something bad happened", bar);
}

- (void)testBar {
    // Another test
}
@end
