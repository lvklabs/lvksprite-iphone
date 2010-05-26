//
//  LvkSprite.h
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/// This class loads and plays sprites created with the
/// Lvk Sprite Animation Tool. The Lvk Sprite format 
/// consists of two files: the binary file (*.lkob) and 
/// the text file (*.lkot)
/// The first one contains images of each frame, and  
/// the second one contains how to play the frames
///
/// Example:
/// 
/// LvkSprite *ryu = [[LvkSprite alloc] initWithBinary:@"ryu.lkob" andInfo: @"ryu.lkot"];
/// [sceneInstance addChild:ryu];
/// [ryu playAnimation:@"punch" atX:70 atY:100];
///
@interface LvkSprite : CCSprite 
{	
	// a dictionary mapping animationName --> cocosAnimation
	NSMutableDictionary *lvkAnimations;
	// Lines iterator used to parse the sprite file
	NSEnumerator* linesIterator; 
	// current animation
	NSString* animation;
}

/// Initializes an instance of the class using a Lvk Sprite 
/// @param bin: the lvk sprite binary file (usually *.lkob)
/// @param info: the lvk sprite information file (usually *.lkot)
/// @returns an initialized instance of LvkSprite
- (id) initWithBinary: (NSString*)bin andInfo: (NSString*)info;

/// Loads a Lvk Sprite
/// @param bin: the lvk sprite binary file (usually *.lkob)
/// @param info: the lvk sprite information file (usually *.lkot)
/// @returns TRUE if it loads and parses the files successfully,
///          FALSE otherwise
///
/// FIXME: current implementation always returns TRUE
- (BOOL) loadBinary: (NSString*)bin andInfo: (NSString*)info; 

/// Plays n times the given animation at the given position
/// @param name: the animation name
/// @param x: the x position of the animation
/// @param y: the y position of the animation
/// @param n: repeat n times the animation, -1 repeats forever
///
/// FIXME: always repeats forever
- (void) playAnimation: (NSString *)name atX:(int)x atY:(int)y repeat:(int)n;

/// Plays n times the given animation
/// @param name: the animation name
/// @param n: repeat n times the animation, -1 to repeat forever
///
/// FIXME: always repeats forever
- (void) playAnimation: (NSString *)name repeat:(int)n;

/// Plays forever the given animation
/// @param name: the animation name
- (void) playAnimation: (NSString *)name;

/// Returns if the animation has ended
/// @returns TRUE if the animation has ended, FALSE otherwise. 
///
/// TODO: implement
- (BOOL) animationHasEnded;

/// Returns the name of the current animation
/// @returns the name of the current animation or
///          nil if no animation is playing
@property (readonly) NSString* animation;

/// Set/returns the position of the sprite in the x axis
///
/// TODO: implement
@property double* x;

/// Set/returns the position of the sprite in the y axis
///
/// TODO: implement
@property double* y;

/// Changes the position of the sprite in the x axis relative to the current position
/// @param dx: the x offset
///
/// TODO: implement
- (void) setDx: (double)dx;

/// Changes the position of the sprite in the y axis relative to the current position
/// @param dy: the y offset
///
/// TODO: implement
- (void) setDy: (double)dy;

/// Changes the position of the sprite in the x and y axis relative to the current 
/// position
/// @param dx: the x offset
/// @param dy: the y offset
///
/// TODO: implement
- (void) setDx: (double)dx andDy:(double)dy;

/// Moves the sprite at the given velocity until reaches the given x position
/// @param x: the final x position
/// @param vel: the velocity (in pixels/frame)
///
/// TODO: implement
- (void) moveX: (double)x withVelocity:(double)vel;

/// Moves the sprite at the given velocity until reaches the given y position
/// @param y: the final y position
/// @param vel: the velocity (in pixels/frame)
///
/// TODO: implement
- (void) moveY: (double)y withVelocity:(double)vel;

/// Moves the sprite at the given velocity until reaches the given (x, y) position
/// @param x: the final x position
/// @param y: the final y position
/// @param vel: the velocity (in pixels/frame)
///
/// TODO: implement
- (void) moveX: (double)x andY:(double)y withVelocity:(double)vel;

/// Moves the sprite at the given offset at the given velocity
/// @param dx: the x offset
/// @param vel: the velocity (in pixels/frame)
- (void) moveDx: (double)dx withVelocity:(double)vel;

/// Moves the sprite at the given offset at the given velocity
/// @param dy: the y offset
/// @param vel: the velocity (in pixels/frame)
///
/// TODO: implement
- (void) moveDy: (double)dy withVelocity:(double)vel;

/// Moves the sprite at the given offset at the given velocity
/// @param dx: the x offset
/// @param vel: the velocity (in pixels/frame)
///
/// TODO: implement
- (void) moveDy: (double)dx andDy:(double)dy withVelocity:(double)vel;

/// returns if the sprite collides with the given sprite
/// @param spr: the given sprite
/// @returns TRUE if the sprite collides with the given sprite,
///          FALSE otherwise
///
/// TODO: implement
- (BOOL) collidesWithSprite:(LvkSprite *)spr;

/// returns if the sprite collides with the given point
/// @param point: the given point
/// @returns TRUE if the sprite collides with the given point,
///          FALSE otherwise
///
/// TODO: implement
- (BOOL) collidesWithPoint:(NSPoint)point;

/// returns if the sprite instance collides with the given rect
/// @param spr: the given rect
/// @returns TRUE if the sprite collides with the given rect,
///          FALSE otherwise
///
/// TODO: implement
- (BOOL) collidesWithRect:(NSRect)rect;

/// deallocate resources used by the class
///
/// TODO: check that *all* resources are deallocated
- (void) dealloc;

@end
