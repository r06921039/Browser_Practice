//
//  ViewController.swift
//  Browser_Practice
//
//  Created by Jeff on 2021/9/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController{
    
    weak var delegate: CollectionViewController?
    var index: Int?
    
    let screenSize: CGRect = UIScreen.main.bounds
    lazy var searchBar : UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: screenSize.width - 30, height: 20))
    let webView = WKWebView()
    var refreshController: UIRefreshControl = UIRefreshControl()
    
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
    
    lazy var tabButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: self.resizedImage(at: "tabs", for: CGSize(width: 24, height: 24)), style: .plain, target: self, action: #selector(handleTabs))
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
        
        
        
        items = [backButton, fixSpace, forwardButton, flexibleSpace, tabButton]
        
        self.setToolbarItems(items, animated: false)
        
        refreshController.bounds = CGRect(x: 0, y: 50, width: refreshController.bounds.size.width, height: refreshController.bounds.size.height)
        refreshController.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        webView.scrollView.addSubview(refreshController)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
}

extension WebViewController: UIScrollViewDelegate{
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

extension WebViewController: WKNavigationDelegate{
    
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


extension WebViewController: UISearchBarDelegate{
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


extension WebViewController{
    
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
    
    @objc func handleRefresh(_ refresh:UIRefreshControl){
        webView.reload()
        refresh.endRefreshing()
    }
    
    @objc func handleTabs(_ sender: UIBarButtonItem){
        let config = WKSnapshotConfiguration()
        config.rect = CGRect(x: 0, y: 0, width: screenSize.width / 2, height: 300)

        webView.takeSnapshot(with: nil) { [unowned self] image, error in
            if let image = image {
                let data = WebData()
                data.vc = self
                data.image = image
                if self.index! == delegate?.tabs.count{
                    delegate?.tabs.append(data)
                }
                else{
                    delegate?.tabs[index!].image = image
                }
                delegate?.collectionView.reloadData()
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
}
