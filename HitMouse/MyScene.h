//
//  MyScene.h
//  HitMouse
//

//  Copyright (c) 2014年 L了个G. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
typedef void (^AssetLoadCompletionHandler)();
@interface MyScene : SKScene
// 加载游戏素材
+ (void)loadSceneAssetsWithCompletionHandler:(AssetLoadCompletionHandler)callback;
@end
