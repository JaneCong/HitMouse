//
//  Mole.h
//  HitMouse
//
//  Created by L了个G on 14-8-12.
//  Copyright (c) 2014年 L了个G. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Mole : SKSpriteNode
// 隐藏时的y坐标
@property (assign ,nonatomic) CGFloat hiddenY;

+ (id)moleWithTexture:(SKTexture *)texture laughFrames:(NSArray *)laughFrames thumbFrames:(NSArray *)thumbFrames;

- (void)moveUp;

- (void)beThumbed;
@end
