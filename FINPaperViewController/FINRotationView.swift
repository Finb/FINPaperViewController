//
//  FINRotationView.swift
//  FINPaperViewControllerExample
//
//  Created by huangfeng on 16/6/22.
//  Copyright © 2016年 Fin. All rights reserved.
//

import UIKit

class FINRotationFlowLayout: UICollectionViewFlowLayout {
    private var collectionViewWidth:CGFloat { get{ return self.collectionView?.frame.width ?? 0 } }
    
    var dynamicAnimator:UIDynamicAnimator!
    override init() {
        super.init()
        self.setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
        self.scrollDirection = .Horizontal;
        
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        self.itemSize = CGSizeMake(ceil(width/2.4), ceil(height/2.4/1.5))

        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        self.collectionView?.contentInset = UIEdgeInsetsMake(0, collectionViewWidth/2 - self.itemSize.width / 2, 0,  collectionViewWidth / 2)
        let visibleRect = CGRect(origin: CGPointZero, size: super.collectionViewContentSize())
        guard let itemsInVisibleRectArray = super.layoutAttributesForElementsInRect(visibleRect) else {
            return;
        }
        
        if(self.dynamicAnimator.behaviors.count == 0){
            itemsInVisibleRectArray.forEach { (item) in
                item.zIndex = self.dynamicAnimator.behaviors.count
                let behaviour = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
                behaviour.length = 0
                behaviour.damping = 1
                behaviour.frequency = 1
                self.dynamicAnimator.addBehavior(behaviour)
            }

        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attribs = self.dynamicAnimator.itemsInRect(rect) as! [UICollectionViewLayoutAttributes]

        for attributes in attribs {
            if (CGRectIntersectsRect(attributes.frame, rect)){
                let cardX = attributes.center.x;
                let distance =  self.collectionView!.contentOffset.x + self.collectionView!.bounds.size.width / 2;
                let computedOffset = cardX  - distance;

                var fraction = computedOffset / attributes.bounds.size.width;
                fraction = self.allowedRadian(fraction)
                let radian = fraction * 0.15
                var t  = self.transformFromFraction(radian);
                
                //利用三角函数计算偏移高度， a b c 为三角形的三条边
                let computedRadian = fabs(radian)
                let a = abs(computedOffset)
                let c = a / cos(computedRadian)
                let b = sin(computedRadian) * c
                let d = c - b
                var e = d * b / c
                if(c == 0){ //如果c为0，则设置e为0，不然e 为无穷大，会产生错误
                    e = 0
                }

                t = CATransform3DTranslate(t, 0, e * 0.68 + 50 , 0);
                
                attributes.transform3D = t;
            }
        }
        
        return attribs
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.dynamicAnimator.layoutAttributesForCellAtIndexPath(indexPath)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        let scrollView = self.collectionView
        let delta = newBounds.origin.x - scrollView!.bounds.origin.x
        
        let touchLocation = self.collectionView!.panGestureRecognizer.locationInView(self.collectionView)
        
        self.dynamicAnimator.behaviors.forEach { (item) in
            let item = item as! UIAttachmentBehavior
            let xDistanceFromTouch = fabs(touchLocation.x - item.anchorPoint.x)
            
            let scrollResistance = xDistanceFromTouch / 1500
            
            let itemAttr = item.items.first!
            var center = itemAttr.center
            if (delta < 0) {
                center.x += max(delta, delta * scrollResistance)
            }
            else{
                center.x += min(delta, delta * scrollResistance)
            }
            
            itemAttr.center = center
            
            self.dynamicAnimator.updateItemUsingCurrentState(itemAttr)
        }
        
        
        return false
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let rect = CGRect(origin: proposedContentOffset, size: self.collectionView!.bounds.size)
        guard let array = super.layoutAttributesForElementsInRect(rect) else {
            return CGPointZero
        }

        let centerX = proposedContentOffset.x + self.collectionView!.bounds.size.width / 2

        var minDistance:CGFloat = CGFloat(MAXFLOAT);
        for attr in array {
            if(abs(minDistance) > abs(attr.center.x - centerX)){
                minDistance = attr.center.x - centerX;
            }
        }
        
        return CGPointMake(proposedContentOffset.x + minDistance , proposedContentOffset.y);
        
    }
    
    func allowedRadian(angle:CGFloat) -> CGFloat {
        var angle = Double(angle)
        if(angle > M_PI / 2){
            angle = M_PI/2;
        }else if (angle < (-1 * M_PI/2)){
            angle = -1 * M_PI / 2;
        }
        return CGFloat(angle);
    }
    
    func transformFromFraction(radian:CGFloat) -> CATransform3D {
        var t = CATransform3DIdentity;
        t.m34 = 1.0 / -500;
        t = CATransform3DRotate(t, radian, 0, 0, 1);
        return t;
    }
    
}

class FINRotationView: UICollectionView {
    init(frame:CGRect){
        super.init(frame: frame, collectionViewLayout: FINRotationFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
