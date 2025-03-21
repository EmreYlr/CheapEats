//
//  BadgeManager.swift
//  CheapEats
//
//  Created by Emre on 22.03.2025.
//
import UIKit

final class BadgeManager {
    static let shared = BadgeManager()
    private init() {}
    
    private func addBadge(to button: UIBarButtonItem, count: Int) {
        DispatchQueue.main.async {
            self.removeBadge(from: button)
            
            guard count > 0,
                  let buttonView = button.value(forKey: "view") as? UIView else { return }
            
            let label = UILabel()
            label.tag = 999
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "\(count)"
            label.textColor = .white
            label.font = .systemFont(ofSize: 11)
            label.textAlignment = .center
            label.backgroundColor = .cut
            label.layer.cornerRadius = 9
            label.layer.masksToBounds = true
            
            buttonView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: buttonView.topAnchor),
                label.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
                label.widthAnchor.constraint(equalToConstant: 18),
                label.heightAnchor.constraint(equalToConstant: 18)
            ])
        }
    }
    
    func removeBadge(from button: UIBarButtonItem) {
        guard let buttonView = button.value(forKey: "view") as? UIView else { return }
        buttonView.viewWithTag(999)?.removeFromSuperview()
    }
    
    func updateBadge(on button: UIBarButtonItem, count: Int) {
        count > 0 ? addBadge(to: button, count: count) : removeBadge(from: button)
    }
}
