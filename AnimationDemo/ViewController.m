//
//  ViewController.m
//  AnimationDemo
//
//  Created by wangliya on 2017/4/5.
//  Copyright © 2017年 wangliya. All rights reserved.
//

#import "ViewController.h"

#import "StaticView.h"

#define Size [[UIScreen mainScreen] bounds].size

@interface ViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) StaticView * staticView;
@property (nonatomic, assign) double getAddressTime;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) CAAnimationGroup * animationGroup;
@property (nonatomic, strong) NSMutableArray * layerArray;
@property (nonatomic, assign) int index;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    self.staticView = [StaticView new];
    self.staticView.backgroundColor = [UIColor clearColor];
    self.staticView.frame = self.view.frame;
    [self.view addSubview:self.staticView];
    
    //创建layer层数组
    self.layerArray = [NSMutableArray arrayWithCapacity:3];
    _index = 2;
    
    for(int i = 0; i < 3; i++)
    {
        CALayer * staticLayer = [[CALayer alloc] init];
        staticLayer.cornerRadius = 50;
        staticLayer.frame = CGRectMake(Size.width/2 - staticLayer.cornerRadius, Size.height/2 - staticLayer.cornerRadius, staticLayer.cornerRadius * 2, staticLayer.cornerRadius * 2);
        staticLayer.borderWidth = 1;
        staticLayer.borderColor = [UIColor redColor].CGColor;
        staticLayer.backgroundColor = [UIColor redColor].CGColor;
        [self.layerArray addObject:staticLayer];
        [self.view.layer addSublayer:staticLayer];
    }
    
    //通过定时器来实现不同图层动画的开始时间不同
    self.timer = [NSTimer timerWithTimeInterval:0.2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        [self startAnimation];
    }];
    [self.timer fire];
    
}

#pragma mark 懒加载

-(CAAnimationGroup *)animationGroup
{
    if(!_animationGroup)
    {
        /*
         CAMediaTimingFunction 速度控制函数
         kCAMediaTimingFunctionLinear（线性）：匀速，给你一个相对静态的感觉
         kCAMediaTimingFunctionEaseIn（渐进）：动画缓慢进入，然后加速离开
         kCAMediaTimingFunctionEaseOut（渐出）：动画全速进入，然后减速的到达目的地
         kCAMediaTimingFunctionEaseInEaseOut（渐近渐出）：动画缓慢的进入，中间加速，然后减速的到达目的地。这个是动画的默认行为
         kCAMediaTimingFunctionDefault（默认）：个人认为同上，过后试验
         */
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        self.animationGroup = [CAAnimationGroup animation];
        self.animationGroup.delegate = self;
        self.animationGroup.duration = 1.5;
        self.animationGroup.removedOnCompletion = YES;
        self.animationGroup.timingFunction = defaultCurve;
        self.animationGroup.autoreverses = NO;
//        self.animationGroup.repeatCount = MAXFLOAT;

        /*
         http://www.jianshu.com/p/02c341c748f9
         duration	动画的时长
         repeatCount	重复的次数。不停重复设置为 HUGE_VALF
         repeatDuration	设置动画的时间。在该时间内动画一直执行，不计次数。
         beginTime	指定动画开始的时间。从开始延迟几秒的话，设置为【CACurrentMediaTime() + 秒数】 的方式
         timingFunction	设置动画的速度变化
         autoreverses	动画结束时是否执行逆动画
         fromValue	所改变属性的起始值
         toValue	所改变属性的结束时的值
         byValue	所改变属性相同起始值的改变量
         
         解释：为什么动画结束后返回原状态？
         首先我们需要搞明白一点的是，layer动画运行的过程是怎样的？其实在我们给一个视图添加layer动画时，真正移动并不是我们的视图本身，而是 presentation layer 的一个缓存。动画开始时 presentation layer开始移动，原始layer隐藏，动画结束时，presentation layer从屏幕上移除，原始layer显示。这就解释了为什么我们的视图在动画结束后又回到了原来的状态，因为它根本就没动过。
         这个同样也可以解释为什么在动画移动过程中，我们为何不能对其进行任何操作。
         所以在我们完成layer动画之后，最好将我们的layer属性设置为我们最终状态的属性，然后将presentation layer 移除掉。
         
         使用总结:
         在动画执行完成之后，最好还是将动画移除掉。也就是尽量不要设置removedOnCompletion属性为NO
         fillMode尽量取默认值就好了，不要去设置它的值。只有在极个别的情况下我们会修改它的值，以后会说到，这里先占个坑。
         解决有时视图会闪动一下的问题，我们可以将layer的属性值设置为我们的动画最后要达到的值，然后再给我们的视图添加layer动画。
         
         一些常用的animationWithKeyPath值的总结:
         transform.scale	比例转化	@(0.8)
         transform.scale.x	宽的比例	@(0.8)
         transform.scale.y	高的比例	@(0.8)
         transform.rotation.x	围绕x轴旋转	@(M_PI)
         transform.rotation.y	围绕y轴旋转	@(M_PI)
         transform.rotation.z	围绕z轴旋转	@(M_PI)
         cornerRadius	圆角的设置	@(50)
         backgroundColor	背景颜色的变化	(id)[UIColor purpleColor].CGColor
         bounds	大小，中心不变	[NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
         position	位置(中心点的改变)	[NSValue valueWithCGPoint:CGPointMake(300, 300)];
         contents	内容，比如UIImageView的图片	imageAnima.toValue = (id)[UIImage imageNamed:@"to"].CGImage;
         opacity	透明度	@(0.7)
         contentsRect.size.width	横向拉伸缩放	@(0.4)最好是0~1之间的
         */
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
        scaleAnimation.fromValue = @1;
        scaleAnimation.toValue = @3;
        scaleAnimation.duration = 1.5;
//        scaleAnimation.repeatCount = MAXFLOAT;
        scaleAnimation.autoreverses = NO;
        
        /*
         CAKeyframeAnimation:
         是CApropertyAnimation的子类，跟CABasicAnimation的区别是：CABasicAnimation只能从一个数值(fromValue)变到另一个数值(toValue)，而CAKeyframeAnimation会使用一个NSArray保存这些数值
         
         属性解析：
         
         values：就是上述的NSArray对象。里面的元素称为”关键帧”(keyframe)。动画对象会在指定的时间(duration)内，依次显示values数组中的每一个关键帧
         
         path：可以设置一个CGPathRef\CGMutablePathRef,让层跟着路径移动。path只对CALayer的anchorPoint和position起作用。如果你设置了path，那么values将被忽略(注意区分path与keyPath)
         
         keyTimes：可以为对应的关键帧指定对应的时间点,其取值范围为0到1.0,keyTimes中的每一个时间值都对应values中的每一帧.当keyTimes没有设置的时候,各个关键帧的时间是平分的
         
         说明：CABasicAnimation可看做是最多只有2个关键帧的CAKeyframeAnimation
         keyPath可以使用的key
         transform.rotation.x 围绕x轴翻转 参数：角度 angle2Radian(4)
         transform.rotation.y 围绕y轴翻转 参数：同上
         transform.rotation.z 围绕z轴翻转 参数：同上
         transform.rotation 默认围绕z轴
         transform.scale.x x方向缩放 参数：缩放比例 1.5
         transform.scale.y y方向缩放 参数：同上
         transform.scale.z z方向缩放 参数：同上
         transform.scale 所有方向缩放 参数：同上
         transform.translation.x x方向移动 参数：x轴上的坐标 100
         transform.translation.y x方向移动 参数：y轴上的坐标
         transform.translation.z x方向移动 参数：z轴上的坐标
         transform.translation 移动 参数：移动到的点 （100，100）
         opacity 透明度 参数：透明度 0.5
         backgroundColor 背景颜色 参数：颜色 (id)[[UIColor redColor] CGColor]
         cornerRadius 圆角 参数：圆角半径 5
         borderWidth 边框宽度 参数：边框宽度 5
         bounds 大小 参数：CGRect
         contents 内容 参数：CGImage
         contentsRect 可视内容 参数：CGRect 值是0～1之间的小数
         hidden 是否隐藏
         position
         shadowColor
         shadowOffset
         shadowOpacity
         shadowRadius
         */
        
        CAKeyframeAnimation * opencityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opencityAnimation.duration = 1.5;
        opencityAnimation.values = @[@1,@0];
        opencityAnimation.keyTimes = @[@0,@1];
        opencityAnimation.removedOnCompletion = YES;
        opencityAnimation.autoreverses = NO;
//        opencityAnimation.repeatCount = MAXFLOAT;
        
        NSArray * animations = @[scaleAnimation,opencityAnimation];
        _animationGroup.animations = animations;
    }
    return _animationGroup;
}


#pragma mark 动画
//开始动画
-(void)startAnimation
{
    
    CALayer * layer = self.layerArray[(++_index)%3];
    [layer addAnimation:self.animationGroup forKey:@"groupAnimation"];
    [self.view bringSubviewToFront:self.staticView];
    [self performSelector:@selector(startAnimation) withObject:nil afterDelay:0.5];
    
}

-(void)dealloc
{
    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
