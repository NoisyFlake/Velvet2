@interface NCHitTestTransparentView : UIView
@end

@interface NCNotificationViewControllerView : NCHitTestTransparentView {
	UIView* _stackDimmingView;
}
@end

@interface NCNotificationViewController : UIViewController {
    UIView* _contentSizeManagingView;
}
@property (nonatomic,retain) NCNotificationRequest * notificationRequest;
@end

@interface NCBadgedIconView : UIView
@property (nonatomic,retain) UIView * iconView;
@end

@interface NCNotificationSeamlessContentView : UIView {
	UILabel* _primaryTextLabel;
	UIView* _secondaryTextElement;
	UILabel* _dateLabel;
	NCBadgedIconView* _badgedIconView;
}
@property (nonatomic,copy) UIImage * prominentIcon;
@property (nonatomic,copy) UIImage * subordinateIcon;
@end

@interface NCNotificationShortLookView : UIView {
    NCNotificationSeamlessContentView* _notificationContentView;
}
@property (nonatomic,readonly) MTMaterialView * backgroundMaterialView;
@end

@interface NCNotificationShortLookViewController : NCNotificationViewController
@property (nonatomic,readonly) UIView * viewForPreview;
@property (nonatomic,retain) UIView *velvetView;
-(void)velvetUpdateStyle;
@end

@interface NCNotificationStructuredListViewController : UIViewController
@end

@interface NCNotificationSummaryContentView : UIView
@end