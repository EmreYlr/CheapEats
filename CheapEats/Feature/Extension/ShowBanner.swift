//
//  ShowBanner.swift
//  CheapEats
//
//  Created by Emre on 11.06.2025.
//

import SwiftEntryKit
import UIKit

protocol ShowBanner {
    func showOrderNotificationBanner(orderNo: String, status: OrderStatus)
}

extension ShowBanner {
    func showOrderNotificationBanner(orderNo: String, status: OrderStatus) {
        var attributes = EKAttributes.topNote
        attributes.displayDuration = .infinity
        attributes.entryInteraction = .dismiss
        attributes.screenInteraction = .forward
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)

        let backgroundColor = EKColor(UIColor(named: "title") ?? .title)
        attributes.entryBackground = .color(color: backgroundColor)

        let title = EKProperty.LabelContent(
            text: "Sipariş Durumu Güncellendi!",
            style: .init(font: .boldSystemFont(ofSize: 16), color: .white)
        )
        
        let descriptionText: String
        switch status {
        case .pending:
            descriptionText = "#\(orderNo) numaralı sipariş alındı."
        case .preparing:
            descriptionText = "#\(orderNo) numaralı sipariş hazırlanıyor."
        case .ready:
            descriptionText = "#\(orderNo) numaralı sipariş hazırlandı."
        case .delivered:
            descriptionText = "#\(orderNo) numaralı sipariş teslim edildi."
        case .canceled:
            descriptionText = "#\(orderNo) numaralı sipariş iptal edildi."
        }
        
        let description = EKProperty.LabelContent(
            text: descriptionText,
            style: .init(font: .systemFont(ofSize: 14), color: .white)
        )
        let simpleMessage = EKSimpleMessage(title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)

        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}

extension UIViewController: ShowBanner {}
extension HomeViewModel: ShowBanner {}
