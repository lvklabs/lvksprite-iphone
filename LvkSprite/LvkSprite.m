//
//  LvkSprite.m
//  LvkSpriteProject
//
//  Copyright 2010, 2011, 2012 LVK. All rights reserved.
//

#import <Foundation/NSData.h>
#import "LvkSprite.h"
#import "LvkRepeatAction.h"
#import "LvkSpawn.h"
#import "CCAnimation+lvk.h"
#import "CCAction+lvk.h"
#import "LvkAnimate.h"
#import "common.h"

////////////////////////////////////////////////////////////////////////////////
// free_mem()
//
// TODO move this to another file

#import <mach/mach.h>      // freemem
#import <mach/mach_host.h> // freemem

natural_t free_mem() 
{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    host_port = mach_host_self();
    
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        
        NSLog(@"Failed to fetch vm statistics");
        return 0;
    }
    /* Stats in bytes */
    natural_t mem_free = vm_stat.free_count * pagesize;
    return mem_free;
}

////////////////////////////////////////////////////////////////////////////////

const float LVK_SPRITE_FPS = 1.0/24.0;

@interface LvkSprite ()

@property (readwrite, retain) NSMutableDictionary* animationsInternal;
@property (readwrite, retain) NSEnumerator* linesIterator;
@property (readwrite, retain) CCActionInterval* aniAction;
@property (readwrite, retain) NSString* keyPrefix;

/// Preload only textures and store them in the texture cache. Do not create animations
@property BOOL preloadMode;


- (NSString*) buildKeyWithFrameId:(NSString*)frameId;
- (BOOL) parseFpixmaps:(NSMutableDictionary*)frames withBinData:(NSData *)binData;
- (BOOL) parseAnimations:(NSMutableDictionary*)frames ids:(NSArray *)ids;
- (BOOL) parseAframes:(NSMutableDictionary*)frames animName:(NSString*)animName animId:(NSString *)animId;
- (void) addAframeWithKey:(NSString *)key frames:(NSMutableDictionary *)frames offset:(CGPoint)offset toAnimation:(CCAnimation*)anim;

@end

@implementation LvkSprite

@synthesize animationsInternal = _animations;
@synthesize linesIterator = _linesIterator;
@synthesize aniAction = _aniAction;
@synthesize keyPrefix = _keyPrefix;
@synthesize preloadMode = _preloadMode;

@synthesize collisionThreshold;

- (NSDictionary*) animations
{
    return _animations;
}

+ (LvkSprite *) sprite
{
    return [[[LvkSprite alloc] init] autorelease];
}

+ (LvkSprite *) spriteWithName:(NSString *)name
{
    return [[[LvkSprite alloc] initWithName:name] autorelease];
}

- (LvkSprite *) init
{
	return [self initWithName:nil];
}

- (LvkSprite *) initWithName:(NSString *)name
{
	if ((self = [super init])) {
		self.animationsInternal = [NSMutableDictionary dictionary];
		
        NSString *lkobFile = [[NSBundle mainBundle] pathForResource:name ofType:@"lkob"];
        NSString *lkotFile = [[NSBundle mainBundle] pathForResource:name ofType:@"lkot"];
		[self loadBinary:lkobFile info:lkotFile];

		_animation = nil;
		_aniAction = nil;
		px = &(position_.x);
		py = &(position_.y);
		pw = &(contentSize_.width);
		ph = &(contentSize_.height);
		collisionThreshold = 0;
		
		self.anchorPoint = CGPointMake(0, 1);
	}
	return self;
}

- (void) dealloc 
{
	[_animation release];
	[_animations release];
	[_linesIterator release];
	[_aniAction release];
    
	[super dealloc];
}

-(void) draw
{
	[super draw];

#ifdef LVK_SPRITE_SHOW_FRAME_RECT
	CGFloat x;
	CGFloat y;
	CGFloat w;
	CGFloat h;
	
	//Color:magenta
    glColor4ub(255, 0, 255, 255);
	glLineWidth(1);
	x = rect_.origin.x;
	y = rect_.origin.y;
	w = rect_.size.width;
	h = rect_.size.height;
	CGPoint v1[] = { 
		ccp(x, y), 
		ccp(x + w, y), 
		ccp(x + w, y + h),
		ccp(x, y + h)
	};
	ccDrawPoly(v1, 4, YES);

	//Color:red
	glColor4ub(255, 0, 0, 255);
	ccDrawPoint(CGPointMake(x, y));	
	
	//Color:purple
	glColor4ub(128, 0, 128, 255);
	glLineWidth(1);
	x = rect_.origin.x - collisionThreshold;
	y = rect_.origin.y - collisionThreshold;
	w = rect_.size.width + collisionThreshold;
	h = rect_.size.height + collisionThreshold;
	CGPoint v3[] = { 
		ccp(x, y), 
		ccp(x + w, y), 
		ccp(x + w, y + h),
		ccp(x, y + h)
	};
	ccDrawPoly(v3, 4, YES);
	
	//Color:green
	glColor4ub(0, 255, 0, 255);
	glLineWidth(1);
	x = position_.x;
	y = position_.y;
	w = contentSize_.width;
	h = contentSize_.height;
	CGPoint v2[] = { 
		ccp(x, y), 
		ccp(x + w, y), 
		ccp(x + w, y + h),
		ccp(x, y + h)
	};
	ccDrawPoly(v2, 4, YES);

	//Color:magenta
	glColor4ub(255, 0, 0, 255);
	ccDrawPoint(CGPointMake(x, y));	
	
	//Color:dark green
	glColor4ub(0, 128, 0, 255);
	glLineWidth(1);
	x = position_.x - collisionThreshold;
	y = position_.y - collisionThreshold;
	w = contentSize_.width + collisionThreshold;
	h = contentSize_.height + collisionThreshold;
	CGPoint v4[] = { 
		ccp(x, y), 
		ccp(x + w, y), 
		ccp(x + w, y + h),
		ccp(x, y + h)
	};
	ccDrawPoly(v4, 4, YES);
	
#endif //LVK_SPRITE_SHOW_FRAME_RECT	
}

////////////////////////////////////////////////////////////////////////////////

// Returns the next line of data in file that we are currently parsing 
- (NSString *) nextLine
{
	NSString *line;
	
	// Ommit empty lines and comments
	do {
		line = [self.linesIterator nextObject];

		if (line == nil) {
			break;
		}
		
		line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

	} while ([line length] == 0 || [line hasPrefix:@"#"]);
	
	return line;	
}

- (BOOL) loadBinary: (NSString*)binFile info:(NSString*)infoFile
{
	if (binFile == nil || infoFile == nil) {
		return NO;
	}
	
	[self.animationsInternal removeAllObjects];

	return [self loadBinary:binFile info:infoFile animationIds:nil];
}

- (BOOL) loadBinary:(NSString *)binFile info:(NSString *)infoFile animationIds:(NSArray *)ids
{
	if (binFile == nil || infoFile == nil) {
		return NO;
	}
	
#ifdef LVKSPRITELOG
	LKLOG(@" LvkSprite - === Sprite parsing started ===");
	LKLOG(@" LvkSprite - %@,%@", binFile, infoFile);
#endif
#ifdef MEMORYLOG 
    LKLOG(@"Free Mem: %ui MB", free_mem()/1024/1024);
#endif
	
	self.keyPrefix = infoFile;
	
	// load bin file -------------------------------
	NSError *error = nil;

    NSData *binData = [NSData dataWithContentsOfFile:binFile options:0 error:&error];
    
    if (error != nil) {
        LKLOG(@"LvkSprite - ERROR Error opening binary file: %@", [error localizedDescription]);
        return NO;
    }
		
	// Load info file ------------------------------
	
	error = nil;
	NSStringEncoding encoding;
    NSString *infoData = [NSString stringWithContentsOfFile:infoFile usedEncoding:&encoding error:&error];
	if (error != nil) {
		LKLOG(@"LvkSprite - ERROR Error opening info file: %@", [error localizedDescription]);
		return NO;
	}
	
	NSArray *lines = [infoData componentsSeparatedByString:@"\n"];
	self.linesIterator = [lines objectEnumerator]; 

	// Parse file ----------------------------------
	
	NSMutableDictionary *frames = [NSMutableDictionary dictionaryWithCapacity:10];
	
	NSString* line = nil;
	
	while ( (line = [self nextLine]) ) {
		
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

		BOOL ok = YES;
		
		// parsing frames
		if ([line hasPrefix:@"fpixmaps("]) {
			if ([self parseFpixmaps:frames withBinData:binData] == NO) {
				LKLOG(@"LvkSprite - ERROR cannot parse fpixmaps section.");
				ok = NO;
			}
		} else if ([line hasPrefix:@"animations("]){
			if ([self parseAnimations:frames ids:ids] == NO) {
				LKLOG(@"LvkSprite - ERROR cannot parse animations section.");
				ok = NO;
			}
// FIXME implement this:
//		} else {
//			LKLOG(@"LvkSprite - ERROR cannot parse line '%@'", line);
//			ok = NO;
		}
		
		[pool release];
		
		if (!ok) {
			return NO;
		}
	}

#ifdef LVKSPRITELOG
	LKLOG(@" LvkSprite - === Sprite parsing ended ===");
    LKLOG(@"Free Mem: %ui MB", free_mem()/1024/1024);
#endif

	return YES;
}

+ (BOOL) preloadTextures:(NSString *)binFile info:(NSString *)infoFile
{
    return [self preloadTextures:binFile info:infoFile animationIds:nil];
}

+ (BOOL) preloadTextures:(NSString *)binFile info:(NSString *)infoFile animationIds:(NSArray *)ids
{
    LvkSprite *spr = [[LvkSprite alloc] init];
    spr.preloadMode = YES;
    return [spr loadBinary:binFile info:infoFile animationIds:ids];
}

- (NSString*) buildKeyWithFrameId:(NSString*)frameId
{
	return [NSString stringWithFormat:@"%@_%@", self.keyPrefix != nil ? self.keyPrefix : @"Null" , frameId];
}

- (BOOL) parseFpixmaps:(NSMutableDictionary*)frames withBinData:(NSData *)binData
{
	NSString* line = nil;
	
	for (line = [self nextLine]; line != nil && ![line hasPrefix:@")"]; line = [self nextLine]) {
		
		// line format "frameId,offset,length"
		NSArray* lineInfo = [line componentsSeparatedByString:@","];
		NSString* frameId = [lineInfo objectAtIndex: 0];
		NSUInteger offset = [[lineInfo objectAtIndex: 1] intValue];
		NSUInteger length = [[lineInfo objectAtIndex: 2] intValue];
		
#ifdef LVKSPRITELOG
		LKLOG(@" LvkSprite - Parsing frame: %@,%i,%i", frameId, offset, length);
#endif
#ifdef MEMORYLOG 
		LKLOG(@"Free Mem: %ui MB", free_mem()/1024/1024);
#endif
		
		NSRange range = NSMakeRange(offset, length);
		[frames setObject:[binData subdataWithRange: range] forKey:[self buildKeyWithFrameId:frameId]];
	}
	
	return line != nil;
}

- (BOOL) parseAnimations:(NSMutableDictionary*)frames ids:(NSArray *)ids
{
	NSString* line = nil;
		
	for (line = [self nextLine]; line != nil && ![line hasPrefix:@")"]; line = [self nextLine]) {
		
		// line format "animId,animName"
		//             "aframes("
		//             "    aframeId,frameId,delay,ox,oy"
		//             ")"
		
		NSArray* lineInfo = [line componentsSeparatedByString:@","];
		NSString* animationId = [lineInfo objectAtIndex:0];
		NSString* animationName = [lineInfo objectAtIndex: 1];
		
		// if ids if not nil, we have an array with the list of animation ids to parse,
		// otherwise we parse all animations
		if (ids != nil) {
			BOOL found = NO;
			NSNumber *currentId = [NSNumber numberWithInt:[animationId integerValue]];
			for (NSNumber *id_ in ids) {
				if ([id_ isEqualToNumber:currentId] == YES) {
					found = YES;
					break;
				}
			}
			if (found == NO) {
				// If not found, ommit the whole section aframes and continue with next animation
				for (line = [self nextLine]; line != nil && ![line hasPrefix:@")"]; line = [self nextLine]);
				continue;
			}
		}
		
#ifdef LVKSPRITELOG
		LKLOG(@" LvkSprite - Parsing animation: %@ %@", animationId, animationName);
#endif
#ifdef MEMORYLOG 
		LKLOG(@"Free Mem: %ui MB", free_mem()/1024/1024);
#endif
				
		line = [self nextLine];
		if (![line hasPrefix:@"aframes("]) {  
			LKLOG(@" LvkSprite - Error: Ill-formed sprite file: aframes(...) section expected but got '%@'", line);
			return NO;
		}
		
		[self parseAframes:frames animName:animationName animId:animationId];		
	}
    
	// Create a Null animation 	
	CCAnimation *nullAnim = [CCAnimation animationWithName:@"NullAnimation" delay:LVK_SPRITE_FPS];
 	[self.animationsInternal setObject:[LvkAnimate actionWithAnimation:nullAnim] forKey:@"NullAnimation"];
	
	return line != nil;
}

- (BOOL) parseAframes:(NSMutableDictionary*)frames animName:(NSString*)animName animId:(NSString *)animId
{
	// TODO refactor this class!
	
	// Frames can be "Common" or "Sticky". Sticky frames are frames that are displayed always. 
	// To implement sticky frames we have one animation per sticky that only renders that frame. 
	// Finally we merge all sticky animations with the main animation to achieve the desired effect.
	CCAnimation *anim = [[CCAnimation alloc] initWithName:@"" delay:LVK_SPRITE_FPS];	// main animation
	NSMutableArray *stickyAnims = [[NSMutableArray alloc] init];						// array of sticky animations
	
	
	NSInteger frameCount = 1;
	float timeCount = 0; 
	
	NSString* line = nil;
	
	// aframes parsing
	for (line = [self nextLine]; line != nil && ![line hasPrefix:@")"]; line = [self nextLine]) {
		
		NSAutoreleasePool * subpool = [[NSAutoreleasePool alloc] init];
		
		// line format "<aframeId,frameId,delay>[,ox,oy][,sticky]"
		
		NSArray* lineInfo = [line componentsSeparatedByString:@","];
		
		if (lineInfo.count < 3) {
			LKLOG(@"LvkSprite - Error: Ill-formed sprite file: expected aframe but got '%@'. Line omitted", line);
			continue;
		}
		
		NSString* frameId = [lineInfo objectAtIndex: 1];					
		float duration = [[lineInfo objectAtIndex: 2] floatValue];
		int ox = 0;
		int oy = 0;
		BOOL isSticky = NO;
		
		if (lineInfo.count > 4) {	// Since LvkSprite format 0.2
			ox = [[lineInfo objectAtIndex:3] intValue];					
			oy = [[lineInfo objectAtIndex:4] intValue]*-1; // *-1 because the Lvk Sprite Tool has the origin at top-left corner	
		}
		if (lineInfo.count > 5) { 	// Since LvkSprite format 0.4
			isSticky = [[lineInfo objectAtIndex:5] intValue];
		}
		
		NSString *frameKey = [self buildKeyWithFrameId:frameId];
		
        if (_preloadMode == YES) {
            [self addAframeWithKey:frameKey frames:frames offset:CGPointMake(ox, oy) toAnimation:anim];
        } else
        if (isSticky == NO) {
			timeCount += duration*0.001;
			
			while (frameCount*LVK_SPRITE_FPS < timeCount) {
                [self addAframeWithKey:frameKey frames:frames offset:CGPointMake(ox, oy) toAnimation:anim];
				frameCount++;
			}						
		} else {
			// Create an animation that contains only one frame. This animation will be merge with the main animation.
			CCAnimation *stickyAnim = [[CCAnimation alloc] initWithName:@"" delay:1]; // Real delay will be added at the end.
            [self addAframeWithKey:frameKey frames:frames offset:CGPointMake(ox, oy) toAnimation:stickyAnim];
			[stickyAnims addObject:stickyAnim];
			[stickyAnim release];
		}
		
		[subpool release];
	}
	
	// main animation
	CCActionInterval *animAction = [LvkAnimate actionWithAnimation:anim];

	// If there is a sticky frame, merge (or "spawn" using cocos jargon) sticky animations with the animation
	
	for (NSUInteger i = 0; i < stickyAnims.count; ++i) {
		CCAnimation *stickyAnim = [stickyAnims objectAtIndex:(stickyAnims.count - i - 1)];
		stickyAnim.delay = [animAction duration];
		CCActionInterval *stickyAnimAction = [LvkAnimate actionWithAnimation:stickyAnim];
		
		animAction = [LvkSpawn actionOne:animAction two:stickyAnimAction];
		
		// FIXME!!!!!!!!!! Nasty workaround to avoid flickering
		if (i == 0) {
			[(LvkSpawn *)animAction setNested:NO];
		}
	}
	
	[self.animationsInternal setObject:animAction forKey:animName];

	
	[stickyAnims release];
	[anim release];
	
	return line != nil;
}

- (void) addAframeWithKey:(NSString *)key frames:(NSMutableDictionary *)frames offset:(CGPoint)offset
              toAnimation:(CCAnimation *)anim
{
    CCTexture2D *tex = [[CCTextureCache sharedTextureCache] textureForKey:key];
    
    if (tex == nil) {
        NSData *data = [frames objectForKey:key];
        if (data != nil) {
            UIImage *img = [UIImage imageWithData:data];
            tex = [[CCTextureCache sharedTextureCache] addCGImage:img.CGImage forKey:key];
        }
    }

    if (_preloadMode == NO) {
        if (tex != nil) {
            CGRect rect = CGRectZero;
            rect.size = tex.contentSize;
            CGRect rectInPixels = CC_RECT_POINTS_TO_PIXELS(rect);
            CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:tex rectInPixels:rectInPixels
                                                           rotated:NO offset:offset originalSize:rectInPixels.size];
            [anim addFrame:frame];
            
            if (CGSizeEqualToSize(self.contentSize, CGSizeZero)) {
                self.contentSize = rect.size;
            }
        } else {
            LKLOG(@"LvkSprite - Error: no frame data for key %@", key);
        }        
    }
}


////////////////////////////////////////////////////////////////////////////////
// TODO some pieces of code are duplicated. Refactor!


// Helper function to build CCActions from the list of animation names
- (NSMutableArray *) _getActionsFromAnimationList:(NSArray *) names repeat:(NSArray *)ns
{
	NSMutableArray *actions = [NSMutableArray arrayWithCapacity:names.count];
	
	int i;
	for (i = 0; i < names.count ; i++) {
		NSString* name = [names objectAtIndex:i];
		int n = (ns != nil && ns.count > i) ? [(NSNumber *)[ns objectAtIndex:i] intValue] : 1;
		
		CCActionInterval *anim = [self.animationsInternal objectForKey:name];

		if (anim != nil) {
			CCAction* action = nil;
			
			if (n == 1) {
				action = anim;
			} else if (n > 1) {
				action = [LvkRepeatAction actionWithAction:anim times:n];
			} else if (n == -1) {
				// Cannot use CCRepeatForever because this array of CCActions is used by CCSequence.
				// CCSequence requires all CCActions to be CCFiniteAction and CCRepeatForever is not.
				//action = [CCRepeatForever actionWithAction:[LvkAnimate actionWithAnimation:anim]];
				// NSUIntegerMax/10 should be enough for most purposes. Not using NSUIntegerMax because
				// I guess there is a risk of overflow at some point.
				action = [LvkRepeatAction actionWithAction:anim times:NSUIntegerMax/100];
			} 
			
			if (action != nil) {
				[actions addObject:action];				
			}
			else
			{
				LKLOG(@" LvkSprite - Could not create action from animation '%@'", name);				
			}
		} else {
			LKLOG(@" LvkSprite - animation '%@' does not exist", name);
		}		
	}

	return actions;
}

// helper to play an action n times
- (void) _playAction:(CCActionInterval *)action repeat:(int) n
{
	[self stopAnimation];
	self.aniAction = nil;

	if (n == 1) {
		self.aniAction = action;
	} else if (n > 1) {
		self.aniAction = [LvkRepeatAction actionWithAction:action times:n];
	} else if (n == -1) {
		self.aniAction = [CCRepeatForever actionWithAction:action];
	} 
	
	if (self.aniAction != nil) {
		[self runAction:self.aniAction];
	}			
}

// This helper function does the real work of playing a list of animations
- (void) _playAnimations: (NSArray *)names repeat:(NSArray *)ns atX:(CGFloat)x atY:(CGFloat)y
{	
	[self setPosition:ccp(x, y)];
	
	CCSequence* seq = [CCSequence actionsWithArray:[self _getActionsFromAnimationList:names repeat:ns]];
	
	[self _playAction:seq repeat:1];
}

// This helper function does the real work of playing one animation
- (void) _playAnimation: (NSString *)name atX:(CGFloat)x atY:(CGFloat)y repeat:(int)n
{
	[self setPosition:ccp(x, y)];
	
	CCActionInterval *anim = [self.animationsInternal objectForKey:name];
	
	if (anim != nil) {
		[self _playAction:anim repeat:n];
	} else {
		LKLOG(@" LvkSprite - animation '%@' does not exist", name);
	}	
}

////////////////////////////////////////////////////////////////////////////////

- (void) playAnimation: (NSString *)name atX:(CGFloat)x atY:(CGFloat)y repeat:(int)n
{
	[self _playAnimation:name atX:x atY:y repeat:n];
}

- (void) playAnimation: (NSString *)name repeat:(int)n
{
	[self _playAnimation:name atX:self.position.x atY:self.position.y repeat:n];
}

- (void) playAnimation: (NSString *)name
{
	[self _playAnimation:name atX:self.position.x atY:self.position.y repeat:-1];
}

// ---------------------------------------------------------------------------------

- (void) playAnimations:(NSArray *)names repeat:(NSArray *)ns atX:(CGFloat)x atY:(CGFloat)y
{
	[self _playAnimations:names repeat:ns atX:x atY:y];
}

- (void) playAnimations:(NSArray *)names repeat:(NSArray *)ns
{
	[self _playAnimations:names repeat:ns atX:self.position.x atY:self.position.y];
}

// ---------------------------------------------------------------------------------

- (void) stopAnimation
{
	if (self.aniAction != nil && ![self.aniAction isDone]) {
		[self stopAction:self.aniAction];
		self.aniAction = nil;
	}
}

- (BOOL) animationHasEnded
{
	if (self.aniAction == nil) {
		return YES;
	} else {
		return [self.aniAction isDone];
	}
}

- (BOOL) hasAnimation:(NSString *)name
{
	return [self.animationsInternal objectForKey:name] != nil;
}

////////////////////////////////////////////////////////////////////////////////

#define COCOS_DIRTY_YES isTransformDirty_ = isInverseDirty_ = YES;

- (void) setX:(CGFloat)x
{
	COCOS_DIRTY_YES
	*px = x;
}

- (CGFloat) x
{
	return *px;
}

- (void) setY:(CGFloat)y
{
	COCOS_DIRTY_YES
	*py = y; 
}

- (CGFloat) y
{
	return *py;
}

- (void) setDx: (CGFloat)dx
{
	COCOS_DIRTY_YES
	*px += dx;
}

- (void) setDy: (CGFloat)dy
{
	COCOS_DIRTY_YES
	*py += dy; 
}

- (void) setDx: (CGFloat)dx andDy:(CGFloat)dy
{
	COCOS_DIRTY_YES
	*px += dx; 
	*py += dy; 
}

////////////////////////////////////////////////////////////////////////////////

- (void) moveX: (CGFloat)x withVelocity:(CGFloat)vel
{
	//TODO
}

- (void) moveY: (CGFloat)y withVelocity:(CGFloat)vel
{
	//TODO
}

- (void) moveX: (CGFloat)x andY:(CGFloat)y withVelocity:(CGFloat)vel
{
	//TODO
}

- (void) moveDx: (CGFloat)dx withVelocity:(CGFloat)vel
{
	//TODO
}

- (void) moveDy: (CGFloat)dy withVelocity:(CGFloat)vel
{
	//TODO
}

- (void) moveDy: (CGFloat)dx andDy:(CGFloat)dy withVelocity:(CGFloat)vel
{
	//TODO
}

- (BOOL) moveHasEnded
{
	//TODO
	return NO;
}

////////////////////////////////////////////////////////////////////////////////

- (CGRect) rect
{
	return CGRectMake(*px, *py, *pw, *ph);
}

- (CGRect) collisionRect
{
	return CGRectMake(*px - collisionThreshold, 
					  *py - collisionThreshold, 
					  *pw + collisionThreshold, 
					  *ph + collisionThreshold);
}

- (BOOL) collidesWithSprite:(LvkSprite *)spr
{
	return CGRectIntersectsRect(self.collisionRect, spr.collisionRect);
}

- (BOOL) collidesWithPoint:(CGPoint)point
{
	return CGRectContainsPoint(self.collisionRect, point);
}

- (BOOL) collidesWithRect:(CGRect)rect
{
	return CGRectIntersectsRect(self.collisionRect, rect);
}

@end
