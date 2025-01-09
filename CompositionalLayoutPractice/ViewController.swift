//
//  ViewController.swift
//  CompositionalLayoutPractice
//
//  Created by Vicky on 2025/1/9.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var collectionViewLayout: UICollectionViewLayout = makeCollectionLayout()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(LabelCollectionViewCell.self, forCellWithReuseIdentifier: LabelCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let data: [String] = [
        "胡志明市", "藍皮解憂號鐵道一日遊遊遊", "東京", "環球影城",
        "星夢郵輪", "海風與天際線", "福森號", "活動1", "活動2", "活動3"
    ]
    
    private var oddItems: [String] {
        return data.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element }
    }
    
    private var evenItems: [String] {
        return data.enumerated().filter { $0.offset % 2 == 1 }.map { $0.element }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count // 總數據項目
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelCollectionViewCell.identifier, for: indexPath) as! LabelCollectionViewCell
        
        // 判斷索引是奇數還是偶數
        if indexPath.item < oddItems.count {
            cell.configure(with: oddItems[indexPath.item]) // 奇數
        } else {
            let evenIndex = indexPath.item - oddItems.count
            cell.configure(with: evenItems[evenIndex]) // 偶數
        }
        
        return cell
    }
}

extension ViewController {
    private func makeCollectionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let containerWidth = layoutEnvironment.container.effectiveContentSize.width
            
            // 奇數行項目配置
            let oddItemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(100), // 動態寬度
                heightDimension: .fractionalHeight(1.0)
            )
            let oddItem = NSCollectionLayoutItem(layoutSize: oddItemSize)
            oddItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            
            let oddGroupSize = NSCollectionLayoutSize(
                widthDimension: .estimated(containerWidth), // 支持超出屏幕寬度
                heightDimension: .absolute(40) // 每行高度固定
            )
            let oddGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: oddGroupSize,
                subitems: Array(repeating: oddItem, count: self.oddItems.count) // 根據奇數項目數量動態配置
            )
            
            // 偶數行項目配置
            let evenItemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(100), // 動態寬度
                heightDimension: .fractionalHeight(1.0)
            )
            let evenItem = NSCollectionLayoutItem(layoutSize: evenItemSize)
            evenItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            
            let evenGroupSize = NSCollectionLayoutSize(
                widthDimension: .estimated(containerWidth), // 支持超出屏幕寬度
                heightDimension: .absolute(40) // 每行高度固定
            )
            let evenGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: evenGroupSize,
                subitems: Array(repeating: evenItem, count: self.evenItems.count) // 根據偶數項目數量動態配置
            )
            
            // 將奇數行和偶數行組合在一起
            let containerGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0), // 整個 Section 寬度
                heightDimension: .estimated(80) // 高度動態計算
            )
            let containerGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: containerGroupSize,
                subitems: [oddGroup, evenGroup] // 垂直排列奇數和偶數
            )
            
            // Section 配置
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .continuous // 支持水平滾動
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            
            return section
        }
    }
}
