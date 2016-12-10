//
//  MQVerCodeInputView.m
//  MQVerCodeInputView
//
//  Created by  林美齐 on 16/12/6.
//  Copyright © 2016年  林美齐. All rights reserved.
//

#import "MQVerCodeInputView.h"
#import "Masonry.h"
#import "UIView+MQ.h"

@interface MQVerCodeInputView ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *contairView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *viewArr;
@property (nonatomic, strong) NSMutableArray *labelArr;
@property (nonatomic, strong) NSMutableArray *pointlineArr;

@end

@implementation MQVerCodeInputView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultValue];
    }
    return self;
}

-(void)initDefaultValue{
    //初始化默认值
    self.maxLenght = 4;
    _viewColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1];
    _viewColorHL = [UIColor colorWithRed:255/255.0 green:70/255.0 blue:62/255.0 alpha:1];
    self.backgroundColor = [UIColor clearColor];
    [self beginEdit];
}

-(void)mq_verCodeViewWithMaxLenght{
    //创建输入验证码view
    if (_maxLenght<=0) {
        return;
    }
    if (_contairView) {
        [_contairView removeFromSuperview];
    }
    _contairView  = [UIView new];
    _contairView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contairView];
    [_contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    [_contairView addSubview:self.textView];
    //添加textView
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_contairView);
    }];
    
    CGFloat padding = (CGRectGetWidth(self.frame) -_maxLenght*CGRectGetHeight(self.frame))/(_maxLenght - 1);
    UIView *lastView;
    for (int i=0; i<self.maxLenght; i++) {
        UIView *subView = [UIView new];
        subView.backgroundColor = [UIColor whiteColor];
        subView.cornerRadius = 4;
        subView.borderWidth = (0.5);
        subView.userInteractionEnabled = NO;
        [_contairView addSubview:subView];
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.equalTo(lastView.mas_right).with.offset(padding);
            }else{
                make.left.equalTo(@(0));
            }
            make.centerY.equalTo(self.contairView);
            make.height.equalTo(self.contairView.mas_height);
            make.width.equalTo(self.contairView.mas_height);
            
        }];
        UILabel *subLabel = [UILabel new];
        subLabel.font = [UIFont systemFontOfSize:38];
        [subView addSubview:subLabel];
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(subView);
            make.centerY.equalTo(subView);
        }];
        lastView = subView;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake((CGRectGetHeight(self.frame)-2)/2,5,2,(CGRectGetHeight(self.frame)-10))];
        CAShapeLayer *line = [CAShapeLayer layer];
        line.path = path.CGPath;
        line.fillColor =  _viewColorHL.CGColor;
        [subView.layer addSublayer:line];
        if (i == 0) {//初始化第一个view为选择状态
            [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
            line.hidden = NO;
            subView.borderColor = _viewColorHL;
        }else{
            line.hidden = YES;
            subView.borderColor = _viewColor;
        }
        [self.viewArr addObject:subView];
        [self.labelArr addObject:subLabel];
        [self.pointlineArr addObject:line];
    }
    [_contairView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView?lastView.mas_right:@(0));
    }];
}

#pragma mark - TextView

-(void)beginEdit{
    [self.textView becomeFirstResponder];
}

-(void)endEdit{
    [self.textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSString *verStr = textView.text;
    //有空格去掉空格
    verStr = [verStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (verStr.length >= _maxLenght) {
        verStr = [verStr substringToIndex:_maxLenght];
        [self endEdit];
    }
    textView.text = verStr;

    if (self.block) {
        //将textView的值传出去
        self.block(verStr);
    }

    for (int i= 0; i < self.viewArr.count; i++) {
        //以text为中介区分
        UILabel *label = self.labelArr[i];
        if (i<verStr.length) {
            [self changeViewLayerIndex:i pointHidden:YES];
            label.text = [verStr substringWithRange:NSMakeRange(i, 1)];

        }else{
            [self changeViewLayerIndex:i pointHidden:i==verStr.length?NO:YES];
            if (!verStr&&verStr.length==0) {//textView的text为空的时候
                [self changeViewLayerIndex:0 pointHidden:NO];
            }
            label.text = @"";
        }
    }
}
- (void)changeViewLayerIndex:(NSInteger)index pointHidden:(BOOL)hidden{
    
    UIView *view = self.viewArr[index];
    view.borderColor = hidden?_viewColor:_viewColorHL;
    CAShapeLayer *line =self.pointlineArr[index];
    if (hidden) {
        [line removeAnimationForKey:@"kOpacityAnimation"];
    }else{
        [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
    }
    line.hidden = hidden;

}

- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 0.9;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}


#pragma mark --setter&&getter

-(void)setMaxLenght:(NSInteger)maxLenght{
    _maxLenght = maxLenght;
}

-(void)setKeyBoardType:(UIKeyboardType)keyBoardType{
    _keyBoardType = keyBoardType;
    self.textView.keyboardType = keyBoardType;
}

-(void)setViewColor:(UIColor *)viewColor{
    _viewColor = viewColor;
}

-(void)setViewColorHL:(UIColor *)viewColorHL{
    _viewColorHL = viewColorHL;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.tintColor = [UIColor clearColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.keyboardType = UIKeyboardTypeDefault;
    }
    return _textView;
}

-(NSMutableArray *)pointlineArr{
    if (!_pointlineArr) {
        _pointlineArr = [NSMutableArray new];
    }
    return _pointlineArr;
}
-(NSMutableArray *)viewArr{
    if (!_viewArr) {
        _viewArr = [NSMutableArray new];
    }
    return _viewArr;
}
-(NSMutableArray *)labelArr{
    if (!_labelArr) {
        _labelArr = [NSMutableArray new];
    }
    return _labelArr;
}

@end
