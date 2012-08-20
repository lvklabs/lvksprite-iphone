#import "ccMacros.h"
#import "CCAnimation.h"
#import "CCSpriteFrame.h"
#import "CCTexture2D.h"
#import "CCTextureCache+lvk.h"

@implementation CCAnimation (CCLvkExt)

-(void) addFrameContent: (NSData*)content withKey:(NSString*)key
{
	[self addFrameContent:content withKey:key offset:CGPointZero];
}

-(void) addFrameContent:(NSData*)content withKey:(NSString*)key offset:(CGPoint)offset
{
	CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImageFromRawData:content withKey:key];
	CGRect rect = CGRectZero;
	rect.size = texture.contentSize;
	
	CGRect rectInPixels = CC_RECT_POINTS_TO_PIXELS( rect );
	
	CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture rectInPixels:rectInPixels rotated:NO offset:offset 
											  originalSize:rectInPixels.size];
	[frames_ addObject:frame];	
}

#ifdef LVKSPRITE_PVR_ENABLED

-(void) addFramePVRTCContent: (NSData*)data withKey:(NSString*)key
{
	[self addFramePVRTCContent:data withKey:key offset:CGPointZero];
}

-(void) addFramePVRTCContent: (NSData*)data withKey:(NSString*)key offset:(CGPoint)offset
{
	CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addPVRTCImageFromRawData:data withKey:key];
	CGRect rect = CGRectZero;
	rect.size = texture.contentSize;

	CGRect rectInPixels = CC_RECT_POINTS_TO_PIXELS( rect );
	
	CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:texture rectInPixels:rectInPixels rotated:NO offset:offset 
											  originalSize:rectInPixels.size];
	[frames_ addObject:frame];
}

#endif

@end
