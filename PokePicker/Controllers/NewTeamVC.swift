//
//  NewTeamVC.swift
//  PokePicker
//
//  Created by Chip Chairez on 7/23/22.
//

import UIKit

class NewTeamVC: UIViewController {
    @IBOutlet weak var teamName: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        logoImageView.image = UIImage(named: "pokepicker-logo")
        
    }

    @IBAction func createTeamPressed(_ sender: UIButton) {
        if (teamName.text != ""){
            let teamCreateVC = self.storyboard?.instantiateViewController(withIdentifier: "TeamCreateVC") as! TeamCreateVC
            //teamCreateVC.teamName = teamName.text
            teamCreateVC.title = teamName.text
            teamName.text = ""
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(teamCreateVC, animated: true)
        }
        
        
    }
}

extension NewTeamVC: UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if(viewController == self){
            self.tabBarController?.tabBar.isHidden = false
        }
    }
}
