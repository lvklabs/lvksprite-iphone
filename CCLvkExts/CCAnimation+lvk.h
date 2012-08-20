#import "CCAnimation.h"

@interface CCAnimation (CCLvkExt)

-(void) addFrameContent:(NSData*)content withKey:(NSString*)key;

-(void) addFrameContent:(NSData*)content withKey:(NSString*)key offset:(CGPoint)offset;

#ifdef LVKSPRITE_PVR_ENABLED
-(void) addFramePVRTCContent:(NSData*)data withKey:(NSString*)key;

-(void) addFramePVRTCContent:(NSData*)data withKey:(NSString*)key offset:(CGPoint)offset;
#endif

@end
