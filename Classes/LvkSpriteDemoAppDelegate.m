//
//  LvkSpriteDemoAppDelegate.m
//

#import "LvkSpriteDemoAppDelegate.h"
#import "cocos2d.h"
#import "LvkSprite.h"

@implementation LvkSpriteDemoAppDelegate

@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];	
	[window setMultipleTouchEnabled:YES];
	
	// must be called before any othe call to the director
	// WARNING: FastDirector doesn't interact well with UIKit controls
	[Director useFastDirector];
	
	// before creating any layer, set the landscape mode
	//[[Director sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	[[Director sharedDirector] setAnimationInterval:1.0/60];
	[[Director sharedDirector] setDisplayFPS:YES];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[Texture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
	
	// create an openGL view inside a window
	[[Director sharedDirector] attachInView:window];	
	[window makeKeyAndVisible];		
	
	Scene *scene = [Scene node];
	Layer *layer = [Layer node];
	[scene addChild: layer];
	[[Director sharedDirector] runWithScene: scene];
	
	if( (self=[super init] )) {
		#error "Before compile set this path, comment this line and DO NOT COMMIT the changes!"
		[[NSFileManager defaultManager] changeCurrentDirectoryPath:@"/Users/andres/lavandaink/src/animParse/exports"];
		
		@try {
			LvkSprite *ryu = [[LvkSprite alloc] initWithBinary:@"ryu-andres.lkob" andInfo: @"ryu-andres.lkot"];
			LvkSprite *ryu2 = [[LvkSprite alloc] initWithBinary:@"ryu-andres.lkob" andInfo: @"ryu-andres.lkot"];
			[layer addChild:ryu z:1];
			[layer addChild:ryu2 z:1];
			[ryu playAnimation:@"kick" atX:70 atY:100];
			[ryu2 playAnimation:@"offset_test" atX:200 atY:100];
		}
		@catch (NSException* e) {
			NSLog(@"Exception: %@: %@", [e name], [e reason]);
		}
	}
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[Director sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[Director sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[TextureMgr sharedTextureMgr] removeAllTextures];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[Director sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[Director sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[Director sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
