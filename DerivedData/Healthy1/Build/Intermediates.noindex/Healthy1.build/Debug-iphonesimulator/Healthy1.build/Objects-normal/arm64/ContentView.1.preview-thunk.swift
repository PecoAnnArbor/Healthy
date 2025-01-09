import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/ianzhang/Desktop/Personal Coding Projects/Healthy1/Healthy1/ContentView.swift", line: 1)
//
//  ContentView.swift
//  Healthy1
//
//  Created by Ian Zhang on 9/28/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingCamera = false
    @State private var image: UIImage?
    @State private var recognizedText: String? = nil

    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                ProjectName(name: __designTimeString("#5024_0", fallback: "MediVault"))
                Spacer()
                
                // Display captured image if available
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: __designTimeInteger("#5024_1", fallback: 200), height: __designTimeInteger("#5024_2", fallback: 200))
                } else {
                    Image(__designTimeString("#5024_3", fallback: "medicinebottle"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: __designTimeInteger("#5024_4", fallback: 200), height: __designTimeInteger("#5024_5", fallback: 200))
                }
                
                HStack {
                    Button(action: {
                        isShowingCamera = __designTimeBoolean("#5024_6", fallback: true) // Show camera when the Scan button is pressed
                    }) {
                        ScanButton(title: __designTimeString("#5024_7", fallback: "Scan"), textColor: .white, backgroundColor: .mint)
                    }
                    .padding(__designTimeInteger("#5024_8", fallback: 10))
                    .fullScreenCover(isPresented: $isShowingCamera) {
                        ImagePicker(sourceType: .camera, selectedImage: $image, recognizedText: $recognizedText).ignoresSafeArea()
                    }
                    
                    Button {
                        // Handle Db1 action
                    } label: {
                        ScanButton(title: __designTimeString("#5024_9", fallback: "Db1"), textColor: .white, backgroundColor: .mint)
                    }
                    .padding(__designTimeInteger("#5024_10", fallback: 10))
                    
                    Button {
                        // Handle Db2 action
                    } label: {
                        ScanButton(title: __designTimeString("#5024_11", fallback: "Db2"), textColor: .white, backgroundColor: .mint)
                    }
                    .padding(__designTimeInteger("#5024_12", fallback: 10))
                }
                
                // Navigate to the result view once recognizedText is not nil
                if let text = recognizedText {
                    NavigationLink(destination: ResultView(recognizedText: text)) {
                        Text(__designTimeString("#5024_13", fallback: "View Result"))
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(__designTimeInteger("#5024_14", fallback: 10))
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

struct ScanButton: View {
    var title: String
    var textColor: Color
    var backgroundColor: Color
    var body: some View {
        Text(title)
            .frame(width: __designTimeInteger("#5024_15", fallback: 100), height: __designTimeInteger("#5024_16", fallback: 50))
            .background(backgroundColor)
            .foregroundColor(textColor)
            .font(.system(size: __designTimeInteger("#5024_17", fallback: 20), weight: .bold, design: .default))
            .cornerRadius(__designTimeInteger("#5024_18", fallback: 20))
    }
}

struct ProjectName: View {
    var name: String
    var body: some View {
        Text(name)
            .font(.system(size: __designTimeInteger("#5024_19", fallback: 32), weight: .medium, design: .default))
            .foregroundStyle(.white)
            .padding()
    }
}

struct BackgroundView: View {
    var body: some View {
        ContainerRelativeShape()
            .fill(Color.purple.gradient)
            .ignoresSafeArea()
    }
}

struct ResultView: View {
    var recognizedText: String
    
    var body: some View {
        VStack {
            Text(__designTimeString("#5024_20", fallback: "Recognized Text:"))
                .font(.title)
                .padding()
            
            Text(recognizedText)
                .padding()
                .font(.body)
            
            Spacer()
        }
        .navigationTitle(__designTimeString("#5024_21", fallback: "Scan Result"))
        .navigationBarTitleDisplayMode(.inline)
    }
}
