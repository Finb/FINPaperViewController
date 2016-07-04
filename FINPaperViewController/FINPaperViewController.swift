//
//  FINPaperViewController.swift
//  FINPaperViewControllerExample
//
//  Created by huangfeng on 16/6/22.
//  Copyright © 2016年 Fin. All rights reserved.
//

import UIKit

class FINPaperViewController: UIViewController,UICollectionViewDataSource {
    
    private var viewFrame:CGRect { get{ return self.view.frame } }
    private var viewWidth:CGFloat { get{ return self.view.frame.width } }
    private var viewHeight:CGFloat { get{ return self.view.frame.height } }
    private var viewThirdHeight:CGFloat { get{ return self.view.frame.height / 3 } }
    
    var containerView:UIView!
    var rotationView:FINRotationView!
    
    var images:[UIImage]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    func setup(){
        let backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = UIImage(named: "DefaultBackground")
        self.view.addSubview(backgroundImageView)
        
        images.append(UIImage(named: "SectionCoverDesign@2x.jpg")!)
        images.append(UIImage(named: "SectionCoverFamily@2x.jpg")!)
        images.append(UIImage(named: "SectionCoverFoodie@2x.jpg")!)
        images.append(UIImage(named: "SectionCoverFunny@2x.jpg")!)
        images.append(UIImage(named: "SectionCoverLGBTQ@2x.jpg")!)
        images.append(UIImage(named: "SectionCoverSports@2x.jpg")!)
        images.append(UIImage(named: "SectionCoverStreet@2x.jpg")!)
        images.append(UIImage(named: "SectionCoverStyles@2x.jpg")!)
        images.append(UIImage(named: "SectionCoverTechnology@2x.jpg")!)
        images.append(UIImage(named: "SectionCoverIdeas@2x.jpg")!)
        
        
        self.containerView = UIView()
        self.containerView.frame = self.viewFrame
        self.view.addSubview(self.containerView)
        
        self.rotationView = FINRotationView(frame: CGRectMake(0, self.viewHeight - self.viewThirdHeight , self.viewWidth, self.viewThirdHeight))
        self.rotationView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.05)
        self.containerView.addSubview(self.rotationView)
        self.rotationView.dataSource = self;
        self.rotationView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell");
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.whiteColor()
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        
        if(cell.contentView.subviews.count <= 0){
            let imageView = UIImageView(image: images[indexPath.row])
            imageView.contentMode = .ScaleAspectFill
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.mainScreen().scale
            cell.addSubview(imageView)
            imageView.frame = CGRectMake(0, 0, ceil(UIScreen.mainScreen().bounds.size.width/2.4), ceil(UIScreen.mainScreen().bounds.size.height/2.4/1.5))
        }
        
        return cell;
    }
}
