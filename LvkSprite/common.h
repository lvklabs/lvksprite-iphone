/*
 *  common.h
 *  igirl
 *
 *  Created by Mario Tambos on 7/4/10.
 *  Copyright 2010 LavandaInk. All rights reserved.
 *
 */

#define LKLOG(...) NSLog(__VA_ARGS__)
#define	SecureRelease(x) {id tmpX = x; x = nil; if(tmpX != nil){[tmpX release];}}
