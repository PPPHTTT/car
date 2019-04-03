//
//  toolfuncs.swift
//  Robot
//
//  Created by Hunter on 2019/3/14.
//  Copyright © 2019 Hunter. All rights reserved.
//

import UIKit
import AVFoundation


class toolfuncs: NSObject {
    let WSCALE = UIScreen.main.bounds.width/750 //ratio
    let HSCALE = UIScreen.main.bounds.height/1792 //ratio
    
    
    
    func defConstraints(_ target:UIView,_ toItem:UIView?,_ top:CGFloat?,_ bottom:CGFloat?,_ left:CGFloat?,_ right:CGFloat?){
        target.translatesAutoresizingMaskIntoConstraints = false
        var toView:UIView = target.superview!
        if toItem != nil {
            toView = toItem!
        }
        if left != nil {
            let leftC:NSLayoutConstraint = NSLayoutConstraint(item: target, attribute: NSLayoutConstraint.Attribute.left, relatedBy:NSLayoutConstraint.Relation.equal, toItem:toView, attribute:NSLayoutConstraint.Attribute.left, multiplier:1.0, constant:left!)
            target.superview!.addConstraint(leftC)
        }
        if right != nil {
            let rightC:NSLayoutConstraint = NSLayoutConstraint(item: target, attribute: NSLayoutConstraint.Attribute.right, relatedBy:NSLayoutConstraint.Relation.equal, toItem:toView, attribute:NSLayoutConstraint.Attribute.right, multiplier:1.0, constant:0-right!)
            target.superview!.addConstraint(rightC)
        }
        if top != nil {
            let topC:NSLayoutConstraint = NSLayoutConstraint(item: target, attribute: NSLayoutConstraint.Attribute.top, relatedBy:NSLayoutConstraint.Relation.equal, toItem:toView, attribute:NSLayoutConstraint.Attribute.top, multiplier:1.0, constant:top!)
            target.superview!.addConstraint(topC)
        }
        if bottom != nil {
            let botC:NSLayoutConstraint = NSLayoutConstraint(item: target, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy:NSLayoutConstraint.Relation.equal, toItem:toView, attribute:NSLayoutConstraint.Attribute.bottom, multiplier:1.0, constant:0-bottom!)
            target.superview!.addConstraint(botC)
        }
    }
    
    //创建一个方法，传递一个图像参数和一个缩放比例参数，实现将图像缩放至指定比例的功能
    func scaleImage(_ image:UIImage, _ width:CGFloat,_ height:CGFloat)->UIImage {
    
        let scaledWidth = width * WSCALE//计算新图像的宽度
        let scaledHeight = height * WSCALE//计算新图像的高度
        let targetSize = CGSize(width: scaledWidth, height: scaledHeight)//用新宽度和高度构标准尺寸对象
        UIGraphicsBeginImageContext(targetSize)//创建绘图上下文环境
        //将图像对象画入新尺寸里，原点为0，0
        image.draw(in: CGRect(x: 0, y: 0, width: scaledWidth, height: scaledHeight))
        //获取上下文里的内容，将内容写入到新的图像对象
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return newImage!//返回生成的新的图像对象
    }
}
