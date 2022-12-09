@interface PLPlatterView : UIView
@end

@interface NCNotificationSummaryPlatterView : PLPlatterView
@property (nonatomic,retain) UIView *velvetView;
-(void)velvetUpdateStyle;
@end