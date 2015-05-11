//
//  ViewController.m
//  OrigamiAnimationTest
//
//  Created by Akring on 15/5/11.
//  Copyright (c) 2015年 Akring. All rights reserved.
//

#import "ViewController.h"
#import <POP/POP.h>
#import <POP/POPLayerExtras.h>

@interface ViewController (){
    
    BOOL scaled;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) CGFloat popAnimationProgress;

@property (strong, nonatomic) UITapGestureRecognizer *tap;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scaled = NO;
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                   action:@selector(tapHandler)];
    
    //开启imageView的用户交互选项，否则imageView不会响应手势
    self.imageView.userInteractionEnabled = YES;
    
    [self.imageView addGestureRecognizer:_tap];
}


- (void)tapHandler{
    
    if (scaled) {
        
        [self togglePopAnimation:NO];
        
        scaled = !scaled;
    }
    else{
        
        [self togglePopAnimation:YES];
        
        scaled = !scaled;
    }
}

// popAnimation transition

- (void)togglePopAnimation:(BOOL)on {
    POPSpringAnimation *animation = [self pop_animationForKey:@"popAnimation"];
    
    if (!animation) {
        animation = [POPSpringAnimation animation];
        animation.springBounciness = 10;
        animation.springSpeed = 6;
        animation.property = [POPAnimatableProperty propertyWithName:@"popAnimationProgress" initializer:^(POPMutableAnimatableProperty *prop) {
            prop.readBlock = ^(ViewController *obj, CGFloat values[]) {
                values[0] = obj.popAnimationProgress;
            };
            prop.writeBlock = ^(ViewController *obj, const CGFloat values[]) {
                obj.popAnimationProgress = values[0];
            };
            prop.threshold = 0.001;
        }];
        
        [self pop_addAnimation:animation forKey:@"popAnimation"];
    }
    
    animation.toValue = on ? @(1.0) : @(0.0);
}

- (void)setPopAnimationProgress:(CGFloat)progress {
    _popAnimationProgress = progress;
    
    CGFloat transition1 = POPTransition(progress, 0, 360);
    POPLayerSetRotationZ(self.imageView.layer, POPDegreesToRadians(transition1));
    
    CGFloat transition2 = POPTransition(progress, 1, 2);
    POPLayerSetScaleXY(self.imageView.layer, CGPointMake(transition2, transition2));
}

// Utilities

static inline CGFloat POPTransition(CGFloat progress, CGFloat startValue, CGFloat endValue) {
    return startValue + (progress * (endValue - startValue));
}

static inline CGFloat POPDegreesToRadians(CGFloat degrees) {
    return M_PI * (degrees / 180.0);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
