//
//  ViewController.m
//  HitMouse
//
//  Created by L了个G on 14-8-12.
//  Copyright (c) 2014年 L了个G. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    SKView * skView       = (SKView *)self.view;

    if (!skView.scene) {
        // 统一加载游戏素材
        [MyScene loadSceneAssetsWithCompletionHandler:^{

            // 关闭指示器

            // 展现场景
            // Create and configure the scene.
    SKScene * scene       = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode       = SKSceneScaleModeAspectFill;

            // Present the scene.
            [skView presentScene:scene];
        }];

        // 用于显示指示器
    skView.showsFPS       = YES;
    skView.showsNodeCount = YES;


    }
}



- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
