//
//  RegisterView.swift
//  SaborApp
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var state: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var surname = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirm = ""
    @State private var acceptedTerms = false
    @State private var wantsOffers = true
    @State private var showPassword = false

    var body: some View {
        ZStack {
            SaborCanvas()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: SaborSpacing.md) {
                    header
                    giftBanner
                    SaborTextField(label: "Nombre", placeholder: "Valentina", icon: "person.fill", text: $name)
                    SaborTextField(label: "Apellidos", placeholder: "González", text: $surname)
                    SaborTextField(label: "Correo electrónico", placeholder: "valentina@correo.com",
                                   icon: "envelope.fill", text: $email, keyboard: .emailAddress)
                    phoneField
                    passwordField
                    SaborTextField(label: "Confirmar contraseña", placeholder: "••••••••",
                                   icon: "lock.rotation", text: $confirm, isSecure: true)
                    strengthMeter
                    consentRows
                    SaborPrimaryButton(title: "Crear cuenta y comenzar", icon: "arrow.right") {
                        state.signIn(); dismiss()
                    }
                    divider("o regístrate con")
                    socialRow
                    loginPrompt
                }
                .padding(SaborSpacing.margin)
                .padding(.top, 12)
                .padding(.bottom, 60)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.sm) {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "arrow.left").font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(SaborColor.onSurface)
                        .frame(width: 38, height: 38).background(SaborColor.container, in: Circle())
                }
                Spacer()
                Text("Paso 1 de 2: Datos de cuenta").font(SaborFont.labelSm)
                    .foregroundStyle(SaborColor.onSurfaceVariant)
            }
            Text("Crea tu cuenta Sabor").font(SaborFont.headlineLg).foregroundStyle(SaborColor.onSurface)
            Text("Únete al club gastronómico y recibe 10 € de bienvenida en tu primer pedido artesanal.")
                .font(SaborFont.bodyMd).foregroundStyle(SaborColor.onSurfaceVariant)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var giftBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "gift.fill").foregroundStyle(SaborColor.tertiary)
            Text("10 € de regalo para nuevos miembros").font(SaborFont.labelMd)
                .foregroundStyle(SaborColor.onSurface)
        }
        .padding(.horizontal, 12).padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(SaborColor.tertiaryFixed.opacity(0.5), in: RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous))
    }

    private var phoneField: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Teléfono móvil").font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurfaceVariant)
            HStack(spacing: 8) {
                Text("🇪🇸 +34").font(SaborFont.labelMd).foregroundStyle(SaborColor.onSurface)
                Divider().frame(height: 22)
                TextField("612 345 678", text: $phone)
                    .font(SaborFont.bodyMd).keyboardType(.phonePad)
                Image(systemName: "smartphone").foregroundStyle(SaborColor.onSurfaceVariant)
            }
            .padding(.horizontal, 14).frame(height: 50)
            .background(SaborColor.containerLowest, in: RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: SaborRadius.md, style: .continuous)
                .stroke(SaborColor.sandStrong, lineWidth: 1))
        }
    }

    private var passwordField: some View {
        SaborTextField(label: "Contraseña", placeholder: "••••••••", icon: "lock.fill",
                       text: $password, isSecure: !showPassword,
                       trailingIcon: showPassword ? "eye.slash.fill" : "eye.fill",
                       trailingAction: { showPassword.toggle() })
    }

    private var strengthMeter: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                ForEach(0..<4, id: \.self) { i in
                    Capsule().fill(i < 3 ? SaborColor.secondary : SaborColor.sand)
                        .frame(height: 4)
                }
            }
            HStack(spacing: 5) {
                Image(systemName: "checkmark.seal.fill").font(.system(size: 11))
                    .foregroundStyle(SaborColor.secondary)
                Text("Fuerte y Segura").font(SaborFont.labelSm).foregroundStyle(SaborColor.secondary)
                Text("· Excelente combinación").font(SaborFont.labelSm)
                    .foregroundStyle(SaborColor.onSurfaceVariant)
            }
        }
    }

    private var consentRows: some View {
        VStack(alignment: .leading, spacing: SaborSpacing.sm) {
            checkRow($acceptedTerms,
                     leading: "Acepto los",
                     link: "Términos del Servicio",
                     trailing: "y la Política de Privacidad de Sabor.")
            checkRow($wantsOffers, leading: nil, link: nil,
                     trailing: "Deseo recibir ofertas exclusivas, novedades del chef y promociones culinarias por email y SMS.")
        }
        .padding(.top, 4)
    }

    private func checkRow(_ binding: Binding<Bool>, leading: String?, link: String?, trailing: String) -> some View {
        Button { binding.wrappedValue.toggle() } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: binding.wrappedValue ? "checkmark.square.fill" : "square")
                    .font(.system(size: 17))
                    .foregroundStyle(binding.wrappedValue ? SaborColor.primary : SaborColor.sandStrong)
                (Text(leading ?? "") + Text(link ?? "").foregroundColor(SaborColor.primary) + Text(trailing))
                    .font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurface)
                    .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
            }
        }
        .buttonStyle(.plain)
    }

    private func divider(_ text: String) -> some View {
        HStack(spacing: 12) {
            Rectangle().fill(SaborColor.sand).frame(height: 1)
            Text(text).font(SaborFont.labelSm).foregroundStyle(SaborColor.onSurfaceVariant).fixedSize()
            Rectangle().fill(SaborColor.sand).frame(height: 1)
        }
    }

    private var socialRow: some View {
        HStack(spacing: SaborSpacing.md) {
            social("globe", "Google"); social("apple.logo", "Apple")
        }
    }
    private func social(_ icon: String, _ title: String) -> some View {
        Button { state.signIn(); dismiss() } label: {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 14, weight: .semibold))
                Text(title).font(SaborFont.labelMd)
            }
            .foregroundStyle(SaborColor.onSurface)
            .frame(maxWidth: .infinity).frame(height: 46)
            .background(SaborColor.containerLowest, in: Capsule())
            .overlay(Capsule().stroke(SaborColor.sand, lineWidth: 1))
        }
    }

    private var loginPrompt: some View {
        HStack(spacing: 4) {
            Spacer()
            Text("¿Ya tienes una cuenta?").font(SaborFont.bodySm).foregroundStyle(SaborColor.onSurfaceVariant)
            Button { dismiss() } label: {
                Text("Iniciar sesión").font(SaborFont.labelMd).foregroundStyle(SaborColor.primary)
            }
            Spacer()
        }
    }
}
