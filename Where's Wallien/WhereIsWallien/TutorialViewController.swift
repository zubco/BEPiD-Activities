//
//  TutorialViewController.swift
//  WhereIsWallien
//
//  Created by Rafael Tomaz Prado on 10/05/17.
//  Copyright © 2017 Instituto de Pesquisas Eldorado. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate, SkipButtonProtocol{

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var skipButton: UIBarButtonItem!
    
    var shouldDisplaySkipButton: Bool?
    
    override func viewDidLoad() {
        // Hides Skip button if parameter was previously set
        if !self.shouldDisplaySkipButton!{
            self.navigationItem.rightBarButtonItem = nil
        }
        
        scrollView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Instantiates every page of the tutorial using the xib files.
        let page1: UIView! = Bundle.main.loadNibNamed("tutorial1", owner: self, options: nil)![0] as! UIView
        let page2: UIView! = Bundle.main.loadNibNamed("tutorial2", owner: self, options: nil)![0] as! UIView
        let page3: UIView! = Bundle.main.loadNibNamed("tutorial3", owner: self, options: nil)![0] as! UIView
        let page4: UIView! = Bundle.main.loadNibNamed("tutorial4", owner: self, options: nil)![0] as! UIView
        let page5: UIView! = Bundle.main.loadNibNamed("tutorial5", owner: self, options: nil)![0] as! UIView
        let page6: UIView! = Bundle.main.loadNibNamed("tutorial6", owner: self, options: nil)![0] as! UIView
        let page7: UIView! = Bundle.main.loadNibNamed("tutorial7", owner: self, options: nil)![0] as! UIView
        
        //Creates a pages array and sets its initial pages and number of pages
        let pages:[UIView?] = [page1, page2, page3, page4, page5, page6, page7]
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = pages.count
        
        //For each page, adds it to the scroll view. Adds an offset and updates the scrollview content size so the next page can be inserted right beside it.
        for page in pages{
            page?.frame = (page?.frame.offsetBy(dx: scrollView.contentSize.width, dy: -150))!
            
            scrollView.addSubview(page!)
            
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width + self.view.frame.width, height: scrollView.frame.height - 65)
        }
    }
    
    // Flips pages when half the image is on the screen
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = floor(scrollView.contentOffset.x / self.view.frame.width)
        pageControl.currentPage = Int(page)
        
        // Sets the rightBarButton according to page number.
        if self.shouldDisplaySkipButton! {
            if pageControl.currentPage == 6{
                skipButton.title = "Play"
            }else{
                skipButton.title = "Skip"
            }
        }
    }

}
