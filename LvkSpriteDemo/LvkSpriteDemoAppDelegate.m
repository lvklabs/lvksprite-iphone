//
//  LvkSpriteDemoAppDelegate.m
//

#import "LvkSpriteDemoAppDelegate.h"
#import "cocos2d.h"
#import "LvkSprite.h"

////////////////////////////////////////

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
		//#error "Before compile set this path, comment this line and DO NOT COMMIT the changes!"
//		NSString *fullpath = [CCFileUtils fullPathFromRelativePath: @"./Resources" ];
		[[NSFileManager defaultManager] changeCurrentDirectoryPath:@"/Users/andres/lavandaink/src/animParse/Resources"];
		
		@try {
			NSLog(@" * Creating sprites...");
			ryu = [[LvkSprite alloc] initWithBinary:@"ryu.lkob" andInfo: @"ryu.lkot"];
			[ryu setPosition:ccp(70, 100)];
			//ryu2 = [[LvkSprite alloc] initWithBinary:@"ryu.lkob" andInfo: @"ryu.lkot"];
			
			NSLog(@" * Adding sprites to the scene...");
			[self addChild:ryu z:1];
			//[self addChild:ryu2 z:1];
			
			NSLog(@" * Scheduling...");
			[self schedule:@selector(tick:)];
		}
		@catch (NSException* e) {
			NSLog(@"Exception: %@: %@", [e name], [e reason]);
		}
    }
    return self; 
}

- (void) tick: (ccTime) dt
{
	NSLog(@"MyLayer tick");
	
	static int frameCounter = 0;
	
	if (frameCounter % 200 == 0) {
		[ryu playAnimation:@"punch"];
	} else if (frameCounter % 200 == 99) {
		[ryu playAnimation:@"kick"];	
	}
	
	if ([ryu animationHasEnded]) {
		NSLog(@"animation has ended");
	}
	
	frameCounter++;
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
