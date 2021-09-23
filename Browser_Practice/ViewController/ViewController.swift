//
//  ViewController.swift
//  Browser_Practice
//
//  Created by Jeff on 2021/9/22.
//

import UIKit
import WebKit

class ViewController: UIViewController{

    let screenSize: CGRect = UIScreen.main.bounds
    lazy var searchBar : UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: screenSize.width - 30, height: 20))
    let webView = WKWebView()
    
    var items = [UIBarButtonItem]()
    
    lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: self.resizedImage(at: "left_arrow", for: CGSize(width: 24, height: 24)), style: .plain, target: self, action: #selector(handleBackButtonPress))
        return button
    }()
    
    lazy var forwardButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: self.resizedImage(at: "right_arrow", for: CGSize(width: 24, height: 24)), style: .plain, target: self, action: #selector(handleForwardButtonPress))
        return button
    }()
    
    lazy var flexibleSpace: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        return button
    }()
    
    lazy var fixSpace: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        button.width = 20
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchBar.placeholder = "Search URL"
        searchBar.delegate = self
        
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        
        guard let url = URL(string: "https://www.google.com") else {
            return
        }
        webView.load(URLRequest(url: url))
        
        
        
        items = [backButton, fixSpace, forwardButton, flexibleSpace]
        
        self.setToolbarItems(items, animated: false)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
}

extension ViewController: UIScrollViewDelegate{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if(velocity.y>0) {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.navigationController?.setToolbarHidden(true, animated: true)
            print("Hide")
           

        } else {
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.setToolbarHidden(false, animated: true)
            print("Unhide")
            
          }
       }
}

extension ViewController: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        refreshNavigationControls()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    private func refreshNavigationControls() {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        searchBar.text = webView.url?.absoluteString
    }
    
}


extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, let url = URL.parseString(withString: text) else {
            return
        }
        webView.load(URLRequest(url: url))
        self.searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
}


extension ViewController{
    
    func resizedImage(at named: String, for size: CGSize) -> UIImage? {
        guard let image = UIImage(named: named) else {
            return nil
        }

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    @objc func handleBackButtonPress(_ sender: UIBarButtonItem) {
        webView.stopLoading()
        webView.goBack()
    }
    
    @objc func handleForwardButtonPress(_ sender: UIBarButtonItem) {
        webView.stopLoading()
        webView.goForward()
    }
}
