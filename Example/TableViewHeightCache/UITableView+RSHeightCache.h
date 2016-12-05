//
//  UITableView+RSHeightCache.h
//  TableViewHeightCache
//
//  Created by 王保霖 on 2016/12/1.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RSHeightCache;

@interface UITableView (RSHeightCache)

@property (strong, nonatomic,readonly) RSHeightCache * rs_heightCache;

- (CGFloat)rs_heightForCellWithIdentifier:(NSString *)identifier cacheByKey:(id<NSCopying>)key configuration:(void (^)(id cell))configuration;

@end



@interface RSHeightCache : NSObject

@property (strong ,nonatomic)NSMutableDictionary * dicHeightCacheV;//竖直行高缓存字典
@property (strong ,nonatomic)NSMutableDictionary * dicHeightCacheH;//水平行高缓存字典
@property (strong ,nonatomic)NSMutableDictionary * dicHeightCurrent;//当前状态行高缓存字典（中间量）
-(BOOL)rs_existsHeightForKey:(id <NSCopying>)key;
- (void)rs_cacheHeight:(CGFloat)height byKey:(id<NSCopying>)key;
- (CGFloat)rs_heightForKey:(id<NSCopying>)key;
-(void)rs_removeHeightForKey:(id<NSCopying>)key;
-(void)rs_removeAllHeightCache;

@end


@interface UITableViewCell (HeightCacheCell)

//计算用的cell的标识.
@property (assign, nonatomic) BOOL JustForCal;
//不适应autosizing的标识符
@property (assign, nonatomic) BOOL NoAutoSizing;

@end


