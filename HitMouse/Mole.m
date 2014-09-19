//
//  Mole.m
//  HitMouse
//
//  Created by L了个G on 14-8-12.
//  Copyright (c) 2014年 L了个G. All rights reserved.
//

#import "Mole.h"
@interface Mole ()
{
    BOOL    _isThumbed;
}
@property (strong ,nonatomic) SKAction *laughAction;

@property (strong ,nonatomic) SKAction *thumpAction;
@end

@implementation Mole
+(id)moleWithTexture:(SKTexture *)texture laughFrames:(NSArray *)laughFrames thumbFrames:(NSArray *)thumbFrames
{
    Mole *mole = [Mole spriteNodeWithTexture:texture];
    mole.zPosition = 1;

    SKAction *laugh      = [SKAction animateWithTextures:laughFrames timePerFrame:0.1f];
    SKAction *laughSound = [SKAction playSoundFileNamed:@"laugh.caf" waitForCompletion:NO];
    mole.laughAction     = [SKAction group:@[laugh,laughSound]];
    SKAction *thumb      = [SKAction animateWithTextures:thumbFrames timePerFrame:0.1f];
    SKAction *thumbSound = [SKAction playSoundFileNamed:@"ow.caf" waitForCompletion:NO];
    mole.thumpAction     = [SKAction group:@[thumb,thumbSound]];
    mole.name            = @"mole";
    return mole;
}

#pragma mark 地鼠的动画
- (void)moveUp

{
    
    if ([self hasActions])
        return;
    
    // 1.先出来
    SKAction *moveUp   = [SKAction moveToY:self.position.y + self.size.height duration:0.2];
    [moveUp setTimingMode:SKActionTimingEaseOut];
    // 2.等0.5秒
    SKAction *delay    = [SKAction waitForDuration:0.5f];
    // 3.再藏起来
    SKAction *moveDown = [SKAction moveToY:_hiddenY duration:0.2];
    [moveDown setTimingMode:SKActionTimingEaseIn];

    SKAction *sequence = [SKAction sequence:@[moveUp,self.laughAction,delay,moveDown]];

    [self runAction:sequence];
}

#pragma mark 地鼠被打了
- (void)beThumbed
{
    if (_isThumbed) return;

    _isThumbed         = YES;
    // 1.删除所有的Action
    [self removeAllActions];

    // 2.创建新的Action
    // 2.1移动到下面
    SKAction *moveDown = [SKAction moveToY:_hiddenY duration:0.2];
    [moveDown setTimingMode:SKActionTimingEaseIn];

    SKAction *sequence = [SKAction sequence:@[self.thumpAction,moveDown]];
    [self runAction:sequence completion:^{
    _isThumbed         = NO;
    }];
}
@end
