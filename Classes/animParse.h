//
//  animParse.h
//  display_bin2image
//
//  Created by arkat on 26/09/09.
//  Copyright 2009 LavandInk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//workaround "property list format"
@interface animParse : CocosNode {
	
@private
	// a dictionary mapping animationName --> cocosAnimation
	NSMutableDictionary *animations;
	Layer *ourLayer;
	Scene *ourScene;
}

@property (readonly) NSDictionary *animations;
@property (readwrite,retain) Layer *ourLayer;
@property (readwrite,retain) Scene *ourScene;

// fps should be 1/N where N is the number of frames per second
- (id) initWithBinary: (NSString*)binPath andInfo: (NSString*)infoPath andFrameRate:(float)fps andScene:(Scene*)myScene andLayer:(Layer*)myLayer;

- (void) playAnimation: (NSString *)anim atX:(int)x atY:(int)y;

- (void) playAnimation: (NSString *)anim;

- (void) moveAnimation: (NSString *)anim fromX:(int)origX fromY:(int)origY toX:(int)destX toY:(int)destY during:(float)time;

- (void) dealloc;

@end
