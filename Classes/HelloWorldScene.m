//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "animParse.h"


// First implementation and use of LVKBin2ImageHelper. It`s purpose is to load images from a raw binary file
// and create animations from them
//

@implementation HelloWorld

+(id) scene
{
	// 'scene' is an autorelease object.
	Scene *scene = [Scene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	
	//hardcoded values for test example prueba.raw
	[[NSFileManager defaultManager] changeCurrentDirectoryPath:@"/Volumes/disk0s6/Downloads/animParse/raw-images"];
	NSString  *pathBinary = @"ryu.lkob";
	NSString  *pathInfo = @"ryu.lkot";
		
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
	
		// create and initialize a Label
		Label* label = [Label labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director the the window size
		CGSize size = [[Director sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/8 );
		
		// add the label as a child to this Layer
		[self addChild: label z:1];
		
		animParse *helper = [[animParse alloc] initWithBinary:pathBinary andInfo: pathInfo andFrameRate:1/24.0];
		
		NSDictionary* animations = [helper getAnimations];
							
		Sprite *mysprite = [Sprite spriteWithFile:@"Icon.png"];
		mysprite.position = ccp(size.width /2, size.height/2);
		[self addChild:mysprite z:3];

		id anim = [animations objectForKey:@"punch"];
		id animAction = [[RepeatForever actionWithAction: [Animate actionWithAnimation: anim]] retain];

		[mysprite runAction:animAction];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
