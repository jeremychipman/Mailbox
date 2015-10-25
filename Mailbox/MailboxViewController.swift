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
    
    @IBOutlet weak var laterIcon: UIImageView!
    
    @IBOutlet weak var dragLeft: UIView!
    
    @IBOutlet weak var dragRight: UIView!
    
    @IBOutlet weak var messageView: UIImageView!
    
    @IBOutlet var messagePanGesture: UIPanGestureRecognizer!
    
    @IBOutlet var listEdge: UIScreenEdgePanGestureRecognizer!
  
    
    var messageInitialFrame: CGPoint!
    var messageLeft: CGPoint!
    var messageRight: CGPoint!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        listView.alpha=0
        rescheduleView.alpha=0
        laterIcon.alpha=0.4
        scrollView.contentSize = CGSize(width: 320, height: 1202)
        
        let messagePanGesture = UIPanGestureRecognizer(target: self, action: "onLeftPan:")
        
        // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
        
        messageView.addGestureRecognizer(messagePanGesture)
        
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onList:")
        
        mailboxView.addGestureRecognizer(listEdge)
        
        // Do any additional setup after loading the view.
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
            
        } else if messagePanGesture.state == UIGestureRecognizerState.Changed {
            print("Gesture changed at: \(point)")
            
        
          messageView.frame.origin.x = CGFloat(messageInitialFrame.x + messageTranslation.x)
            
            
        } else if messagePanGesture.state == UIGestureRecognizerState.Ended {
            print("Gesture ended at: \(point)")
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                
                self.laterIcon.alpha=1
                self.dragLeft.frame.origin.x = CGFloat(self.messageInitialFrame.x)
                
                }, completion: nil)
    }

   
}

    @IBAction func onList(sender: UIScreenEdgePanGestureRecognizer) {
        print ("You tapped the list")
        let location = sender.locationInView(view)
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
       
        
        
        if listEdge.state == UIGestureRecognizerState.Began {
            print("Gesture began")
            mailboxView.center = location
            
        } else if listEdge.state == UIGestureRecognizerState.Changed {
            print("Gesture changed")
            
        } else if listEdge.state == UIGestureRecognizerState.Ended {
            print("Gesture ended")
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: { () -> Void in
                
                self.laterIcon.alpha=1
                self.dragLeft.frame.origin.x = CGFloat(self.messageInitialFrame.x)
                
                }, completion: nil)
        }

        
    }
    

    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}