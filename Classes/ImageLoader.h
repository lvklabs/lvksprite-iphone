//
//  LvkBin2ImageHelper.h
//  display_bin2image
//
//  Created by Gonzalo Buteler on 9/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LvkRange.h"

/*
 * Clase encargada de agarrar un archivo binario "puro" y extraer las imagenes que tiene adentro.
 * Se asume que vas a saber exactamente donde esta cada imagen dentro del binario
 */ 


@interface LvkBin2ImageHelper : NSObject {
	NSMutableArray *images;
}

//Toma el path del archivo binario y un arreglo de "rangos". Cada rango tiene 
// el offset y largo de la imagen. Inicializa el arreglo "images" con todas las 
//imagenes del binario
-(id)initWithPath:(NSString*)path ranges:(NSArray*)rangesarray;

@property(readonly) NSMutableArray *images;

@end
