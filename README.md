# MQVerCodeInputView

1. 使用方法
```
    MQVerCodeInputView *verView = [[MQVerCodeInputView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-50, 50)];
    verView.maxLenght = 6;//最大长度
    verView.keyBoardType = UIKeyboardTypeNumberPad;
    [verView mq_verCodeViewWithMaxLenght];
    verView.block = ^(NSString *text){
        NSLog(@"text = %@",text);
    };
    verView.center = self.view.center;
    [self.view addSubview:verView];

```
2.效果图如下：



