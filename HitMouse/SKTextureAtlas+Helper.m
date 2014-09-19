//
//  SKTextureAtlas+Helper.m
//  HitMouse
//
//  Created by L了个G on 14-8-12.
//  Copyright (c) 2014年 L了个G. All rights reserved.
//

#import "SKTextureAtlas+Helper.h"

@implementation SKTextureAtlas (Helper)
+ (SKTextureAtlas *)atlasWithNamed:(NSString *)atlasName
{
    if (IS_IPAD) {
        atlasName = [NSString stringWithFormat:@"%@-ipad",atlasName];
    }else if (IS_IPHONE_5)
    {
        atlasName = [NSString stringWithFormat:@"%@-568",atlasName];
    }
    
    return [SKTextureAtlas atlasNamed:atlasName];
}
@end
