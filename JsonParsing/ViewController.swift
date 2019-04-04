//
//  ViewController.swift
//  JsonParsing
//
//  Created by IBM-MOBILITY on 04/04/19.
//  Copyright © 2019 DurgaPrasad. All rights reserved.
//

import UIKit

struct Course: Decodable {
    let id:Int;
    let name: String;
    let imageUrl:String;
    let number_of_lessons: Int;
}



class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet weak var imageView1: UIImageView!
    
    var coursesd: [Course] = []
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchJson { (courses, error) in
            if let error = error {
                print("Json Parsing error", error)
                return
            }
            guard let courses = courses else { return }
            //now json data is parsed
            courses.forEach({ (course) in
                print(course.name)
            });
            
            self.coursesd = courses
            
            self.setImage(url: self.coursesd[0].imageUrl, url1: self.coursesd[1].imageUrl)

        }
    }
    
    
    // Fetch JSON
    fileprivate func fetchJson(completion: @escaping ([Course]? , Error? ) -> ()) {
        let urlString = "https://api.letsbuildthatapp.com/jsondecodable/courses";
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil,error)
            }
            
            // If response is available
            
            guard let data = data else { return }
            
            do {
                let courses  =  try JSONDecoder().decode([Course].self, from: data)
                completion(courses,nil)
            } catch let jsonError {
                completion(nil, jsonError)
            }
            
            
            }.resume();
    }
    
    func setImage(url: String, url1: String) {
        imageView.loadImageFromUrl(urlString: url)
        guard let url = URL(string: url1) else { return }
        imageView1.load(url: url)
    }
    
    
    
}


extension UIImageView {
    func loadImageFromUrl(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async { [weak self] in
        URLSession.shared.dataTask(with: url) { (data , res, err) in
            if let error = err {
                print(error)
                return
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                
                self?.image = UIImage(data: data)
            }
            
            }.resume()
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
