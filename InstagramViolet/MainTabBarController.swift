//
//  MainTabBarController.swift
//  InstagramViolet
//
//  Created by Владислав Артюхов on 01.12.2024.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController, UITabBarControllerDelegate{

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        switch index {
        case 0: return true
        case 1: return true
        case 2:
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: UICollectionViewFlowLayout())
            let navController = UINavigationController(rootViewController: photoSelectorController)
            navController.modalPresentationStyle = .fullScreen
            self.show(navController, sender: nil)
            return false
        case 3: return true
        case 4: return true
        default: return false
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.show(navController, sender: nil)
            }
            return
        }
        setupMainTabBarController()
    }
    
    func setupMainTabBarController() {
        //home
        let homeNavController = templateNavController(unselected: UIImage.homeUnselected, selected: UIImage.homeSelected, rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        //search
        let searchNavController = templateNavController(unselected: UIImage.searchUnselected, selected: UIImage.searchSelected, rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        //plus
        let plusNavController = templateNavController(unselected: UIImage.plusUnselected, selected: UIImage.plusUnselected)
        //like
        let likeNavController = templateNavController(unselected: UIImage.likeUnselected, selected: UIImage.likeSelected)
        //user
        let userProfileNavController = templateNavController(unselected: UIImage.profileUnselected, selected: UIImage.profileSelected, rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        tabBar.tintColor = .customThemeDarkText
        viewControllers = [homeNavController,
                           searchNavController,
                           plusNavController,
                           likeNavController,
                           userProfileNavController]
        
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    private func templateNavController(unselected: UIImage, selected: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselected
        navController.tabBarItem.selectedImage = selected
        return navController
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
