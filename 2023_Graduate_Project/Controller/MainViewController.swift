//
//  MainViewController.swift
//  2023_Graduate_Project
//
//  Created by WonDongHyun on 2023/04/08.
//

import Foundation
import UIKit
import CoreLocation
import FirebaseAuth

class MainViewController: UIViewController, CLLocationManagerDelegate {
    
    let bannerInfos: [BannerInfo] = BannerInfo.list
    let colors: [UIColor] = [.clear, .clear, .clear , .clear]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    @IBOutlet weak var cityNameLabel : UILabel!
    
    @IBOutlet weak var weatherDescriptLabel : UILabel!
    
    @IBOutlet weak var tempLabel : UILabel!
    
    
   
    
    enum Section {
        case main
    }
   
    typealias Item = BannerInfo
    var datasource: UICollectionViewDiffableDataSource<Section, Item>!
    
    var locationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
       
        self.navigationItem.setHidesBackButton(true, animated: false) // 네비게이션 백버튼 숨기기 ~
        
        let email = Auth.auth().currentUser?.email ?? "고객" //없으면 고객으로 표시
        
        // Presentation
        datasource = UICollectionViewDiffableDataSource<Section, Item>.init(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as? BannerCell else {
                return nil
            }
            cell.configure(item)
            cell.backgroundColor = self.colors[indexPath.item]
            return cell
        })
        
        // Data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(bannerInfos, toSection: .main)
        datasource.apply(snapshot)
        
        // layout
        collectionView.collectionViewLayout = layout()
        collectionView.alwaysBounceVertical = false
        
        self.pageControl.numberOfPages = bannerInfos.count
        
        locationManager.delegate = self // 로케이션 위임자
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 항상 최고의 로케이션을 받아오기
        locationManager.requestWhenInUseAuthorization() // 허용 받기 alert 띄우기
        
        self.getCurrentWeather(cityName: "Busan")
        // Do any additional setup after loading the view.
        
        
        
       
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 20
        
        section.visibleItemsInvalidationHandler = { (items, offset, env) in
            let index = Int((offset.x / env.container.contentSize.width).rounded(.up))
            print("--> \(index)")
            self.pageControl.currentPage = index
        }

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews{
            if view is UIPageControl{
                (view as! UIPageControl).currentPageIndicatorTintColor = .black
                }
            }
        }
    
    
   
    
    
    func configureView(weatherInformation : weatherInformation){
        
        self.cityNameLabel?.text = weatherInformation.name
        
        if let weather = weatherInformation.weather.first {
            self.weatherDescriptLabel?.text = weather.description
        }
        self.tempLabel?.text = "\(Int(weatherInformation.temp.temp - 273.15))°C"
       
        
        
    }
    
    func showAlert (message : String) {
        
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
    
    
    
    func getCurrentWeather(cityName: String) {
        
       
        
        
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=16882ac4cd0b46d7e00aa2af67233f5c") else{
            return
        }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url){ [weak self] data , response , error in
            
            let successRange = (200..<300)
            guard let data = data, error == nil else {return} // 데이터가 있고 에러가 없을때 다음 줄이 실행되게 옵셔널 바인딩
            let decoder = JSONDecoder()
            
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                guard let weatherInformation = try? decoder.decode(weatherInformation.self, from: data) else{
                    return
                } //서버에서 받은걸 weahter information 객체로 변환
                DispatchQueue.main.async {
                    self?.stackView?.isHidden = false
                    self?.configureView(weatherInformation: weatherInformation)
                }
                
            } else {
                
                guard let errorMessage = try? decoder.decode(errorMessage.self, from: data) else {return}
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
            }
            
            
        }.resume()
        
    }
    
}


