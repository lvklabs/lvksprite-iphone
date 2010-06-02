//
//  LvkSpriteDemoAppDelegate.m
//

#import "LvkSpriteDemoAppDelegate.h"
#import "cocos2d.h"
#import "LvkSprite.h"
#import "ResourcesPath.h"

////////////////////////////////////////

BOOL touch = FALSE;

@interface MyLayer : CCLayer 
{ 
	LvkSprite *ryu;
	LvkSprite *ryu2;
}
- (void) tick: (ccTime) dt;
// TODO - (void) dealloc;

@end

@implementation MyLayer

- (id)init
{
    self = [super init];
    if (self != nil) {
		//NSString *fullpath = [CCFileUtils fullPathFromRelativePath: @"./Resources" ];
		[[NSFileManager defaultManager] changeCurrentDirectoryPath:@LVK_SPRITE_RESOURCES_PATH];
		
		isTouchEnabled = YES;
		
		@try {
			NSLog(@"App Demo: * Creating sprites...");
			ryu = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo: @"ryu-fixed-frame-size.lkot"];
			ryu2 = [[LvkSprite alloc] initWithBinary:@"ryu-fixed-frame-size.lkob" andInfo: @"ryu-fixed-frame-size.lkot"];
			
			NSLog(@"App Demo: * Adding sprites to the scene...");
			[self addChild:ryu z:1];
			[self addChild:ryu2 z:1];
			
			NSLog(@"App Demo: * Scheduling...");
			[self schedule:@selector(tick:)];
		}
		@catch (NSException* e) {
			NSLog(@"App Demo: Exception: %@: %@", [e name], [e reason]);
		}
    }
    return self; 
}

- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	NSLog(@"Touch!");
	touch = TRUE;
	return TRUE;
}

- (void) tick: (ccTime) dt
{
	static int frameCounter = 0;
	static int ryuState = 0;
	static int ryu2State = 0;

	NSLog(@"MyLayer tick - %i, %i", ryuState, ryu2State);

	
	// ryu logic
	
	static enum { RIGHT, LEFT } direction;
	const int speed = 2;
	
	switch (ryuState) {
		case 0:
			[ryu setPosition:ccp(50, 100)];
			[ryu playAnimation:@"walk"];
			direction = RIGHT;
			ryuState++;
			break;
		case 1:
			if (ryu.x < 180 && direction == RIGHT) {
			//if (![ryu collidesWithSprite:ryu2] && direction == RIGHT) {
				[ryu setDx:speed];
			} else {
				direction = LEFT;
			}
			if (ryu.x > 50 && direction == LEFT) {
				[ryu setDx:-speed];
			} else {
				direction = RIGHT;
			}			
			if (touch) {
				ryuState++;
			}
			break;
		case 2:
			[ryu playAnimation:@"kick" repeat:1];
			ryuState++;
			break;
		case 3:
			if ([ryu animationHasEnded]) {
				[ryu playAnimation:@"walk"];
				ryuState = 1;
			}			
			break;
	}
	
	// ryu2 logic
	
	switch (ryu2State) {
		case 0:
			[ryu2 setPosition:ccp(250, 100)];
			[ryu2 playAnimation:@"wait"];
			ryu2.flipX = YES;
			ryu2State++;
			break;
		case 1:
			if ([ryu2 collidesWithSprite:ryu] && ryu.animation == @"kick") {
				[ryu2 playAnimation:@"hitted" repeat:1];
				[ryu2 setDx:3];
				ryu2State++;
			}
			break;
		case 2:
			if ([ryu2 animationHasEnded] && ryu.animation != @"kick") {
				[ryu2 playAnimation:@"wait"];
				ryu2State = 1;
			}
			break;
	}
	
	frameCounter++;
	touch = FALSE;
}

@end

////////////////////////////////////////


@implementation LvkSpriteDemoAppDelegate

@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];	
	//[window setMultipleTouchEnabled:YES];
	
	// must be called before any othe call to the director
	// WARNING: FastDirector doesn't interact well with UIKit controls
	// DEPRECATED in 0.99 ?? [CCDirector useFastDirector];
	
	// before creating any layer, set the landscape mode
	//[[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	[[CCDirector sharedDirector] setAnimationInterval:1.0/60];
	[[CCDirector sharedDirector] setDisplayFPS:YES];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
	
	// create an openGL view inside a window
	[[CCDirector sharedDirector] attachInView:window];	
	[window makeKeyAndVisible];		
	
	if( (self=[super init]) ) {
		CCScene *scene = [CCScene node];
		MyLayer *layer = [MyLayer node];
		[scene addChild: layer];
		[[CCDirector sharedDirector] runWithScene: scene];
	}
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void) applicationDidBecomeActive:(UIApplication *)application 
{
	[[CCDirector sharedDirector] resume];
}

- (void) applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
	// FIXME [[TextureMgr sharedTextureMgr] removeAllTextures];
}

- (void) applicationWillTerminate:(UIApplication *)application {
	[[CCDirector sharedDirector] end];
}

- (void) applicationSignificantTimeChange:(UIApplication *)application 
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc 
{
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
