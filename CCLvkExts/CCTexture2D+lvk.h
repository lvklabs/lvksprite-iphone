#import "CCTexture2D.h"

@interface CCTexture2D (CCLvkExt)

#ifdef LVKSPRITE_PVR_ENABLED
-(id) initWithPVRTCData: (NSData*) data;
#endif

@end


