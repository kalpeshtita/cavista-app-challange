//
//  ViewController.swift
//  cavista-app-challenge
//
//  Created by Kalpesh Tita on 25/09/20.
//  Copyright © 2020 Kalpesh Tita. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getUserPost()
    }

    func getUserPost(){
        
        UserPostAPI.init().dispatch(onSuccess: { useposts in
            
        }) { (errorResponse, error) in
            
        }

    }

}

