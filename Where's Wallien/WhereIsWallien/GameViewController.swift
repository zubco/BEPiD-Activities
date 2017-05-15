//
//  GameViewController.swift
//  WhereIsWallien
//
//  Created by Gustavo Lima on 27/04/2017.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var clockView: ClockView!
    
    var timer:Timer?
    var count:Int = 0
    let thread = DispatchQueue(label: "Timer", qos: .background, attributes: .concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        // sets scroll view size according to image
        scrollView.contentSize = contentView.frame.size
        
        // maximum and minimum zoom sizes
        scrollView.minimumZoomScale = 0.25
        scrollView.maximumZoomScale = 1.15
        
        // initial zoom
        scrollView.zoomScale = 0.3
    
        //Creates an asynchronous parallel thread so the timer can run without being interrupted by the scrolling/zooming
        thread.async { [unowned self] in
            if let _ = self.timer{
                self.timer?.invalidate()
                self.timer = nil
            }
            //Creates the new loop and instantiates the timer
            let mainLoop = RunLoop.current
            self.timer = Timer(timeInterval: 1, target: self, selector: #selector (self.updateTimer), userInfo: self, repeats: true)
            mainLoop.add(self.timer!, forMode: .commonModes)
            //starts the new loop and the timer
            mainLoop.run()
            self.timer?.fire()
        }
    }
    
    //whenever this view disappears, invalidates the timer, so other views won't trigger any unwanted actions
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        // returns view to be zoomed
        return contentView
    }
    
    // Everytime the timer fires, enters this routine and updates the clockView.
    // If timer reaches limit, invalidates it and performs segue to fail screen.
    func updateTimer() -> Void{
        self.clockView.time += 1
        if self.clockView.time == 120{
            self.timer!.invalidate()
            self.performSegue(withIdentifier: "fail", sender: self)
        }
    }
}
