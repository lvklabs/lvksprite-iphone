//
//  LvkSprite.h
//
//  Created by arkat on 26/09/09.
//  Copyright 2009 LavandInk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//workaround "property list format"

@interface LvkSprite : Sprite 
{	
	/// a dictionary mapping animationName --> cocosAnimation
	NSMutableDictionary *lvkAnimations;
}

- (id) initWithBinary: (NSString*)bin andInfo: (NSString*)info;

- (void) loadBinary: (NSString*)bin andInfo: (NSString*)info; 

- (void) playAnimation: (NSString *)anim atX:(int)x atY:(int)y;

- (void) playAnimation: (NSString *)anim;

- (void) dealloc;

@end
