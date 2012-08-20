#import "CCTextureCache.h"

@interface CCTextureCache (CCLvkExt)

-(CCTexture2D*) addImageFromRawData: (NSData*) content withKey: (NSString*) key;

#ifdef LVKSPRITE_PVR_ENABLED
-(CCTexture2D*) addPVRTCImageFromRawData: (NSData*) data withKey: (NSString*)key;
#endif

@end
