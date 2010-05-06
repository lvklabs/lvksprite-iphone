//
//  LvkSprite.h
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//workaround "property list format"

@interface LvkSprite : Sprite 
{	
	/// a dictionary mapping animationName --> cocosAnimation
	NSMutableDictionary *lvkAnimations;
	/// Lines iterator used to parse the sprite file
	NSEnumerator* linesIterator; 
}

- (id) initWithBinary: (NSString*)bin andInfo: (NSString*)info;

- (void) loadBinary: (NSString*)bin andInfo: (NSString*)info; 

- (void) playAnimation: (NSString *)anim atX:(int)x atY:(int)y;

- (void) playAnimation: (NSString *)anim;

- (BOOL) animationHasEnded;

- (void) dealloc;

@end
