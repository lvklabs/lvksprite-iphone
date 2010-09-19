//
//  LvkSprite.m
//  LvkSpriteProject
//
//  Created by Mario Tambos on 05/09/10.
//  Copyright 2010 LavandaInk. All rights reserved.
//

#import "LvkSpriteTest.h"
#import "ResourcesPath.h"

@implementation LvkSpriteTest
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

/*
 Class to test: LvkSprite
 Method to test: - (id) initWithBinary: (NSString*)bin andInfo: (NSString*)info;
 Prerrequisites: None
 Parameters: correct binary file, correct info file
 Expected results: Return != nil
				   NSMutableDictionary *lvkAnimations
				   -- should be initialized with the animations. i.e. For each animation must exist a (key, value) = (animation_name, CCAnimation)
*/
- (void)testLVK_SP_01_3 {
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@LVK_SPRITE_RESOURCES_PATH"/ryu-fixed-frame-size.lkob" andInfo:@LVK_SPRITE_RESOURCES_PATH"/ryu-fixed-frame-size.lkot"];
	
    //GHAssertNotNULL(a, nil);
	
    // Assert equal objects, add custom error description
    //GHAssertEqualObjects(a, b, @"Foo should be equal to: %@. Something bad happened", bar);
}


/*
 Class to test: LvkSprite
 Method to test: - (void) playAnimation: (NSString *)name atX:(CGFloat)x atY:(CGFloat)y repeat:(int)n;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
 Parameters: valid animation name, any (x,y), repeat > 0
 Expected results: Any way to detect graphically that is playing the animation??
				   Property "animation" returns the animation name
				   Property "x" returns correctly the x position
				   Property "y" returns correctly the y position
				   Inmediately call animationHasEnded, should return false
				   Wait n seconds (n greater enough to finish the animation) call animationHasEnded, should return true
 */
- (void)testLVK_SP_03_3 {
    //initialization
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@LVK_SPRITE_RESOURCES_PATH"/ryu-fixed-frame-size.lkob" andInfo:@LVK_SPRITE_RESOURCES_PATH"/ryu-fixed-frame-size.lkot"];
	
	int x = 0;
	int y = 0;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:3];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"punch", @"Wrong animation name");
	GHAssertEquals(sprite.x, 0, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, 0, @"The y  coordinate is not %d", y);
	[NSThread sleepForTimeInterval:3];
	GHAssertTrue([sprite animationHasEnded], @"");

	x = -12;
	y = -8;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:3];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"punch", @"Wrong animation name");
	GHAssertEquals(sprite.x, 0, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, 0, @"The y  coordinate is not %d", y);
	[NSThread sleepForTimeInterval:3];
	GHAssertTrue([sprite animationHasEnded], @"");

	x = 12;
	y = 8;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:3];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"punch", @"Wrong animation name");
	GHAssertEquals(sprite.x, 0, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, 0, @"The y  coordinate is not %d", y);
	[NSThread sleepForTimeInterval:3];
	GHAssertTrue([sprite animationHasEnded], @"");

	x = -12;
	y = 8;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:3];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"punch", @"Wrong animation name");
	GHAssertEquals(sprite.x, 0, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, 0, @"The y  coordinate is not %d", y);
	[NSThread sleepForTimeInterval:3];
	GHAssertTrue([sprite animationHasEnded], @"");

	x = 12;
	y = -8;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:3];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"punch", @"Wrong animation name");
	GHAssertEquals(sprite.x, 0, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, 0, @"The y  coordinate is not %d", y);
	[NSThread sleepForTimeInterval:3];
	GHAssertTrue([sprite animationHasEnded], @"");
}

/*
 Class to test: LvkSprite
 Method to test: - (void) playAnimation: (NSString *)name atX:(CGFloat)x atY:(CGFloat)y repeat:(int)n;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
 Parameters: valid animation name, any (x,y), repeat = 0
 Expected results: Any way to detect graphically that is *not* playing anything??
				   Property "animation" returns nil
 */
- (void)testLVK_SP_03_4 {
    //initialization
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@LVK_SPRITE_RESOURCES_PATH"/ryu-fixed-frame-size.lkob" andInfo:@LVK_SPRITE_RESOURCES_PATH"/ryu-fixed-frame-size.lkot"];
	
	int x = 0;
	int y = 0;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:0];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualObjects(sprite.animation, nil, @"Wrong animation name");
}
@end
