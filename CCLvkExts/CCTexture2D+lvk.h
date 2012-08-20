#import "CCTexture2D.h"

@interface CCTexture2D (CCLvkExt)

//lavadaink andres
/** Initializes a texture from a NSData with the contents of a PVRTC file. I had to implement this method because
 initWithPVRTCData:level:bpp:hasAlpha:length did not work in my case
 */
-(id) initWithPVRTCData: (NSData*) data;

@end



