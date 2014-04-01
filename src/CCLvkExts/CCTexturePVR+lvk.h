#import "CCTexturePVR.h"

@interface CCTexturePVR (CCLvkExt)

#ifdef LVKSPRITE_PVR_ENABLED
- (id)initWithData:(NSData *)data;
#endif

@end




