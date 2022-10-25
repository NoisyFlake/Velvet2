@interface NCNotificationViewController : UIViewController
@property (nonatomic,retain) NCNotificationRequest * notificationRequest;
@end

@interface NCNotificationShortLookView : UIView
@property (nonatomic,readonly) MTMaterialView * backgroundMaterialView;
@end

@interface NCNotificationShortLookViewController : NCNotificationViewController
@property (nonatomic,readonly) UIView * viewForPreview;
@property (nonatomic,retain) UIView *borderView;
@property (nonatomic,retain) UIView *shadowView;
@end