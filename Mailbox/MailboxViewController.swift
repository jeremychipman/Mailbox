//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Jeremy Chipman on 10/21/15.
//  Copyright © 2015 Jeremy Chipman. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var listView: UIImageView!
    @IBOutlet weak var mailboxView: UIView!
    @IBOutlet weak var dragView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet var messagePanGesture: UIPanGestureRecognizer!
    @IBOutlet var rescheduleTapGesture: UITapGestureRecognizer!
    @IBOutlet var listTapGesture: UITapGestureRecognizer!
    @IBOutlet weak var feedImage: UIImageView!
  
    
    
    var messageInitialFrame: CGPoint!
    var messageLeft: CGPoint!
    var messageRight: CGPoint!
    var laterInitialFrame: CGPoint!
    var archiveInitialFrame: CGPoint!
    var deleteInitialFrame: CGPoint!
    var listInitialFrame: CGPoint!
    var feedInitialFrame: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //do additional setup after loading the view.
        
        listView.alpha=0
        rescheduleView.alpha=0
        laterIcon.alpha=0.4
        deleteIcon.alpha=0
        listIcon.alpha=0
        
        scrollView.contentSize = CGSize(width: 320, height: 1202)
        
        let messagePanGesture = UIPanGestureRecognizer(target: self, action: "onLeftPan:")
        messageView.addGestureRecognizer(messagePanGesture)
        
        let rescheduleTapGesture = UITapGestureRecognizer(target: self, action: "onRescheduleTap:")
        rescheduleTapGesture.numberOfTapsRequired = 2;
        rescheduleView.userInteractionEnabled = true
        rescheduleView.addGestureRecognizer(rescheduleTapGesture)
        
        let listTapGesture = UITapGestureRecognizer(target: self, action: "onListTap:")
        rescheduleTapGesture.numberOfTapsRequired = 2;
        listView.userInteractionEnabled = true
        listView.addGestureRecognizer(listTapGesture)

//        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
//        mailboxView.userInteractionEnabled=true
//        edgePanGesture.edges = UIRectEdge.Left
//        mailboxView.addGestureRecognizer(edgePanGesture)
        
        
    }
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    @IBAction func onLeftPan(messagePanGesture: UIPanGestureRecognizer) {
        // Absolute (x,y) coordinates in parent view
        
        let point = messagePanGesture.locationInView(view)
        
        // Relative change in (x,y) coordinates from where gesture began.
        
        let messageTranslation = messagePanGesture.translationInView(view)
        _ = messagePanGesture.velocityInView(view)
        
        if messagePanGesture.state == UIGestureRecognizerState.Began {
            print("Gesture began at: \(point)")
            
            messageInitialFrame = messageView.frame.origin
            laterInitialFrame = laterIcon.frame.origin
            archiveInitialFrame = archiveIcon.frame.origin
            deleteInitialFrame = deleteIcon.frame.origin
            
            
        } else if messagePanGesture.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
            
            
            messageView.frame.origin.x = CGFloat(messageInitialFrame.x + messageTranslation.x)
            
            //            /* when I comment this out, the icons appear */
            //            archiveIcon.frame.origin.x = CGFloat(archiveInitialFrame.x + translation.x)
            //            deleteIcon.frame.origin.x = CGFloat(deleteInitialFrame.x + translation.x)
            //            laterIcon.frame.origin.x = CGFloat(laterInitialFrame.x + translation.x)
            
            if messageTranslation.x > 0 && messageTranslation.x <= 60 {
                dragView.backgroundColor = UIColorFromHex(0xDCDFE0, alpha:1.0)
                archiveIcon.alpha=0.4
                
            } else if messageTranslation.x > 60 && messageTranslation.x <= 260 {
                dragView.backgroundColor = UIColorFromHex(0x55D959, alpha: 1.0)
                archiveIcon.alpha = 1
                deleteIcon.alpha = 0
                archiveIcon.frame.origin.x = CGFloat(archiveInitialFrame.x + messageTranslation.x - 62)
                
            } else if messageTranslation.x > 260 {
                dragView.backgroundColor = UIColorFromHex(0xF24D44, alpha: 1.0)
                archiveIcon.alpha = 0
                laterIcon.alpha = 0
                deleteIcon.alpha = 1
                deleteIcon.frame.origin.x = CGFloat(deleteInitialFrame.x + messageTranslation.x - 280)
                
            } else if messageTranslation.x > -60 && messageTranslation.x < 0 {
                dragView.backgroundColor = UIColorFromHex(0xDCDFE0, alpha: 1.0)
//                if messageTranslation.x < -30 {laterIcon.hidden = false}
                
            } else if messageTranslation.x > -260 && messageTranslation.x < -60 {
                dragView.backgroundColor = UIColorFromHex(0xFFE066, alpha: 1.0)
                self.laterIcon.alpha = 1
                laterIcon.frame.origin.x = CGFloat(laterInitialFrame.x + messageTranslation.x + 62)
                
            } else if messageTranslation.x < -260 {
                dragView.backgroundColor = UIColorFromHex(0xF4A460, alpha: 1.0)
                self.laterIcon.alpha = 0
                self.listIcon.alpha=1
                self.laterIcon.alpha=0
                self.archiveIcon.alpha=0
                self.deleteIcon.alpha=0
                
                
            }
            
        } else if messagePanGesture.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
            
            if messageTranslation.x >= -260 && messageTranslation.x < -60 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                    self.rescheduleView.alpha=1
                    self.mailboxView.alpha=0
                    self.scrollView.alpha=0
                    
                    self.dragView.frame.origin.x = CGFloat(self.messageInitialFrame.x)
                
                    
                    }, completion: nil)
            }
            if messageTranslation.x < -260 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                    self.listView.alpha=1
                    self.mailboxView.alpha=0
                    self.scrollView.alpha=0
                    
                    self.dragView.frame.origin.x = CGFloat(self.messageInitialFrame.x)
                    }, completion: nil)
            }
            if messageTranslation.x >= -60 && messageTranslation.x <= 60  {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                    self.messageView.frame.origin.x = CGFloat(self.messageInitialFrame.x)
                    
                    }, completion: nil)
            }
            if messageTranslation.x > 60 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                   self.feedImage.frame.origin.y = CGFloat(self.feedInitialFrame.y - 86)
                    
                    }, completion: nil)
            }
        }
        
    }
    
    @IBAction func onRescheduleTap(sender: UITapGestureRecognizer) {
        self.rescheduleView.alpha = 0
        self.mailboxView.alpha=1
        self.scrollView.alpha=1
        feedImage.frame.origin.y = CGFloat(feedInitialFrame.y - 86)

        
        
    }
    @IBAction func onListTap(sender: UITapGestureRecognizer) {
        self.listView.alpha = 0
        self.mailboxView.alpha=1
        self.scrollView.alpha=1
        feedImage.frame.origin.y = CGFloat(feedInitialFrame.y - 86)
    }
    
    
    
}







//func onEdgePan (edgePanGesture: UIScreenEdgePanGestureRecognizer){
//    var point = edgePanGesture.locationInView(view)
//    var translation=edgePanGesture.translationInView(view)
//    print("screen edge called \(mailboxView.frame.origin)")








/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
}
*/

