//
//  LvkRange.h
//  display_bin2image
//
//  Created by Gonzalo Buteler on 9/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 * Clase que encapsula un NSRange dentro de un objeto.
 * Esto lo hago porque los NSArray toman solo objetos 
 * y necesito un arreglo de rangos
 */

@interface LvkRange : NSObject {
	NSRange range;

}

-(id)initWithRange:(NSRange)r;

@property(readonly) NSRange range;

@end
