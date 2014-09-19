//
//  MyScene.m
//  HitMouse
//
//  Created by L了个G on 14-8-12.
//  Copyright (c) 2014年 L了个G. All rights reserved.
//

#import "MyScene.h"
#import "SKTextureAtlas+Helper.h"
#import "Mole.h"
static long steps;
@interface MyScene ()
{
    NSArray        *_moles;
    SKLabelNode    *_scoreLabel;
    NSInteger      _score;
    SKLabelNode    *_timerLabel;
    NSDate         *_startTime;
}
@end
@implementation MyScene

// 所有纹理的静态变量,在加载中赋值
static SKTexture *sSharedDirtTexture = nil;
static SKTexture *sShareUpperTexture = nil;
static SKTexture *sShareLowerTexture = nil;
static SKTexture *sShareMoleTexture  = nil;
static NSArray   *sShareMoleLaughFrames = nil;
static NSArray   *sShareMoleThumbFrames = nil;
- (void)setupUI
{
    CGPoint center = CGPointMake(self.size.width / 2.0, self.size.height / 2.0);
    // 1.设置背景
    SKSpriteNode *dirt = [SKSpriteNode spriteNodeWithTexture:sSharedDirtTexture];
    dirt.position = center;
    // 设置图片的缩放比例
    [dirt setScale:2.0f];
    [self addChild:dirt];
    SKSpriteNode *upper = [SKSpriteNode spriteNodeWithTexture:sShareUpperTexture];
    upper.anchorPoint = CGPointMake(0.5, 0);
    upper.position = center;
    [self addChild:upper];

    SKSpriteNode *lower = [SKSpriteNode spriteNodeWithTexture:sShareLowerTexture];
    lower.anchorPoint = CGPointMake(0.5, 1.0);
    lower.position = center;
    lower.zPosition = 2;
    [self addChild:lower];
    
    // 增加得分标签
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.text = @"Score : 0";
    scoreLabel.fontSize = 14;
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.position = CGPointMake(20, 20);
    scoreLabel.zPosition = 3;
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _scoreLabel = scoreLabel;
    [self addChild:scoreLabel];
    
    // 增加时间标签
    SKLabelNode *timerLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    timerLabel.text = @"00 : 00 :00";
    timerLabel.fontSize = 14;
    timerLabel.fontColor = [SKColor whiteColor];
    timerLabel.position = CGPointMake(self.size.width - 20, self.size.height - 20 - 14);
    timerLabel.zPosition = 3;
    timerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    _timerLabel = timerLabel;
    [self addChild:timerLabel];
}
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        [self setupUI];
        [self loadMoles];
        [self setUpMoles];
        _startTime = [NSDate date];
    
    }
    return self;
}

#pragma mark 加载地鼠


- (void)loadMoles
{

    
    // 存放到数组
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger i = 0; i < 3; i ++) {
        
        Mole *mole = [Mole moleWithTexture:sShareMoleTexture laughFrames:sShareMoleLaughFrames thumbFrames:sShareMoleThumbFrames];
        
        [arrayM addObject:mole];
    }
    _moles = arrayM;
}

#pragma mark 设置地鼠的位置
- (void)setUpMoles
{
    CGFloat xOffset = 155.0;
    CGPoint startPoint = CGPointMake(self.size.width / 2.0 - xOffset, self.size.height / 2.0 - 80);
   
    [_moles enumerateObjectsUsingBlock:^(Mole *mole, NSUInteger idx, BOOL *stop) {
       
        CGPoint p = CGPointMake(startPoint.x + idx * xOffset, startPoint.y);
        
        mole.position = p;
        mole.hiddenY  = p.y;
        [self addChild:mole];
        }];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    // 获取到打到的地鼠
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    // 取出用户点击的节点
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"mole"]) {
        Mole *mole = (Mole *)node;
        [mole beThumbed];
        
        _score += 10;
        _scoreLabel.text = [NSString stringWithFormat:@"score:%d",_score];
        
    }
}
#pragma mark 屏幕每次刷新时调用,不需要再自己指定时钟了
-(void)update:(NSTimeInterval)currentTime
{
    steps++;
    
    NSInteger dt = [[NSDate date] timeIntervalSinceDate:_startTime];
    NSString *timeStr = [NSString stringWithFormat:@"%02d:%02d:%02d",dt / 3600,(dt%3600) / 60,dt % 60];
    _timerLabel.text = timeStr;
    NSInteger seed = _score / 50;
    seed = (seed > 15) ? 15 : seed ;
    if (steps % (20 - seed) == 0) {
        NSInteger num = arc4random_uniform(3);
        Mole *mole = _moles[num];
        [mole moveUp];
    }

}

+ (void)loadSceneAssets
{

    // 加载所需要的素材
    // 1.背景
    SKTextureAtlas *atlas = [SKTextureAtlas atlasWithNamed:@"background"];
    sSharedDirtTexture  = [atlas textureNamed:@"bg_dirt"];
    // 2.设置草地
    // 2.1上面的草
    SKTextureAtlas *foreAtlas = [SKTextureAtlas atlasWithNamed:@"foreground"];
    sShareUpperTexture = [foreAtlas textureNamed:@"grass_upper"];
    // 2.2下面的草
    sShareLowerTexture = [foreAtlas textureNamed:@"grass_lower"];
    // 3.加载地鼠的纹理图片
    SKTextureAtlas *moleAtlas = [SKTextureAtlas atlasWithNamed:@"sprites"];
    sShareMoleTexture  = [moleAtlas textureNamed:@"mole_1"];
    // 4.
    sShareMoleLaughFrames = @[[moleAtlas textureNamed:@"mole_laugh1"],
                              [moleAtlas textureNamed:@"mole_laugh2"],
                              [moleAtlas textureNamed:@"mole_laugh3"]];
    // 5.
    sShareMoleThumbFrames = @[[moleAtlas textureNamed:@"mole_thump1"],
                              [moleAtlas textureNamed:@"mole_thump2"],
                              [moleAtlas textureNamed:@"mole_thump3"],
                              [moleAtlas textureNamed:@"mole_thump4"]];

    
}
#pragma mark 统一加载素材,完成后回调
+(void)loadSceneAssetsWithCompletionHandler:(AssetLoadCompletionHandler)callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadSceneAssets];
        
        if (callback) {
            
            // 需要在主线程队列上执行
            dispatch_async(dispatch_get_main_queue(), ^{
                 callback();
                
            });
           
        }
    });
}
@end
