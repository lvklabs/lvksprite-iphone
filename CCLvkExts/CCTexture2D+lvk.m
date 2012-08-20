#import "CCTexture2D+lvk.h"
#import "cocos2d.h"

@implementation CCTexture2D (CCLvkExt)

-(id) initWithPVRTCData: (NSData*) data
{   
	if( (self = [super init]) ) {
		CCTexturePVR *pvr = [[CCTexturePVR alloc] initWithData:data];
		if( pvr ) {
			pvr.retainName = YES;	// don't dealloc texture on release
			
			name_ = pvr.name;	// texture id
			maxS_ = 1.0f;
			maxT_ = 1.0f;
			width_ = pvr.width;		// width
			height_ = pvr.height;	// height
			size_ = CGSizeMake(width_, height_);
			// No access to PVRHaveAlphaPremultiplied_
			//hasPremultipliedAlpha_ = PVRHaveAlphaPremultiplied_;
			// Set according needs:
			hasPremultipliedAlpha_ = YES;
			format_ = pvr.format;

			[pvr release];
            
			[self setAntiAliasTexParameters];
		} else {
            
			CCLOG(@"cocos2d: Couldn't load PVR image");
			[self release];
			return nil;
		}
	}
	return self;
}

@end
