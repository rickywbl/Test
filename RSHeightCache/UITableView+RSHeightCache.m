//
//  UITableView+RSHeightCache.m
//  TableViewHeightCache
//
//  Created by 王保霖 on 2016/12/1.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "UITableView+RSHeightCache.h"
#import <objc/runtime.h>
@class RSHeightCache;

@implementation UITableView (RSHeightCache)

-(RSHeightCache *)rs_heightCache{
    
    RSHeightCache *cache = objc_getAssociatedObject(self, _cmd);
    
    if(cache == nil){
        
        objc_setAssociatedObject(self, @selector(rs_heightCache),cache, OBJC_ASSOCIATION_RETAIN);
    }
    
    return cache;
}

//从复用池中返回计算的cell

-(__kindof UITableViewCell *)rs_BindingCellWithIdentifier:(NSString *)identifier{

    if(!identifier.length){
    
        return nil;
    }
    
    NSMutableDictionary <NSString *,UITableViewCell *>  *DicForTheUniqueCalCell  = objc_getAssociatedObject(self, _cmd);
    if(!DicForTheUniqueCalCell){
    
        DicForTheUniqueCalCell = [NSMutableDictionary dictionary];
        
        objc_setAssociatedObject(self, _cmd, DicForTheUniqueCalCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UITableViewCell * cell = DicForTheUniqueCalCell[identifier];
    
    if(!cell){
    
        cell = [self dequeueReusableCellWithIdentifier:identifier];
        
        cell.contentView.translatesAutoresizingMaskIntoConstraints = NO; //???
        
        cell.JustForCal = YES;

        cell.NoAutoSizing = NO;
        
        DicForTheUniqueCalCell[identifier] = cell;
        
    }
    
    
    return cell;
    
}



-(CGFloat)rs_calculateCellWithIdentifier:(NSString *)identifier configuration:(void(^)(id cell))configuration{

    if(!identifier.length){
    
        return 0;
    }
    
    UITableViewCell * cell = [self rs_BindingCellWithIdentifier:identifier];
    
    [cell prepareForReuse];
    
    if(configuration){
    
        configuration(cell);
    }
    
    return [self rs_CalculateCellHeightWithCell:cell];
    
}


- (CGFloat)rs_heightForCellWithIdentifier:(NSString *)identifier cacheByKey:(id<NSCopying>)key configuration:(void (^)(id cell))configuration{

    if(!identifier|| !key){
    
        return 0;
    }
    
    if([self.rs_heightCache rs_existsHeightForKey:key]){
    
        return [self.rs_heightCache rs_heightForKey:key];
    }
    
    
    CGFloat height = [self rs_calculateCellWithIdentifier:identifier configuration:configuration];
    
    [self.rs_heightCache rs_cacheHeight:height byKey:key];
    
    return height;
    
    

}


-(CGFloat)rs_CalculateCellHeightWithCell:(UITableViewCell *)cell{

    
    CGFloat width = self.bounds.size.width;
    
    if(cell.accessoryView){
    
        width -= cell.accessoryView.bounds.size.width + 16;
    }
    else
    {
        static const CGFloat accessoryWidth[] = {
            [UITableViewCellAccessoryNone] = 0,
            [UITableViewCellAccessoryDisclosureIndicator] = 34,
            [UITableViewCellAccessoryDetailDisclosureButton] = 68,
            [UITableViewCellAccessoryCheckmark] = 40,
            [UITableViewCellAccessoryDetailButton] = 48
        };
        width -= accessoryWidth[cell.accessoryType];
    }
    
    
    CGFloat height = 0;
    
        
    
    
    if(!cell.NoAutoSizing && width > 0){
        
        NSLayoutConstraint * widthConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width];//创建约束
        [cell.contentView addConstraint:widthConstraint];//添加约束
        height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;//计算高度
        [cell.contentView removeConstraint:widthConstraint];//移除约束
        
    }
    
    if (height == 0) { //如果约束错误可能导致计算结果为零，则以自适应模式再次计算
        
        height = [cell sizeThatFits:CGSizeMake(width, 0)].height;
        
    }
    if (height == 0) {//如果计算仍然为0，则给出默认高度
        
        height = 44;
    }
    if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {//如果不为无分割线模式则添加分割线高度
        height += 1.0 /[UIScreen mainScreen].scale;
    }
    return height;
    
}


@end



@implementation RSHeightCache

//判断缓存是否存在
-(BOOL)rs_existsHeightForKey:(id <NSCopying>)key{

    NSNumber *number = self.dicHeightCurrent[key];

    return number && ![number isEqualToNumber:@-1];
}


//添加缓存

-(void)rs_cacheHeight:(CGFloat)height byKey:(id<NSCopying>)key{


    self.dicHeightCurrent[key] = @(height);
}


-(CGFloat)rs_heightForKey:(id<NSCopying>)key{
    
#if CGFLOAT_IS_DOUBLE
    return [self.dicHeightCurrent[key] doubleValue];
#else
    return [self.dicHeightCurrent[key] floatValue];
#endif
    
}


-(void)rs_removeHeightForKey:(id<NSCopying>)key{

    [self.dicHeightCacheV removeObjectForKey:key];
    [self.dicHeightCacheH removeObjectForKey:key];
}

-(void)rs_removeAllHeightCache{

    [self.dicHeightCacheH removeAllObjects];
    [self.dicHeightCacheV removeAllObjects];
}



#pragma mark --- 懒加载

-(NSMutableDictionary *)dicHeightCacheH{
    
    if(_dicHeightCacheH == nil){
        
        _dicHeightCacheH = [[NSMutableDictionary alloc] init];;
    }
    
    return _dicHeightCacheH;
}


-(NSMutableDictionary *)dicHeightCacheV{
    
    if(_dicHeightCacheV == nil){
        
        _dicHeightCacheV = [[NSMutableDictionary alloc] init];;
    }
    
    return _dicHeightCacheV;
}

-(NSMutableDictionary *)dicHeightCurrent{
    
    return UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)?self.dicHeightCacheV:self.dicHeightCacheH;
}


@end



@implementation UITableViewCell (HeightCacheCell)


-(BOOL)NoAutoSizing{
    
    /*
     objc_getAssociatedObject(id object, const void *key)
     
     1.object:绑定目标 这里是自己
     2.key :关键字  _cmd代表的是本方法名这里就是NoAutoSizing
     
     */
    
    return  [objc_getAssociatedObject(self, _cmd) boolValue];
}


-(void)setNoAutoSizing:(BOOL)NoAutoSizing{
    
    /*
     objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
     
     1.object: 绑定目标 这里是自己
     2.key :关键字
     3.value : 绑定者
     4.policy :策略
     
     */
    
    objc_setAssociatedObject(self, @selector(NoAutoSizing), @(NoAutoSizing), OBJC_ASSOCIATION_RETAIN);
}


-(BOOL)JustForCal
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}


-(void)setJustForCal:(BOOL)JustForCal
{
    objc_setAssociatedObject(self, @selector(JustForCal), @(JustForCal), OBJC_ASSOCIATION_RETAIN);
}

@end

