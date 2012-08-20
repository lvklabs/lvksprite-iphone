#import "CCTextureCache.h"

@interface CCTextureCache (CCLvkExt)

-(CCTexture2D*) addImageFromRawData: (NSData*) content withKey: (NSString*) key;

-(CCTexture2D*) addPVRTCImageFromRawData: (NSData*) data withKey: (NSString*)key;

@end
