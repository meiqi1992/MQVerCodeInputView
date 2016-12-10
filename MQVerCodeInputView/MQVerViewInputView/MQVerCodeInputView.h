//
//  MQVerCodeInputView.h
//  MQVerCodeInputView
//
//  Created by  林美齐 on 16/12/6.
//  Copyright © 2016年  林美齐. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MQTextViewBlock)(NSString *text);

@interface MQVerCodeInputView : UIView

@property (nonatomic, assign) UIKeyboardType keyBoardType;
@property (nonatomic, copy) MQTextViewBlock block;

/*验证码的最大长度*/
@property (nonatomic, assign) NSInteger maxLenght;

/*未选中下的view的borderColor*/
@property (nonatomic, strong) UIColor *viewColor;

/*选中下的view的borderColor*/
@property (nonatomic, strong) UIColor *viewColorHL;

-(void)mq_verCodeViewWithMaxLenght;

@end
