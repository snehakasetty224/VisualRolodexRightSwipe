//
//  ViewController.swift
//  VisualRolodexRightSwipe
//
//  Created by Sneha Kasetty Sudarshan on 2/4/18.
//  Copyright © 2018 Sneha Kasetty Sudarshan. All rights reserved.
//

import UIKit

struct Card : Decodable{
    let lastName: String
    let firstName: String
    let email: String
    let company : String
    let bio : String
    let avatar: String
    
}

var card = [Card]()

class ViewController: UIViewController, UIScrollViewDelegate {

    final let url = URL(string: "https://s3-us-west-2.amazonaws.com/udacity-mobile-interview/CardData.json")
    
    @IBOutlet weak var textView: UITextView!
    
    var imageArray = [UIImage]()
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        scrollView.frame = view.frame
        
        //downloadJson()
        
        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("something is wrong")
                return
            }
            print("downloaded")
            do
            {
                
                card = try JSONDecoder().decode([Card].self, from:data)
                for eachcounty in card{
                    print(eachcounty.lastName)
                    
                    
                }
                
                var i = 0
                DispatchQueue.main.async {
                    for eachcounty in card{
                        
                        let imageView = UIImageView()
                        let label = UILabel()
                        
                        let url = URL(string: eachcounty.avatar)
                        
                        DispatchQueue.global().async {
                            let data = try? Data(contentsOf: url!)
                            DispatchQueue.main.async {
                                imageView.image = UIImage(data: data!)
                            }
                        }
                        
                        if(i == 0){
                            self.textView.text = "Name: " + eachcounty.firstName + " " + eachcounty.lastName + " \nBio: " + eachcounty.bio
                        }
                        
                        //This is for synchronus loading
                     /*   let url = URL(string: eachcounty.avatar)
                        let data = try? Data(contentsOf: url!)
                        imageView.image = UIImage(data: data!)
                        imageView.image = self.imageArray[i] */
                        
                       let xPosition = self.view.frame.width * CGFloat(i)
                        imageView.frame = CGRect(x: xPosition, y: 0, width: self.scrollView.frame.width
                            , height: self.scrollView.frame.height)
                        
                        label.frame = CGRect(x: xPosition, y: 0, width: self.scrollView.frame.width
                            , height: self.scrollView.frame.height)
                        
                        label.text = eachcounty.firstName;
                        
                        self.scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(i+1)
                        
                        self.scrollView.addSubview(label)
                        self.scrollView.addSubview(imageView)
                        // scrollView.delegate = self as? UIScrollViewDelegate
                        self.pageControl.currentPage = 0
                        i = i+1
                        print(eachcounty.firstName)
                        print(eachcounty.lastName)
                        print(eachcounty.avatar)
    
                        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * CGFloat(card.count), height:self.scrollView.frame.height)
                        self.scrollView.delegate = self
                        self.pageControl.currentPage = 0
                        
                    }
                }
    
                
            } catch {
                print("something wrong after downloaded")
            }
            }.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

    private typealias ScrollView = ViewController
    extension ScrollView
    {
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
            // Test the offset and calculate the current page after scrolling ends
            let pageWidth:CGFloat = scrollView.frame.width
            let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
            // Change the indicator
            self.pageControl.currentPage = Int(currentPage);
            // Change the text accordingly
            textView.text = "Name: " + card[Int(currentPage)].firstName + " " + card[Int(currentPage)].lastName + " \nBio: " + card[Int(currentPage)].bio
        }
}

