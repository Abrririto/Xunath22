//
//  StatusBarView.swift
//  Xunath
//
//  Created by Paulo César on 16/11/22.
//

import SwiftUI

enum StatusBar: String {
    case health = "bar_life"
    case mana = "bar_energy"
    case experience = "bar_xp"
    
    var color: Color {
        switch self {
        case .health:
            return .purple
        case .mana:
            return .blue
        case .experience:
            return .yellow
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}

struct StatusBarView: View {
    var color: Color = .black
    var barType: StatusBar
    @Binding var percentage: Float
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image(barType.rawValue)
//                .colorInvert()
//                .colorMultiply(.red)
                .padding(-18)
            
            HStack(spacing: 0) {
                Rectangle()
                    .foregroundColor(barType.color)
                    .frame(width: barType == .mana ? (170 * CGFloat(percentage)) : (155 * CGFloat(percentage)), height: 11)
                Triangle()
                    .foregroundColor(barType.color)
                    .frame(width: 15, height: 20)
                    .rotationEffect(Angle(degrees: 90))
            }
            .zIndex(-1)
//            .padding([.leading], barType == .mana ? 35 : 50)
            .offset(x: barType == .mana ? 20 : 32)
//            .position(x: barType == .mana ? 35 : 500)
            .padding([.top], 39)
                
        }
        .ignoresSafeArea()
    }
}

//struct StatusBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        VStack(spacing: 0) {
//            StatusBarView(barType: .health, percentage: 0.75)
//            StatusBarView(barType: .mana, percentage: 0.2)
//            StatusBarView(barType: .experience, percentage: 0.5)
//        }
//
//        VStack(spacing: 0) {
//            StatusBarView(barType: .health, percentage: 1)
//            StatusBarView(barType: .mana, percentage: 1)
//            StatusBarView(barType: .experience, percentage: 1)
//        }
//
//        VStack(spacing: 0) {
//            StatusBarView(barType: .health, percentage: 0)
//            StatusBarView(barType: .mana, percentage: 0)
//            StatusBarView(barType: .experience, percentage: 0)
//        }
//    }
//}
