
#import <Foundation/Foundation.h>

@interface ViewHolder : NSObject

@property (nonatomic, assign) CGRect rect;
@property (nonatomic, retain) UIView *view;
@property (nonatomic, assign) NSInteger layerIndex;
@property (nonatomic, assign) uint64_t superView;

@end
