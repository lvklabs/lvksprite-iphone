//
//  display_bin2imageAppDelegate.m
//  display_bin2image
//
//  Created by Gonzalo Buteler on 9/12/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "display_bin2imageAppDelegate.h"
#import "cocos2d.h"
#import "animParse.h"

@implementation display_bin2imageAppDelegate

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
	//	[Director useFastDirector];
	
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
		[[NSFileManager defaultManager] changeCurrentDirectoryPath:@"/Users/lavanda/Documents/LavandaInk/animParse/raw-images"];
		NSString  *pathBinary = @"ryu.lkob";
		NSString  *pathInfo = @"ryu.lkot";
		animParse *animation = [[animParse alloc] initWithBinary:pathBinary andInfo: pathInfo andFrameRate:1/24.0 andScene:scene andLayer:layer];
//		[animation playAnimation:@"kick"];
		[animation moveAnimation:@"kick" fromX:150 fromY:150 toX:200 toY:200 during:2.3];		
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
