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
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	
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
/*
 Class to test: LvkSprite
 Method to test: - (BOOL) loadBinary: (NSString*)bin andInfo: (NSString*)info;  
 Prerrequisites: None
 Parameters:wrong binary file, correct info file
 Expected results: Return FALSE
*/
- (void)testLVK_SP_02 {
	LvkSprite *utLvkSprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	BOOL myBool = [utLvkSprite loadBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
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
	LvkSprite *utLvkSprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	BOOL myBool = [utLvkSprite loadBinary:@"ryu-fixed-frame-sie-WF.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	GHAssertFalse(myBool,@"return value must be equal to FALSE but insted it's %i ", myBool);
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
	LvkSprite *utLvkSprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	BOOL myBool = [utLvkSprite loadBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size-WF.lkot"];
	GHAssertFalse(myBool,@"return value must be equal to FALSE but insted it's %i ", myBool);
	[utLvkSprite release];
	utLvkSprite=nil;
}  


- (void)testLVK_SP_03_3 {
    //initialization
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	
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
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	
	int x = 0;
	int y = 0;
	[sprite playAnimation:@"kick" atX:x atY:y repeat:0];
	GHAssertEqualObjects(sprite.animation, nil, @"Wrong animation name");
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
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	
	[sprite playAnimation:@"wrongName"];
	GHAssertEquals(sprite.animation, nil, @"Wrong animation name");

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
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
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
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
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
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
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
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	[sprite playAnimation:@"kick"];
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	sprite.collisionThreshold = 0;
	
	LvkSprite* collidingSprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
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
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	[sprite playAnimation:@"kick"];
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	sprite.collisionThreshold = 0;
	
	LvkSprite* collidingSprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	[collidingSprite playAnimation:@"kick"];
	
	CGPoint collidingPosition = {sprite.rect.size.width - 1, sprite.rect.size.height - 1};
	collidingSprite.position = collidingPosition;
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
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	[sprite playAnimation:@"kick"];
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	sprite.collisionThreshold = 1;
	
	LvkSprite* collidingSprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	[collidingSprite playAnimation:@"kick"];
	CGPoint collidingPosition = {sprite.rect.size.width + 2, sprite.rect.size.height + 2};
	collidingSprite.position = collidingPosition;
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
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	[sprite playAnimation:@"kick"];
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	sprite.collisionThreshold = 2;
	
	LvkSprite* collidingSprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	[collidingSprite playAnimation:@"kick"];
	CGPoint collidingPosition = {sprite.rect.size.width + 1, sprite.rect.size.height + 1};
	collidingSprite.position = collidingPosition;
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
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	[sprite playAnimation:@"kick"];
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	sprite.collisionThreshold = 2;
	
	LvkSprite* collidingSprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	[collidingSprite playAnimation:@"kick"];
	CGPoint collidingPosition = {sprite.rect.size.width - 1, sprite.rect.size.height - 1};
	collidingSprite.position = collidingPosition;
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
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	[sprite playAnimation:@"kick"];
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	sprite.collisionThreshold = -1;
	
	LvkSprite* collidingSprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	[collidingSprite playAnimation:@"kick"];
	CGPoint collidingPosition = {sprite.rect.size.width, sprite.rect.size.height};
	collidingSprite.position = collidingPosition;
	GHAssertFalse([sprite collidesWithSprite:collidingSprite], @"The sprite collides");

	collidingPosition.x = sprite.rect.size.width + 2;
	collidingPosition.y = sprite.rect.size.height + 2;
	collidingSprite.position = collidingPosition;
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
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	[sprite playAnimation:@"kick"];
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	sprite.collisionThreshold = -2;
	
	LvkSprite* collidingSprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	[collidingSprite playAnimation:@"kick"];
	
	CGPoint collidingPosition = {sprite.rect.size.width - 1, sprite.rect.size.height - 1};
	collidingSprite.position = collidingPosition;
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
	LvkSprite* sprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	[sprite playAnimation:@"kick"];
	CGPoint initialPosition = {0, 0};
	sprite.position = initialPosition;
	sprite.collisionThreshold = -1;
	
	LvkSprite* collidingSprite = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	[collidingSprite playAnimation:@"kick"];
	CGPoint collidingPosition = {sprite.rect.size.width - 2, sprite.rect.size.height - 2};
	collidingSprite.position = collidingPosition;
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
	LvkSprite *ryu = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
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
	LvkSprite *ryu = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
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
	LvkSprite *ryu = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
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
	LvkSprite *ryu = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
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
	LvkSprite *ryu = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
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
	LvkSprite *ryu = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
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
	LvkSprite *ryu = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
	[ryu setPosition:ccp(50, 100)];
	[ryu playAnimation:@"walk"];
	ryu.collisionThreshold =  -3;
	CGRect rect = CGRectMake([ryu rect].origin.x - 2 , [ryu rect].origin.y - 2 , 3, 3);
	BOOL collide = [ryu collidesWithRect:rect];
	GHAssertFalse(collide,@"collideWithRect return %d insted of TRUE",collide);
	[ryu release];
	ryu = nil;
}

/*
 Parameters: 
 Expected result: 
 */
- (void) testLVK_SP_09_08 {
	LvkSprite *ryu = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo:@"ryu-fixed-frame-size.lkot"];
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
