//
//  IconPreviewView.swift
//  RadicleApp
//
//  Created by bordumb on 26/02/2025.
//

import SwiftUI
import SwiftSVG  // Required for SVG support

struct IconPreviewView: View {
    @State private var iconSize: CGFloat = 48
    @State private var iconColor: Color = .blue
    @State private var isSVG: Bool = true  // Toggle between SVG and PNG
    
    let iconName = "icon_name"  // Change this to your actual icon name
    
    var body: some View {
        VStack {
            Text("Icon Preview")
                .font(.headline)
                .foregroundColor(.white)

            if isSVG {
                SVGIconView(iconName: iconName, size: iconSize, color: UIColor(iconColor))
                    .frame(width: iconSize, height: iconSize)
            } else {
                PNGIconView(iconName: iconName, size: iconSize, color: UIColor(iconColor))
                    .frame(width: iconSize, height: iconSize)
            }
            
            // Toggle between SVG & PNG
            Toggle("Use SVG", isOn: $isSVG)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .padding()
            
            // Size Slider
            VStack {
                Text("Size: \(Int(iconSize)) px")
                Slider(value: $iconSize, in: 24...200)
            }
            .padding()
            
            // Color Picker
            VStack {
                Text("Color")
                ColorPicker("Pick Color", selection: $iconColor)
                    .labelsHidden()
            }
            .padding()
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

// MARK: - UIViewRepresentable for SVG
struct SVGIconView: UIViewRepresentable {
    let iconName: String
    let size: CGFloat
    let color: UIColor
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        if let url = Bundle.main.url(forResource: iconName, withExtension: "svg") {
            let svgView = UIView(svgURL: url) { layer in
                layer.fillColor = color.cgColor
            }
            svgView.frame = view.bounds
            view.addSubview(svgView)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        uiView.frame = CGRect(x: 0, y: 0, width: size, height: size)
    }
}

// MARK: - UIViewRepresentable for PNG
struct PNGIconView: UIViewRepresentable {
    let iconName: String
    let size: CGFloat
    let color: UIColor
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let imageView = UIImageView(image: UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = color
        imageView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        view.addSubview(imageView)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let imageView = uiView.subviews.first as? UIImageView {
            imageView.frame = CGRect(x: 0, y: 0, width: size, height: size)
            imageView.tintColor = color
        }
    }
}

// MARK: - SwiftUI Preview
#Preview {
    IconPreviewView()
}
