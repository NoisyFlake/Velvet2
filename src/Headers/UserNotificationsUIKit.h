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

@interface NCNotificationSeamlessContentView : UIView
@end

@interface NCNotificationShortLookView : UIView {
    NCNotificationSeamlessContentView* _notificationContentView;
}
@property (nonatomic,readonly) MTMaterialView * backgroundMaterialView;
@end

@interface NCNotificationShortLookViewController : NCNotificationViewController
@property (nonatomic,readonly) UIView * viewForPreview;
@property (nonatomic,retain) UIView *borderView;
@end