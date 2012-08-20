//
//  CCTexture2D+lvk.h
//  LvkSpriteProject
//
//  Copyright (c) 2012 LVK. All rights reserved.
//

#import "CCTexture2D.h"

@interface CCTexture2D (CCLvkExt)

#ifdef LVKSPRITE_PVR_ENABLED
-(id) initWithPVRTCData: (NSData*) data;
#endif

@end


