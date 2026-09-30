//
//  AppState.swift
//  SaborApp
//
//  Single observable source of truth for the whole app (mock / in-memory).
//

import SwiftUI

@MainActor
final class AppState: ObservableObject {

    // MARK: Navigation
    enum Tab: Int, CaseIterable { case home, menu, favorites, orders, profile }
    @Published var tab: Tab = .home

    // MARK: Session
    @Published var isAuthenticated = false
    @Published var showOnboarding = true
    @Published var user = User(name: "Valentina González",
                               email: "valentina@correo.com",
                               phone: "+34 612 345 678",
                               points: 840, orders: 14, favorites: 4, addresses: 3)
    @Published var addressLabel = "Calle Mayor 24 • Centro"

    // MARK: Catalog
    @Published var dishes = MockData.dishes
    @Published var searchText = ""
    @Published var selectedCategory = "Todas"
    @Published var favorites: Set<String> = [
        "Hamburguesa Trufada Sabor", "Tagliatelle al Pesto de Pistacho",
        "Costillar Ibérico a Baja Temperatura", "Cheesecake de Queso Manchego",
    ]

    // MARK: Cart
    @Published var cart: [CartLine] = []
    @Published var couponApplied = true
    @Published var ecoCutlery = true

    // MARK: Data
    @Published var orders = MockData.orders
    @Published var addresses = MockData.addresses
    @Published var notifications = MockData.notifications

    // MARK: Settings
    @Published var appearance: AppearanceMode = .system
    @Published var hapticsEnabled = true
    @Published var pushOrderUpdates = true
    @Published var promoOffers = true
    @Published var chefNewsletter = false
    @Published var biometrics = true

    // MARK: Transient UI
    @Published var toast: String?
    @Published var lastOrderReference = "#SB-84920"

    // MARK: Derived
    var filteredDishes: [Dish] {
        dishes.filter { d in
            let catOK = selectedCategory == "Todas" || d.category == selectedCategory
            let q = searchText.trimmingCharacters(in: .whitespaces)
            let searchOK = q.isEmpty
                || d.name.localizedCaseInsensitiveContains(q)
                || d.description.localizedCaseInsensitiveContains(q)
            return catOK && searchOK
        }
    }
    var favoriteDishes: [Dish] { dishes.filter { favorites.contains($0.name) } }
    var cartCount: Int { cart.reduce(0) { $0 + $1.quantity } }
    var subtotal: Double { cart.reduce(0) { $0 + $1.lineTotal } }
    var deliveryFee: Double { cart.isEmpty ? 0 : 2.50 }
    var serviceFee: Double { cart.isEmpty ? 0 : 0.90 }
    var discount: Double { couponApplied && !cart.isEmpty ? 8.00 : 0 }
    var total: Double { max(0, subtotal + deliveryFee + serviceFee - discount) }

    // MARK: Actions
    func isFavorite(_ dish: Dish) -> Bool { favorites.contains(dish.name) }
    func toggleFavorite(_ dish: Dish) {
        if favorites.contains(dish.name) { favorites.remove(dish.name); toast = "Eliminado de favoritos" }
        else { favorites.insert(dish.name); toast = "Añadido a favoritos" }
    }

    func addToCart(_ dish: Dish, quantity: Int = 1, options: [String] = [], unitPrice: Double? = nil) {
        let price = unitPrice ?? dish.price
        if let idx = cart.firstIndex(where: { $0.dish.name == dish.name && $0.options == options }) {
            cart[idx].quantity += quantity
        } else {
            cart.append(CartLine(dish: dish, quantity: quantity, options: options, unitPrice: price))
        }
        toast = "\(dish.name) añadido al pedido"
        user.favorites = favorites.count
    }
    func inc(_ line: CartLine) {
        guard let i = cart.firstIndex(where: { $0.id == line.id }) else { return }
        cart[i].quantity += 1
    }
    func dec(_ line: CartLine) {
        guard let i = cart.firstIndex(where: { $0.id == line.id }) else { return }
        cart[i].quantity -= 1
        if cart[i].quantity <= 0 { cart.remove(at: i) }
    }
    func remove(_ line: CartLine) { cart.removeAll { $0.id == line.id } }
    func clearCart() { cart.removeAll() }

    func seedCartIfEmpty() {
        guard cart.isEmpty else { return }
        let a = dishes.first { $0.name == "Hamburguesa Trufada Sabor" }!
        let b = dishes.first { $0.name == "Tagliatelle al Pesto de Pistacho" }!
        let c = dishes.first { $0.name == "Cheesecake de Queso Manchego" }!
        cart = [
            CartLine(dish: a, quantity: 1, options: ["Al punto", "Bacon ahumado", "Patatas gajo"], unitPrice: 16.00),
            CartLine(dish: b, quantity: 1, options: ["Receta original"], unitPrice: 15.20),
            CartLine(dish: c, quantity: 2, options: [], unitPrice: 7.50),
        ]
    }

    func placeOrder() {
        let ref = "#SB-\(Int.random(in: 85000...89999))"
        lastOrderReference = ref
        let line = Order(reference: ref, date: "Hoy", title: "Entrega prioritaria a domicilio",
                         status: .inProgress, total: total, payment: "Mastercard •••• 4829",
                         itemsSummary: cart.map { $0.dish.name }.joined(separator: ", "),
                         imageKeys: cart.map { $0.dish.imageKey },
                         eta: "En camino (~14:50)", dishCount: cart.count,
                         progress: "Preparando tu pedido")
        orders.insert(line, at: 0)
        clearCart()
    }

    func signIn() { isAuthenticated = true; showOnboarding = false }
    func signOut() { isAuthenticated = false; showOnboarding = true; cart.removeAll() }
}

struct User {
    var name: String
    var email: String
    var phone: String
    var points: Int
    var orders: Int
    var favorites: Int
    var addresses: Int
}

enum AppearanceMode: String, CaseIterable {
    case light = "Claro (Predeterminado)"
    case dark  = "Oscuro"
    case system = "Automático del sistema"
    var icon: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .system: return "circle.lefthalf.filled"
        }
    }
    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}
