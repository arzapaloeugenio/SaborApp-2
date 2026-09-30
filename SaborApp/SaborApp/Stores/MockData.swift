//
//  MockData.swift
//  SaborApp
//

import Foundation

enum MockData {

    static let dishes: [Dish] = [
        Dish(name: "Hamburguesa Trufada Sabor",
             description: "Carne madurada 180g, queso brie fundido, cebolla caramelizada y mahonesa de trufa negra.",
             price: 14.50, rating: 4.9, reviews: 420, prepTime: "15-20 min", calories: 680,
             category: "Hamburguesas", tags: ["Plato de Autor"], badge: "Top Ventas",
             imageKey: "Hamburguesa Trufada Sabor"),
        Dish(name: "Tagliatelle al Pesto de Pistacho",
             description: "Pasta fresca al huevo elaborada a diario, pesto siciliano y stracciatella fresca de Puglia.",
             price: 15.20, rating: 4.8, reviews: 215, prepTime: "15-25 min", calories: 590,
             category: "Pastas", tags: ["Vegetariano"],
             imageKey: "Tagliatelle al Pesto de Pistacho"),
        Dish(name: "Costillar Ibérico a Baja Temperatura",
             description: "Cocinado durante 24 horas, glaseado con reducción de barbacoa de ciruelas y patatas rústicas.",
             price: 19.50, oldPrice: 22.90, rating: 4.9, reviews: 380, prepTime: "20-30 min", calories: 820,
             category: "Carnes", tags: ["Sin Gluten"], badge: "-15% Oferta",
             imageKey: "Costillar Ibérico a Baja Temperatura"),
        Dish(name: "Cheesecake de Queso Manchego",
             description: "Textura fluida horneada con corazón de queso curado D.O. Manchego y coulis de frambuesas.",
             price: 7.50, rating: 4.9, reviews: 640, prepTime: "Listo para servir", calories: 430,
             category: "Postres", tags: ["Premio Repostería"],
             imageKey: "Cheesecake de Queso Manchego"),
        Dish(name: "Smash Burger Doble Red Velvet",
             description: "Doble carne crispy smash, cheddar añejo fundido, bacon ahumado y salsa secreta Sabor.",
             price: 13.90, rating: 4.9, reviews: 530, prepTime: "15-20 min", calories: 790,
             category: "Hamburguesas", tags: ["Gluten", "Lácteos"], badge: "Top Ventas",
             imageKey: "Smash Burger Doble Red Velvet"),
        Dish(name: "Bowl Mediterráneo de Burrata",
             description: "Tomates cherry asados, pesto verde de albahaca, piñones tostados y focaccia de romero.",
             price: 12.80, rating: 4.7, reviews: 190, prepTime: "10-15 min", calories: 460,
             category: "Ensaladas", tags: ["Vegetariano", "Orgánico"],
             imageKey: "Bowl Mediterráneo de Burrata"),
        Dish(name: "Salmón Glaseado al Miso",
             description: "Espárragos trigueros y puré de chirivía.",
             price: 18.50, rating: 5.0, reviews: 128, prepTime: "20-25 min", calories: 540,
             category: "Pescados", badge: "Recomendado del Chef",
             imageKey: "Salmón Glaseado al Miso"),
        Dish(name: "Raviolis de Boletus y Foie",
             description: "Pasta fresca rellena con salsa de salvia suave y avellanas tostadas del Piamonte.",
             price: 16.90, rating: 4.8, reviews: 310, prepTime: "18-22 min", calories: 610,
             category: "Pastas",
             imageKey: "Raviolis de Boletus y Foie"),
        Dish(name: "Pizza Tartufata & Burrata",
             description: "Con trufa negra y burrata fresca de Puglia.",
             price: 13.20, oldPrice: 16.50, rating: 4.8, reviews: 275, prepTime: "18-22 min", calories: 720,
             category: "Pizza", badge: "-20% HOY",
             imageKey: "Pizza Tartufata & Burrata"),
        Dish(name: "Ramen Tonkotsu",
             description: "Caldo de cerdo 12h, huevo marinado y cerdo chashu.",
             price: 13.90, rating: 4.7, reviews: 96, prepTime: "15-20 min", calories: 650,
             category: "Pastas", imageKey: "Ramen Tonkotsu"),
        Dish(name: "Gyozas de Ibérico",
             description: "Empanadillas japonesas rellenas de cerdo ibérico.",
             price: 9.80, rating: 4.8, reviews: 142, prepTime: "12-15 min", calories: 380,
             category: "Entrantes", imageKey: "Gyozas de Ibérico"),
        Dish(name: "Cerveza Artesana IPA",
             description: "Lúpulo cítrico, cuerpo medio.",
             price: 3.80, rating: 4.6, reviews: 88, prepTime: "Al momento", calories: 180,
             category: "Bebidas", imageKey: "Cerveza Artesana IPA"),
        Dish(name: "Kombucha Frutos Bosque",
             description: "Fermentado natural de frutos rojos.",
             price: 3.50, rating: 4.5, reviews: 64, prepTime: "Al momento", calories: 45,
             category: "Bebidas", imageKey: "Kombucha Frutos Bosque"),
        Dish(name: "Bowl Burrata & Higos",
             description: "Higos caramelizados al balsámico y piñones tostados.",
             price: 14.50, rating: 4.8, reviews: 52, prepTime: "12-15 min", calories: 480,
             category: "Ensaladas", badge: "Nuevo", imageKey: "Bowl Burrata & Higos"),
    ]

    static let categories = ["Todas", "Hamburguesas", "Pastas", "Pizza", "Ensaladas", "Postres", "Bebidas"]
    static let categoryIcons = ["dinner_dining", "lunch_dining", "ramen_dining", "local_pizza", "nutrition", "cake", "local_bar"]

    static let addresses: [Address] = [
        Address(label: "Casa (Habitual)", icon: "house.fill",
                detail: "Calle Mayor 24, 3ºB, 28013 Madrid",
                note: "Dejar en conserjería o llamar al timbre. Portero físico de 9 a 20h.",
                phone: "+34 612 345 678", isDefault: true),
        Address(label: "Oficina Creativa", icon: "building.2.fill",
                detail: "Paseo de la Castellana 112, Planta 4, 28046 Madrid",
                note: "Entregar en recepción de la Torre. Pedir pase de visita para Sabor Delivery.",
                phone: nil, isDefault: false, schedule: "Lunes a Viernes"),
        Address(label: "Casa Padres", icon: "heart.fill",
                detail: "Avenida de América 18, 1º Izq, 28002 Madrid",
                note: "Llamar al móvil al llegar, portal automático.",
                phone: nil, isDefault: false, schedule: "Ocasional"),
    ]

    static let orders: [Order] = [
        Order(reference: "#SB-84920", date: "Hoy, 14:15", title: "Entrega prioritaria a domicilio",
              status: .inProgress, total: 41.60, payment: "Apple Pay",
              itemsSummary: "Burger Trufada, Tagliatelle al Pesto, Cheesecake",
              imageKeys: ["Hamburguesa Trufada Sabor", "Tagliatelle al Pesto de Pistacho", "Cheesecake de Queso Manchego"],
              eta: "En camino (~14:50)", dishCount: 3, progress: "Repartidor cerca de tu zona • Faltan 12 min"),
        Order(reference: "#SB-81042", date: "12 May 2024 • 21:30", title: "Cena en Casa Sabor",
              status: .delivered, total: 38.90, payment: "Mastercard •••• 4829",
              itemsSummary: "Costillar Ibérico x1, Bowl Burrata x1, Cerveza IPA x2",
              imageKeys: ["Costillar Ibérico a Baja Temperatura", "Bowl Mediterráneo de Burrata", "Cerveza Artesana IPA"],
              rating: 5.0, dishCount: 4),
        Order(reference: "#SB-76819", date: "28 Abr 2024 • 14:10", title: "Almuerzo de Amigos",
              status: .delivered, total: 34.20, payment: "Google Pay",
              itemsSummary: "Smash Burger Doble x2, Patatas rústicas x2, Kombucha x2",
              imageKeys: ["Smash Burger Doble Red Velvet", "Ramen Tonkotsu", "Kombucha Frutos Bosque"],
              rating: 5.0, dishCount: 6),
        Order(reference: "#SB-72104", date: "15 Abr 2024 • 20:45", title: "Menú Fusión Especial",
              status: .delivered, total: 31.70, payment: "Pago en efectivo",
              itemsSummary: "Salmón Glaseado al Miso x1, Pizza Tartufata x1",
              imageKeys: ["Salmón Glaseado al Miso", "Pizza Tartufata & Burrata"],
              rating: nil, dishCount: 2),
    ]

    static let notifications: [AppNotification] = [
        AppNotification(icon: "bicycle", kind: "En curso", time: "Hace 15 min",
                        title: "¡Tu pedido está en camino!",
                        body: "Carlos va en camino hacia tu puerta con tu Hamburguesa Trufada y Tagliatelle. Tiempo aprox. 12 min.",
                        unread: true, group: "Hoy", primaryAction: "Rastrear pedido"),
        AppNotification(icon: "percent", kind: "Promoción", time: "Hace 3 horas",
                        title: "25% de descuento en Platos de Autor",
                        body: "Usa el cupón SABOR25 en tu próxima cena gourmet. Válido hasta el domingo.",
                        unread: true, group: "Hoy", primaryAction: "Copiar cupón"),
        AppNotification(icon: "star.circle.fill", kind: "Sabor Club · Ayer, 20:30", time: "Ayer",
                        title: "Has sumado 120 puntos Sabor Club",
                        body: "Tu pedido #SB-84920 te acerca a tu próximo postre artesanal gratuito.",
                        unread: false, group: "Ayer"),
        AppNotification(icon: "fork.knife", kind: "Cocina de Autor · Ayer, 13:10", time: "Ayer",
                        title: "Nuevo plato de temporada en carta",
                        body: "El Chef Javier presenta el Bowl Mediterráneo de Burrata con higos caramelizados.",
                        unread: false, group: "Ayer", imageKey: "Bowl Burrata & Higos", price: 14.50),
        AppNotification(icon: "checkmark.circle.fill", kind: "Completado · 12 May, 22:00", time: "12 May",
                        title: "Pedido entregado con éxito",
                        body: "¿Qué te pareció el Costillar Ibérico? Valora tu experiencia para ganar 30 puntos.",
                        unread: false, group: "Esta semana", primaryAction: "Dejar valoración"),
        AppNotification(icon: "chart.bar.fill", kind: "Resumen · 10 May, 11:15", time: "10 May",
                        title: "Tu balance gastronómico semanal",
                        body: "Completaste 2 pedidos gourmet y ahorraste 18,20 € gracias a tus cupones.",
                        unread: false, group: "Esta semana"),
    ]

    static let trackingSteps: [TrackingStep] = [
        TrackingStep(icon: "checkmark", title: "Pedido recibido y confirmado",
                     subtitle: "El restaurante aceptó la orden", time: "14:15", state: .done),
        TrackingStep(icon: "checkmark", title: "Preparado con esmero",
                     subtitle: "Empacado en bolsas térmicas", time: "14:26", state: .done),
        TrackingStep(icon: "bicycle", title: "En camino a tu ubicación",
                     subtitle: "Pedaleando por Av. Libertador", time: "14:38", state: .active),
        TrackingStep(icon: "house.fill", title: "Entregado en mano",
                     subtitle: "Buen provecho", time: "~14:50", state: .pending),
    ]

    static func optionGroups(for dish: Dish) -> [OptionGroup] {
        [
            OptionGroup(title: "Punto de la carne", required: true, items: [
                OptionItem(name: "Al punto", extra: 0, note: "Recomendado", isDefault: true),
                OptionItem(name: "Poco hecha", extra: 0, note: nil),
                OptionItem(name: "Muy hecha", extra: 0, note: nil),
            ]),
            OptionGroup(title: "Guarnición incluida", required: true, items: [
                OptionItem(name: "Patatas gajo al romero", extra: 0, note: "Incluido", isDefault: true),
                OptionItem(name: "Boniato crujiente", extra: 1.00, note: "+1.00 €"),
                OptionItem(name: "Ensalada verde", extra: 0, note: "Incluido"),
            ]),
            OptionGroup(title: "Extras recomendados", required: false, multiSelect: true, items: [
                OptionItem(name: "Bacon ahumado crujiente", extra: 1.50, note: "+1.50 €"),
                OptionItem(name: "Huevo campero a la plancha", extra: 1.20, note: "+1.20 €"),
                OptionItem(name: "Extra salsa de trufa", extra: 1.00, note: "+1.00 €"),
            ]),
        ]
    }

    static let ingredients = [
        ("checkmark.seal.fill", "Ternera madurada 100%"),
        ("crown.fill", "Queso Brie AOC"),
        ("takeoutbag.and.cup.and.straw.fill", "Pan brioche mantequilla"),
        ("leaf.fill", "Trufa negra de verano"),
        ("fork.knife", "Cebolla dulce pochada"),
    ]
}
