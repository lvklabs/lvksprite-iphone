//
//  LvkSprite.h
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    LkobStandar,
#ifdef LVKSPRITE_PVR_ENABLED
    LkobPVRTC, // Experimental
#endif
} LkobFormat;

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
    // does the binary file contain PVRTC images
    LkobFormat _lkobFormat;
	// Key prefix to insert frames in map
	NSString *_keyPrefix;
	// a dictionary mapping animationName --> cocosAnimation
	NSMutableDictionary *_animations;
	//
	NSMutableDictionary *_stickyAnimations;
	// Lines iterator used to parse the sprite file
	NSEnumerator *_linesIterator;
	// current animation name
	NSString *_animation;
	// current animation action
	CCActionInterval *_aniAction;
	// pointer to the x position
	CGFloat *px;
	// pointer to the y position
	CGFloat *py;
	// pointer to the sprite width
	CGFloat *pw;
	// pointer to the sprite height
	CGFloat *ph;
	// collision threshold
	CGFloat collisionThreshold;
}

/// Set/returns the position of the sprite in the x axis
@property CGFloat x;

/// Set/returns the position of the sprite in the y axis
@property CGFloat y;

@property (readonly, retain) NSDictionary* animations;

/// Gets the current frame rect
@property (readonly) CGRect rect;

/// Gets the current frame rect plus the collision threshold 
@property (readonly) CGRect collisionRect;

/// Gets or sets the collision threshold.
/// TODO explain with more detail
@property CGFloat collisionThreshold;

+ (id) spriteWithBinary:(NSString*)binFile format:(LkobFormat)format info:(NSString*)infoFile;

// Idem but only loads the given animation ids
+ (id) spriteWithBinary:(NSString*)binFile format:(LkobFormat)format info:(NSString*)infoFile ids:(NSArray *)ids;


//// Initializes an instance of the class using a Lvk Sprite 
/// @param bin: the lvk sprite binary file (usually *.lkob)
/// @param format: the lvk sprite binary format (Standar or PVRTC)
/// @param info: the lvk sprite information file (usually *.lkot)
/// @returns an initialized instance of LvkSprite
- (id) initWithBinary:(NSString*)binFile format:(LkobFormat)format info:(NSString*)infoFile;

// Idem but only loads the given animation ids
- (id) initWithBinary:(NSString*)binFile format:(LkobFormat)format info:(NSString*)infoFile ids:(NSArray *)ids;

/// Loads a Lvk Sprite
/// @param bin: the lvk sprite binary file (usually *.lkob)
/// @param format: the lvk sprite binary format (Standar or PVRTC)
/// @param info: the lvk sprite information file (usually *.lkot)
/// @returns TRUE if it loads and parses the files successfully,
///          FALSE otherwise
- (BOOL) loadBinary: (NSString*)binFile format:(LkobFormat)format info:(NSString*)infoFile;

// Idem but only loads the given animation ids
- (BOOL) loadBinary: (NSString*)binFile format:(LkobFormat)format info:(NSString*)infoFile ids:(NSArray *)ids;

/// Plays n times the given animation at the given position
/// @param name: the animation name
/// @param x: the x position of the animation
/// @param y: the y position of the animation
/// @param n: repeat n times the animation, -1 repeats forever
- (void) playAnimation: (NSString *)name atX:(CGFloat)x atY:(CGFloat)y repeat:(int)n;

/// Plays n times the given animation list
/// @param names: the list of animation names
/// @param n: repeat n times the animation, -1 repeats forever
- (void) playAnimation: (NSString *)name repeat:(int)n;

/// Plays forever the given animation
/// @param name: the animation name
- (void) playAnimation: (NSString *)name;

/// Plays n times the given animation list at the given position
/// @param names: the list of animation names
/// @param ns: the list of repetitions for each animation. If nil it plays once.
/// @param x: the x position of the animation
/// @param y: the y position of the animation
- (void) playAnimations: (NSArray *)names repeat:(NSArray *)ns atX:(CGFloat)x atY:(CGFloat)y;

/// Plays n times the given animation list
/// @param names: the list of animation names
/// @param ns: the list of repetitions for each animation. If nil it plays once.
- (void) playAnimations: (NSArray *)names repeat:(NSArray *)ns;

/// Stops the current animation
- (void) stopAnimation;

/// Returns if the animation has ended
/// @returns TRUE if the animation has ended, FALSE otherwise. 
- (BOOL) animationHasEnded;

/// Returns if the given animation name exists in the sprite 
/// @returns TRUE if the animation exists, FALSE otherwise. 
- (BOOL) hasAnimation:(NSString *)name;

/// Changes the position of the sprite in the x axis relative to the current position
/// @param dx: the x offset
- (void) setDx: (CGFloat)dx;

/// Changes the position of the sprite in the y axis relative to the current position
/// @param dy: the y offset
- (void) setDy: (CGFloat)dy;

/// Changes the position of the sprite in the x and y axis relative to the current 
/// position
/// @param dx: the x offset
/// @param dy: the y offset
- (void) setDx: (CGFloat)dx andDy:(CGFloat)dy;

/// Moves the sprite at the given velocity until reaches the given x position
/// @param x: the final x position
/// @param vel: the velocity (in pixels/frame)
///
/// TODO: implement
- (void) moveX: (CGFloat)x withVelocity:(CGFloat)vel;

/// Moves the sprite at the given velocity until reaches the given y position
/// @param y: the final y position
/// @param vel: the velocity (in pixels/frame)
///
/// TODO: implement
- (void) moveY: (CGFloat)y withVelocity:(CGFloat)vel;

/// Moves the sprite at the given velocity until reaches the given (x, y) position
/// @param x: the final x position
/// @param y: the final y position
/// @param vel: the velocity (in pixels/frame)
///
/// TODO: implement
- (void) moveX: (CGFloat)x andY:(CGFloat)y withVelocity:(CGFloat)vel;

/// Moves the sprite at the given offset at the given velocity
/// @param dx: the x offset
/// @param vel: the velocity (in pixels/frame)
- (void) moveDx: (CGFloat)dx withVelocity:(CGFloat)vel;

/// Moves the sprite at the given offset at the given velocity
/// @param dy: the y offset
/// @param vel: the velocity (in pixels/frame)
///
/// TODO: implement
- (void) moveDy: (CGFloat)dy withVelocity:(CGFloat)vel;

/// Moves the sprite at the given offset at the given velocity
/// @param dx: the x offset
/// @param vel: the velocity (in pixels/frame)
///
/// TODO: implement
- (void) moveDy: (CGFloat)dx andDy:(CGFloat)dy withVelocity:(CGFloat)vel;

/// Returns if the movement has ended
/// @returns TRUE if the movement has ended, FALSE otherwise. 
///
/// TODO: implement
- (BOOL) moveHasEnded;

// Returns if the sprite collides with the given sprite
/// @param spr: the given sprite
/// @returns TRUE if the sprite collides with the given sprite,
///          FALSE otherwise
- (BOOL) collidesWithSprite:(LvkSprite *)spr;

/// Returns if the sprite collides with the given point
/// @param point: the given point
/// @returns TRUE if the sprite collides with the given point,
///          FALSE otherwise
- (BOOL) collidesWithPoint:(CGPoint)point;

/// Returns if the sprite instance collides with the given rect
/// @param spr: the given rect
/// @returns TRUE if the sprite collides with the given rect,
///          FALSE otherwise
- (BOOL) collidesWithRect:(CGRect)rect;

/// Drawing method that is called in every frame
-(void) draw;
@end
