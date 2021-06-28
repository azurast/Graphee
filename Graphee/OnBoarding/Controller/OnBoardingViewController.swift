//
//  OnBoardingViewController.swift
//  Graphee
//
//  Created by Dzaki Izza on 25/06/21.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    @IBOutlet weak var collect: UICollectionView!
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var getStarted: UIButton!
    

    var data = onBoardingData()
    
    var relativeFontConstant : CGFloat = 0.46
    var currentPage = 0 {
        didSet {
            
            if currentPage == data.slides.count - 1 {
                nextBtn.isHidden = true
                getStarted.isHidden = false
                
            }
            
            else {

                nextBtn.isHidden = false
                getStarted.isHidden = true
                
            }

            
            pageControl.currentPage = currentPage
            
        }
    }
    override func viewDidLoad()  {
        super.viewDidLoad()
        
            
        collect.delegate = self
        collect.dataSource = self

        nextBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        nextBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        nextBtn.layer.shadowOpacity = 1.0
        nextBtn.layer.shadowRadius = 0.0
        nextBtn.layer.applySketchShadow(y:2, blur: 4)

        
        prevBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        prevBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        prevBtn.layer.shadowOpacity = 1.0
        prevBtn.layer.shadowRadius = 0.0
        prevBtn.layer.applySketchShadow(y:2, blur: 4)
        
        getStarted.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        getStarted.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        getStarted.layer.shadowOpacity = 1.0
        getStarted.layer.shadowRadius = 0.0
        getStarted.layer.applySketchShadow(y:2, blur: 4)
        

        getStarted.isHidden = true
        
                
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            pageControl.subviews.forEach {
                $0.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        
    }
    @IBAction func nextClicked(_ sender: Any) {
        
        if currentPage == data.slides.count - 1 {
            print("finish")
        }
        
        else {
        currentPage += 1
        let indexPath = IndexPath(item: currentPage, section: 0 )
        collect.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true )
        }
    }

    
         @IBAction func prevClicked(_ sender: Any) {
        
        currentPage -= 1
        let indexPath = IndexPath(item: currentPage, section: 0 )
        collect.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true )
        
    }
    
    @IBAction func skipClicked(_ sender: Any) {
        
        OnBoardingManager.shared.isFirstLaunch = true
        
    }
    
    @IBAction func getStartedClicked(_ sender: Any) {
        
        OnBoardingManager.shared.isFirstLaunch = true

    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x/width)
        
        
    }
    
    }

extension OnBoardingViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.slides.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collect.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OnBoardingCollectionViewCell
        
        cell.setup(data.slides[indexPath.row])
        cell.titleText.minimumScaleFactor = 10.0
        cell.titleText.adjustsFontSizeToFitWidth = true
      
        if view.frame.width < 390 {
        cell.titleText.font = cell.titleText.font.withSize(self.view.frame.height * 0.046)
        cell.descText.font = cell.descText.font.withSize(self.view.frame.height * 0.02)

        }

        if view.frame.width == 414 {
            
            cell.titleText.font = cell.titleText.font.withSize(self.view.frame.height * 0.040)
            cell.descText.font = cell.descText.font.withSize(self.view.frame.height * 0.02)
            
            
        }
        

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collect.frame.width, height: collect.frame.height)
    }
    
}
