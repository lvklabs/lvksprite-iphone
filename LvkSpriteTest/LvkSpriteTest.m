//
//  LvkSprite.m
//  LvkSpriteProject
//
//  Created by Mario Tambos on 05/09/10.
//  Copyright 2010 LavandaInk. All rights reserved.
//

#import "LvkSpriteTest.h"

@interface LvkSpriteTest ()

@property (retain) NSString* binFilePath;
@property (retain) NSString* textFilePath;

@end

@implementation LvkSpriteTest

@synthesize binFilePath;
@synthesize textFilePath;

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
	return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class
	NSBundle* mainBundle;
	// Get the main bundle for the app.
	mainBundle = [NSBundle mainBundle];

	self.binFilePath = [mainBundle pathForResource:@"ryu-fixed-frame-size" ofType:@"lkob"];
	self.textFilePath = [mainBundle pathForResource:@"ryu-fixed-frame-size" ofType:@"lkot"];
	
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];
	[[CCFastDirector sharedDirector] setDisplayFPS:NO];
	[[CCFastDirector sharedDirector] attachInWindow:window];
}

- (void)tearDownClass {
	[[CCFastDirector sharedDirector] detach];
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
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	
	GHAssertNil(error, nil);
	GHAssertNotNil(sprite, nil);
	GHAssertNotNil([sprite.lvkAnimations objectForKey:@"walk"], @"Element 'walk' was not found");
	GHAssertTrue([[sprite.lvkAnimations objectForKey:@"walk"] class] == NSClassFromString(@"CCAnimation"), @"Element 'walk' is not a CCAnimation");
	GHAssertNotNil([sprite.lvkAnimations objectForKey:@"kick"], @"Element 'kick' was not found");
	GHAssertTrue([[sprite.lvkAnimations objectForKey:@"kick"] class] == NSClassFromString(@"CCAnimation"), @"Element 'kick' is not a CCAnimation");
	GHAssertNotNil([sprite.lvkAnimations objectForKey:@"hitted"], @"Element 'hitted' was not found");
	GHAssertTrue([[sprite.lvkAnimations objectForKey:@"hitted"] class] == NSClassFromString(@"CCAnimation"), @"Element 'hitted' is not a CCAnimation");
	GHAssertNotNil([sprite.lvkAnimations objectForKey:@"wait"], @"Element 'wait' was not found");
	GHAssertTrue([[sprite.lvkAnimations objectForKey:@"wait"] class] == NSClassFromString(@"CCAnimation"), @"Element 'wait' is not a CCAnimation");
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
/*
 Class to test: LvkSprite
 Method to test: - (BOOL) loadBinary: (NSString*)bin andInfo: (NSString*)info;  
 Prerrequisites: None
 Parameters:wrong binary file, correct info file
 Expected results: Return FALSE
*/
- (void)testLVK_SP_02 {
	NSError* error = nil;
	LvkSprite *utLvkSprite = [[LvkSprite alloc] init];
	BOOL myBool = [utLvkSprite loadBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
    GHAssertNil(error, nil);
	GHAssertTrue(myBool,@"return value must be equal to TRUE but insted it's %i ", myBool);
	[utLvkSprite release];
	utLvkSprite=nil;
}

/*
 Class to test: LvkSprite
 Method to test: - (BOOL) loadBinary: (NSString*)bin andInfo: (NSString*)info;  
 Prerrequisites: None
 Parameters: correct binary file, wrong info file
 Expected results: Return FALSE
 */
- (void)testLVK_SP_02_02 {
	NSError* error = nil;
	LvkSprite *utLvkSprite = [[LvkSprite alloc] init];
	BOOL myBool = [utLvkSprite loadBinary:@"ryu-fixed-frame-sie-WF.lkob" andInfo:@"ryu-fixed-frame-size.lkot" andError:&error];
	GHAssertFalse(myBool,@"return value must be equal to FALSE but insted it's %i ", myBool);
    GHAssertNotNil(error, nil);
	[utLvkSprite release];
	utLvkSprite=nil;
}

/*
 Class to test: LvkSprite
 Method to test: - (BOOL) loadBinary: (NSString*)bin andInfo: (NSString*)info;  
 Prerrequisites: None
 Parameters: correct binary file, correct info file
 Expected results: Return TRUE
 */
- (void)testLVK_SP_02_03 {
	NSError* error = nil;
	LvkSprite *utLvkSprite = [[LvkSprite alloc] init];
	BOOL myBool = [utLvkSprite loadBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size-WF.lkot" andError:&error];
	GHAssertFalse(myBool,@"return value must be equal to FALSE but insted it's %i ", myBool);
    GHAssertNotNil(error, nil);
	[utLvkSprite release];
	utLvkSprite=nil;
}  


/*
 Class to test: LvkSprite
 Method to test: - (void) playAnimation: (NSString *)name atX:(CGFloat)x atY:(CGFloat)y repeat:(int)n;  
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
 Parameters: wrong animation name, any (x,y), repeat = -1 (i.e. Infinite)
 Expected results: Any way to detect graphically that is *not* playing anything??
				   Property "animation" returns nil
 */
- (void)testLVK_SP_03_1 {
    //initialization
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	
	CGFloat x = 0;
	CGFloat y = 0;
	[sprite playAnimation:@"wrongAnimationName" atX:x atY:y repeat:-1];
	GHAssertNil(sprite.animation, nil);
}

/*
 Class to test: LvkSprite
 Method to test: - (void) playAnimation: (NSString *)name atX:(CGFloat)x atY:(CGFloat)y repeat:(int)n;  
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
 Parameters: valid animation name, any (x,y), repeat = -1 (i.e. Infinite)
 Expected results: Any way to detect graphically that is playing the animation??
				   Property "animation" returns the animation name
				   Property "x" returns correctly the x position
				   Property "y" returns correctly the y position
				   Wait a couple of seconds, animationHasEnded should return false
 */
- (void)testLVK_SP_03_2 {
    //initialization
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	
	CGFloat x = 0;
	CGFloat y = 0;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:-1];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"kick", @"Wrong animation name");
	GHAssertEquals(sprite.x, x, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, y, @"The y  coordinate is not %d", y);
	//[NSThread sleepForTimeInterval:3];
	GHAssertFalse([sprite animationHasEnded], @"");
	
	x = -12;
	y = -8;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:-1];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"kick", @"Wrong animation name");
	GHAssertEquals(sprite.x, x, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, y, @"The y  coordinate is not %d", y);
	//[NSThread sleepForTimeInterval:3];
	GHAssertFalse([sprite animationHasEnded], @"");
	
	x = 12;
	y = 8;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:-1];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"kick", @"Wrong animation name");
	GHAssertEquals(sprite.x, x, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, y, @"The y  coordinate is not %d", y);
	//[NSThread sleepForTimeInterval:3];
	GHAssertFalse([sprite animationHasEnded], @"");
	
	x = -12;
	y = 8;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:-1];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"kick", @"Wrong animation name");
	GHAssertEquals(sprite.x, x, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, y, @"The y  coordinate is not %d", y);
	//[NSThread sleepForTimeInterval:3];
	GHAssertFalse([sprite animationHasEnded], @"");
	
	x = 12;
	y = -8;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:-1];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"kick", @"Wrong animation name");
	GHAssertEquals(sprite.x, x, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, y, @"The y  coordinate is not %d", y);
	//[NSThread sleepForTimeInterval:3];
	GHAssertFalse([sprite animationHasEnded], @"");
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
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);

	CGFloat x = 0;
	CGFloat y = 0;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:3];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"kick", @"Wrong animation name");
	GHAssertEquals(sprite.x, x, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, y, @"The y  coordinate is not %d", y);
	/* for (int i = 0; i < 10000000; i++) {
	}
	GHAssertTrue([sprite animationHasEnded], @"");
	 */
	x = -12;
	y = -8;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:3];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"kick", @"Wrong animation name");
	GHAssertEquals(sprite.x, x, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, y, @"The y  coordinate is not %d", y);
	/*[NSThread sleepForTimeInterval:3];
	 GHAssertTrue([sprite animationHasEnded], @"");
	 */
	x = 12;
	y = 8;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:3];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"kick", @"Wrong animation name");
	GHAssertEquals(sprite.x, x, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, y, @"The y  coordinate is not %d", y);
	/*[NSThread sleepForTimeInterval:3];
	 GHAssertTrue([sprite animationHasEnded], @"");
	 */
	x = -12;
	y = 8;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:3];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"kick", @"Wrong animation name");
	GHAssertEquals(sprite.x, x, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, y, @"The y  coordinate is not %d", y);
	/*[NSThread sleepForTimeInterval:3];
	 GHAssertTrue([sprite animationHasEnded], @"");
	 */
	x = 12;
	y = -8;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:3];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"kick", @"Wrong animation name");
	GHAssertEquals(sprite.x, x, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, y, @"The y  coordinate is not %d", y);
	/*[NSThread sleepForTimeInterval:3];
	 GHAssertTrue([sprite animationHasEnded], @"");
	 */
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
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);

	CGFloat x = 0;
	CGFloat y = 0;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:0];
	GHAssertNil(sprite.animation, nil);
}

/*
 Class to test: LvkSprite
 Method to test: - (void) playAnimation: (NSString *)name atX:(CGFloat)x atY:(CGFloat)y repeat:(int)n;  
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
 Parameters: wrong animation name, any (x,y), repeat = -1 (i.e. Infinite)
 Expected results: Any way to detect graphically that is *not* playing anything??
					Property "animation" returns nil
 */
- (void)testLVK_SP_04_1 {
    //initialization
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	
	[sprite playAnimation:@"wrongAnimationName" repeat:-1];
	GHAssertNil(sprite.animation, nil);
}

/*
 Class to test: LvkSprite
 Method to test: - (void) playAnimation: (NSString *)name repeat:(int)n;  
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
 Parameters: valid animation name, repeat = -1 (i.e. Infinite)
 Expected results: Any way to detect graphically that is playing the animation??
					 Property "animation" returns the animation name
					 Property "x" returns correctly the x position
					 Property "y" returns correctly the y position
					 Wait a couple of seconds, animationHasEnded should return false
 */
- (void)testLVK_SP_04_2 {
    //initialization
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	
	CGFloat x = sprite.x;
	CGFloat y = sprite.y;
	[sprite playAnimation:@"kick" repeat:-1];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"kick", @"Wrong animation name");
	GHAssertEquals(sprite.x, x, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, y, @"The y  coordinate is not %d", y);
	[NSThread sleepForTimeInterval:3];
	GHAssertFalse([sprite animationHasEnded], @"");
}

/*
 Class to test: LvkSprite
 Method to test: - (void) playAnimation: (NSString *)name repeat:(int)n;  
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
 Parameters: valid animation name, repeat > 0
 Expected results: Any way to detect graphically that is playing the animation??
					 Property "animation" returns the animation name
					 Property "x" returns correctly the x position
					 Property "y" returns correctly the y position
					 Inmediately call animationHasEnded, should return false
					 Wait n seconds (n greater enough to finish the animation) call animationHasEnded, should return true
 */
- (void)testLVK_SP_04_3 {
    //initialization
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	
	CGFloat x = sprite.x;
	CGFloat y = sprite.y;
	[sprite playAnimation:@"kick" repeat:3];
	GHAssertFalse([sprite animationHasEnded], @"");
	GHAssertEqualStrings(sprite.animation, @"kick", @"Wrong animation name");
	GHAssertEquals(sprite.x, x, @"The x coordinate is not %d", x);
	GHAssertEquals(sprite.y, y, @"The y  coordinate is not %d", y);
	/* [NSThread sleepForTimeInterval:3];
	GHAssertTrue([sprite animationHasEnded], @"");
	 */	
}

/*
 Class to test: LvkSprite
 Method to test: - (void) playAnimation: (NSString *)name repeat:(int)n;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
 Parameters: valid animation name, repeat = 0
					 Expected results: Any way to detect graphically that is *not* playing anything??
					 Property "animation" returns nil
 */
- (void)testLVK_SP_04_4 {
    //initialization
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	
	[sprite playAnimation:@"kick" repeat:0];
	GHAssertNil(sprite.animation, nil);
}

/*
 Class to test: LvkSprite
 Method to test: - (void) playAnimation: (NSString *)name;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
 Parameters: dx = 0
 Expected results: Property "x" returns correctly the x position (i.e. position did not change)
 */
- (void)testLVK_SP_05 {
    //initialization
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	
	[sprite playAnimation:@"wrongName"];
	GHAssertNil(sprite.animation, nil);
}

/*
 Class to test: LvkSprite
 Method to test: - (void) playAnimation: (NSString *)name;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
 Parameters: dx = 0
 Expected results: Property "x" returns correctly the x position (i.e. position did not change)
 */
- (void)testLVK_SP_05_2 {
    //initialization
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	
	[sprite playAnimation:@"kick"];
	GHAssertEqualStrings(sprite.animation, @"kick", @"Wrong animation name");
	[NSThread sleepForTimeInterval:3];
	GHAssertFalse([sprite animationHasEnded], @"");
}

/*
 Class to test: LvkSprite
 Method to test: - (void) setDx: (CGFloat)dx;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files, Use property "position" to set the initial (x,y)
 Parameters: dx = 0
 Expected results: Property "x" returns correctly the x position (i.e. position did not change)
 */
- (void)testLVK_SP_06 {
    //initialization
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	CGFloat dx = 0;

	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	[sprite setDx:dx];
	GHAssertEquals(sprite.position.x, initialPosition.x, @"The position has changed");
	
	initialPosition.x = -10;
	sprite.position = initialPosition;	
	[sprite setDx:dx];
	GHAssertEquals(sprite.position.x, initialPosition.x, @"The position has changed");
	
	initialPosition.x = 8;
	sprite.position = initialPosition;	
	[sprite setDx:dx];
	GHAssertEquals(sprite.position.x, initialPosition.x, @"The position has changed");
}

/*
 Class to test: LvkSprite
 Method to test: - (void) setDx: (CGFloat)dx;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files, Use property "position" to set the initial (x,y)
 Parameters: dx < 0
 Expected results: Property "x" returns correctly the x position
 */
- (void)testLVK_SP_06_2 {
    //initialization
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	CGFloat dx = -21;
	
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	[sprite setDx:dx];
	GHAssertEquals(sprite.position.x, initialPosition.x + dx, @"The position has not changed");
	
	initialPosition.x = -10;
	sprite.position = initialPosition;	
	[sprite setDx:dx];
	GHAssertEquals(sprite.position.x, initialPosition.x + dx, @"The position has not changed");
	
	initialPosition.x = 8;
	sprite.position = initialPosition;	
	[sprite setDx:dx];
	GHAssertEquals(sprite.position.x, initialPosition.x + dx, @"The position has not changed");
}

/*
 Class to test: LvkSprite
 Method to test: - (void) setDx: (CGFloat)dx;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files, Use property "position" to set the initial (x,y)
 Parameters: dx > 0
 Expected results: Property "x" returns correctly the x position
 */
- (void)testLVK_SP_06_3 {
    //initialization
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	CGFloat dx = 13;
	
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	[sprite setDx:dx];
	GHAssertEquals(sprite.position.x, initialPosition.x + dx, @"The position has not changed");
	
	initialPosition.x = -10;
	sprite.position = initialPosition;	
	[sprite setDx:dx];
	GHAssertEquals(sprite.position.x, initialPosition.x + dx, @"The position has not changed");
	
	initialPosition.x = 8;
	sprite.position = initialPosition;	
	[sprite setDx:dx];
	GHAssertEquals(sprite.position.x, initialPosition.x + dx, @"The position has not changed");
}

/*
 Class to test: LvkSprite
 Method to test: - (BOOL) collidesWithSprite:(LvkSprite *)spr;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
				 playAnimation invoked with a valid animation name
				 Set x,y position and collisionThreshold = 0
 Parameters: LvkSprite that does not collide with the sprite
 Expected results: Return FALSE
 */
- (void)testLVK_SP_11 {
    //initialization
	NSError*error;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	[sprite playAnimation:@"kick"];
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	sprite.collisionThreshold = 0;
	
	LvkSprite* collidingSprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	[collidingSprite playAnimation:@"kick"];
	CGPoint collidingPosition = {sprite.rect.size.width, sprite.rect.size.height};
	collidingSprite.position = collidingPosition;
	GHAssertFalse([sprite collidesWithSprite:collidingSprite], @"The sprite collides");

	collidingPosition.x = sprite.rect.size.width + 1;
	collidingPosition.y = sprite.rect.size.height + 1;
	collidingSprite.position = collidingPosition;
	GHAssertFalse([sprite collidesWithSprite:collidingSprite], @"The sprite collides");
}

/*
 Class to test: LvkSprite
 Method to test: - (BOOL) collidesWithSprite:(LvkSprite *)spr;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
				 playAnimation invoked with a valid animation name
				 Set x,y position and collisionThreshold = 0
 Parameters: LvkSprite that collides with the sprite
 Expected results: Return TRUE
 */
- (void)testLVK_SP_11_2 {
    //initialization
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	sprite.collisionThreshold = 0;
	[sprite playAnimation:@"kick"];
	
	LvkSprite* collidingSprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	
	CGPoint collidingPosition = {sprite.rect.size.width - 1, sprite.rect.size.height - 1};
	collidingSprite.position = collidingPosition;
	[collidingSprite playAnimation:@"kick"];
	GHAssertTrue([sprite collidesWithSprite:collidingSprite], @"The sprite does not collide");
}

/*
 Class to test: LvkSprite
 Method to test: - (BOOL) collidesWithSprite:(LvkSprite *)spr;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
				 playAnimation invoked with a valid animation name
				 Set x,y position and collisionThreshold > 0
 Parameters: LvkSprite that does not collide with the sprite. LvkSprite distance from the sprite > collisionThreshold
 Expected results: Return FALSE
 */
- (void)testLVK_SP_11_3 {
    //initialization
	NSError*error;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	sprite.collisionThreshold = 1;
	[sprite playAnimation:@"kick"];
	
	LvkSprite* collidingSprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	CGPoint collidingPosition = {sprite.rect.size.width + 2, sprite.rect.size.height + 2};
	collidingSprite.position = collidingPosition;
	[collidingSprite playAnimation:@"kick"];
	GHAssertFalse([sprite collidesWithSprite:collidingSprite], @"The sprite collides");
}

/*
 Class to test: LvkSprite
 Method to test: - (BOOL) collidesWithSprite:(LvkSprite *)spr;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
				 playAnimation invoked with a valid animation name
				 Set x,y position and collisionThreshold > 0
 Parameters: LvkSprite that does not collide with the sprite. LvkSprite distance from the sprite < collisionThreshold
 Expected results: Return TRUE
 */
- (void)testLVK_SP_11_4 {
    //initialization
	NSError*error;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	sprite.collisionThreshold = 2;
	[sprite playAnimation:@"kick"];
	
	LvkSprite* collidingSprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	CGPoint collidingPosition = {sprite.rect.size.width + 1, sprite.rect.size.height + 1};
	collidingSprite.position = collidingPosition;
	[collidingSprite playAnimation:@"kick"];
	GHAssertTrue([sprite collidesWithSprite:collidingSprite], @"The sprite does not collide");
}

/*
 Class to test: LvkSprite
 Method to test: - (BOOL) collidesWithSprite:(LvkSprite *)spr;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
 playAnimation invoked with a valid animation name
 Set x,y position and collisionThreshold > 0
 Parameters: LvkSprite that collides with the sprite.
 Expected results: Return TRUE
 */
- (void)testLVK_SP_11_5 {
    //initialization
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	sprite.collisionThreshold = 2;
	[sprite playAnimation:@"kick"];
	
	LvkSprite* collidingSprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	CGPoint collidingPosition = {sprite.rect.size.width - 1, sprite.rect.size.height - 1};
	collidingSprite.position = collidingPosition;
	[collidingSprite playAnimation:@"kick"];
	GHAssertTrue([sprite collidesWithSprite:collidingSprite], @"The sprite does not collide");
}

/*
 Class to test: LvkSprite
 Method to test: - (BOOL) collidesWithSprite:(LvkSprite *)spr;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
				 playAnimation invoked with a valid animation name
				 Set x,y position and collisionThreshold < 0
 Parameters: LvkSprite that does not collide with the sprite.
 Expected results: Return FALSE
 */
- (void)testLVK_SP_11_6 {
    //initialization
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	sprite.collisionThreshold = -1;
	[sprite playAnimation:@"kick"];
	
	LvkSprite* collidingSprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	CGPoint collidingPosition = {sprite.rect.size.width, sprite.rect.size.height};
	collidingSprite.position = collidingPosition;
	GHAssertFalse([sprite collidesWithSprite:collidingSprite], @"The sprite collides");

	collidingPosition.x = sprite.rect.size.width + 2;
	collidingPosition.y = sprite.rect.size.height + 2;
	collidingSprite.position = collidingPosition;
	[collidingSprite playAnimation:@"kick"];
	GHAssertFalse([sprite collidesWithSprite:collidingSprite], @"The sprite collides");
}

/*
 Class to test: LvkSprite
 Method to test: - (BOOL) collidesWithSprite:(LvkSprite *)spr;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
				 playAnimation invoked with a valid animation name
				 Set x,y position and collisionThreshold < 0
 Parameters: LvkSprite that collides with the sprite at a distance. LvkSprite penetrates the sprite < abs(collisionThreshold)
 Expected results: Return FALSE
 */
- (void)testLVK_SP_11_7 {
    //initialization
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	sprite.collisionThreshold = -2;
	[sprite playAnimation:@"kick"];
	
	LvkSprite* collidingSprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	
	CGPoint collidingPosition = {sprite.rect.size.width - 1, sprite.rect.size.height - 1};
	collidingSprite.position = collidingPosition;
	[collidingSprite playAnimation:@"kick"];
	GHAssertFalse([sprite collidesWithSprite:collidingSprite], @"The sprite collides");
}

/*
 Class to test: LvkSprite
 Method to test: - (BOOL) collidesWithSprite:(LvkSprite *)spr;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files
				 playAnimation invoked with a valid animation name
				 Set x,y position and collisionThreshold < 0
 Parameters: LvkSprite that collides with the sprite at a distance. LvkSprite penetrates the sprite > abs(collisionThreshold)
 Expected results: Return TRUE
 */
- (void)testLVK_SP_11_8 {
    //initialization
	NSError* error = nil;
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	sprite.collisionThreshold = -1;
	[sprite playAnimation:@"kick"];
	
	LvkSprite* collidingSprite = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	CGPoint collidingPosition = {sprite.rect.size.width - 2, sprite.rect.size.height - 2};
	collidingSprite.position = collidingPosition;
	[collidingSprite playAnimation:@"kick"];
	GHAssertTrue([sprite collidesWithSprite:collidingSprite], @"The sprite does not collide");
}


/*
 Class to test: LvkSprite
 Method to test: - (BOOL) collidesWithRect:(CGRect)rect;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files,
 playAnimation invoked with a valid animation name, Set x,y position and collisionThreshold = 0
 Parameters: rect that does not collide with the sprite
 Expected result: return FALSE
 */
- (void) testLVK_SP_09 {
	NSError* error = nil;
	LvkSprite* ryu = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	[ryu setPosition:ccp(0, 0)];
	[ryu playAnimation:@"walk"];
	ryu.collisionThreshold = 0;
	CGRect rect = CGRectMake(0, 0, 0, 0);
	BOOL collide = [ryu collidesWithRect:rect];
	GHAssertFalse(collide,@"collideWithRect return %d insted of FALSE",collide);
	[ryu release];
	ryu = nil;
}


/*
 Class to test: LvkSprite
 Method to test: - (BOOL) collidesWithRect:(CGRect)rect;
 Prerrequisites: initWithBinary or loadBinary invoked with valid sprite files,
 playAnimation invoked with a valid animation name, Set x,y position and collisionThreshold = 0
 Parameters: rect that collides with the sprite
 Expected result: return TRUE
 */
- (void) testLVK_SP_09_02 {
	NSError* error = nil;
	LvkSprite* ryu = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	[ryu setPosition:ccp(50, 100)];
	[ryu playAnimation:@"walk"];
	ryu.collisionThreshold = 0;
	CGRect rect = CGRectMake(0, 0, 1000, 1000);
	BOOL collide = [ryu collidesWithRect:rect];
	GHAssertTrue(collide,@"collideWithRect return %d insted of TRUE",collide);
	[ryu release];
	ryu = nil;
	
}

/*
 Class to test: LvkSprite
 Method to test: - (BOOL) collidesWithRect:(CGRect)rect;
 Prerrequisites: Idem but setting collisionThreshold > 0
 Parameters: rect that does not collide with the sprite. Rect distance from the sprite > collisionThreshold
 Expected result: return FALSE
 */
- (void) testLVK_SP_09_03 {
	NSError* error = nil;
	LvkSprite* ryu = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	[ryu setPosition:ccp(50, 100)];
	[ryu playAnimation:@"walk"];
	ryu.collisionThreshold = 1;
	CGRect rect = CGRectMake([ryu rect].origin.x -2, [ryu rect].origin.y -2, 1, 1);
	BOOL collide = [ryu collidesWithRect:rect];
	GHAssertFalse(collide,@"collideWithRect return %d insted of FALSE",collide);
	[ryu release];
	ryu = nil;
}

/*
 
 Parameters: 
 Expected result: 
 */
- (void) testLVK_SP_09_04 {
	NSError* error = nil;
	LvkSprite* ryu = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	[ryu setPosition:ccp(50, 100)];
	[ryu playAnimation:@"walk"];
	ryu.collisionThreshold =  2;
	CGRect rect = CGRectMake([ryu rect].origin.x -2, [ryu rect].origin.y -2, 1, 1);
	BOOL collide = [ryu collidesWithRect:rect];
	GHAssertTrue(collide,@"collideWithRect return %d insted of TRUE",collide);
	[ryu release];
	ryu = nil;
}

/*
 
 Parameters: 
 Expected result: 
 */
- (void) testLVK_SP_09_05 {
	NSError* error = nil;
	LvkSprite* ryu = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	[ryu setPosition:ccp(50, 100)];
	[ryu playAnimation:@"walk"];
	ryu.collisionThreshold =  1;
	CGRect rect = CGRectMake([ryu rect].origin.x -2 , [ryu rect].origin.y -2 , 2, 2);
	BOOL collide = [ryu collidesWithRect:rect];
	GHAssertTrue(collide,@"collideWithRect return %d insted of TRUE",collide);
	[ryu release];
	ryu = nil;
}

/*
 Prerrequisites:
 Parameters: 
 Expected result: 
 */
- (void) testLVK_SP_09_06 {
	NSError* error = nil;
	LvkSprite* ryu = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	[ryu setPosition:ccp(50, 100)];
	[ryu playAnimation:@"walk"];
	ryu.collisionThreshold = -1;
	CGRect rect = CGRectMake([ryu rect].origin.x -2, [ryu rect].origin.y -2, 1, 1);
	BOOL collide = [ryu collidesWithRect:rect];
	GHAssertFalse(collide,@"collideWithRect return %d insted of FALSE",collide);
	[ryu release];
	ryu = nil;
}

/*
 Parameters: 
 Expected result: 
 */
- (void) testLVK_SP_09_07 {
	NSError* error = nil;
	LvkSprite* ryu = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	[ryu setPosition:ccp(5, 5)];
	[ryu playAnimation:@"walk"];
	ryu.collisionThreshold =  -3;
	CGRect rect = CGRectMake([ryu rect].origin.x - 2 , [ryu rect].origin.y + 2 , 3, 3);
	BOOL collide = [ryu collidesWithRect:rect];
	GHAssertFalse(collide,@"collideWithRect return %d insted of False",collide);
	[ryu release];
	ryu = nil;
}

/*
 Parameters: 
 Expected result: 
 */
- (void) testLVK_SP_09_08 {
	NSError* error = nil;
	LvkSprite* ryu = [[LvkSprite alloc] initWithBinary:self.binFilePath andInfo:self.textFilePath andError:&error];
	GHAssertNil(error, nil);
	[ryu setPosition:ccp(50, 100)];
	[ryu playAnimation:@"walk"];
	ryu.collisionThreshold =  -2;
	CGRect rect = CGRectMake([ryu rect].origin.x - 2 , [ryu rect].origin.y - 2 , 5, 5);
	BOOL collide = [ryu collidesWithRect:rect];
	GHAssertTrue(collide,@"collideWithRect return %d insted of TRUE",collide);
	[ryu release];
	ryu = nil;
}


@end
