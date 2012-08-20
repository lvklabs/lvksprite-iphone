#import "CCTexturePVR+lvk.h"


@implementation CCTexturePVR (CCLvkExt)

- (id)initWithData:(NSData *)data
{
	if((self = [super init]))
	{		
		//_imageData = [[NSMutableArray alloc] initWithCapacity:10];
		
		name_ = 0;
		width_ = height_ = 0;
		//_internalFormat = GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG;
		tableFormatIndex_ = -1;
		hasAlpha_ = FALSE;
		
		retainName_ = NO; // cocos2d integration
        
		if( ! [self unpackPVRData:(unsigned char *)[data bytes] PVRLen:[data length]] || ![self createGLTexture]  ) {
			[self release];
			return nil;
		}
	}
	
	return self;
}

@end

