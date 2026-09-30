//
//  Models.swift
//  SaborApp
//
//  Domain models for the Sabor restaurant experience.
//

import SwiftUI

// MARK: - Dish

struct Dish: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var description: String
    var price: Double
    var oldPrice: Double? = nil
    var rating: Double
    var reviews: Int
    var prepTime: String
    var calories: Int
    var category: String
    var tags: [String] = []
    var badge: String? = nil
    var imageKey: String
    var image: URL? { SaborImages.url(imageKey).flatMap(URL.init) }

    static func price(_ v: Double) -> String {
        String(format: "%.2f €", v).replacingOccurrences(of: ".", with: ",")
    }
    var priceText: String { Dish.price(price) }
    var oldPriceText: String? { oldPrice.map(Dish.price) }
}

// MARK: - Cart

struct CartLine: Identifiable, Hashable {
    let id = UUID()
    var dish: Dish
    var quantity: Int
    var options: [String] = []
    var unitPrice: Double
    var lineTotal: Double { unitPrice * Double(quantity) }
}

// MARK: - Order

struct Order: Identifiable, Hashable {
    let id = UUID()
    var reference: String
    var date: String
    var title: String
    var status: OrderStatus
    var total: Double
    var payment: String
    var itemsSummary: String
    var imageKeys: [String]
    var rating: Double? = nil
    var eta: String? = nil
    var dishCount: Int
    var progress: String? = nil
}

enum OrderStatus: String {
    case inProgress = "En curso"
    case delivered  = "Entregado"
    case cancelled  = "Cancelado"
    var tint: Color {
        switch self {
        case .inProgress: return SaborColor.secondary
        case .delivered:  return SaborColor.secondary
        case .cancelled:  return SaborColor.error
        }
    }
}

// MARK: - Address

struct Address: Identifiable, Hashable {
    let id = UUID()
    var label: String
    var icon: String
    var detail: String
    var note: String
    var phone: String?
    var isDefault: Bool
    var schedule: String? = nil
}

// MARK: - Notification

struct AppNotification: Identifiable, Hashable {
    let id = UUID()
    var icon: String
    var kind: String
    var time: String
    var title: String
    var body: String
    var unread: Bool
    var group: String
    var imageKey: String? = nil
    var price: Double? = nil
    var primaryAction: String? = nil
}

// MARK: - Tracking step

struct TrackingStep: Identifiable, Hashable {
    let id = UUID()
    var icon: String
    var title: String
    var subtitle: String
    var time: String
    var state: StepState
}

enum StepState { case done, active, pending }

// MARK: - Option groups (dish customization)

struct OptionItem: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var extra: Double
    var note: String?
    var isDefault: Bool = false
}

struct OptionGroup: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var required: Bool
    var items: [OptionItem]
    var multiSelect: Bool = false
}
