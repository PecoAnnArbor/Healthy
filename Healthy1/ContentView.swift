import SwiftUI

struct ContentView: View {
    @State private var isShowingCamera = false
    @State private var image: UIImage?
    @State private var recognizedText: String? = nil
    @State private var isShowingDetails = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.white]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all) // Fill the entire screen
                
                VStack {
                    ProjectName(name: "MediVault")
                    Text("Welcome to the Medication Tracker!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    Image("mediiVault")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                    Spacer()
                    Text("Click to Start Scanning!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 40)

                    Spacer()
                    
//                    // Display captured image if available
//                    if let image = image {
//                        Image(uiImage: image)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 200, height: 200)
//                    } else {
//                        Image("medicinebottle")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 200, height: 200)
//                    }
                    
                    HStack {
                        Button(action: {
                            isShowingCamera = true // Show camera when the Scan button is pressed
                        }) {
                            Text("Scan")
                        }
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(10)
                        .fullScreenCover(isPresented: $isShowingCamera) {
                            ImagePicker(sourceType: .camera, selectedImage: $image, recognizedText: $recognizedText).ignoresSafeArea()
                        }
                        
                        NavigationLink(destination: MedicineListView()) {
                            Text("View List")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .foregroundColor(.blue)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                        
//                        // Additional Button Example
//                        NavigationLink(destination: AnotherView()) {
//                            Text("View Medications")
//                                .font(.headline)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(Color.white)
//                                .foregroundColor(.blue)
//                                .cornerRadius(10)
//                                .shadow(radius: 5)
//                        }
//                        .padding(.horizontal)
                    }
                    
                    // Navigate to the InputDetails view once recognizedText is not nil
                    NavigationLink(
                        destination: InputDetails(recognizedText: recognizedText ?? "", imageTaken: image ?? UIImage(), onDisappearAction: {
                            // Reset state when the detail view disappears
                            self.isShowingDetails = false
                            self.recognizedText = nil // Reset recognized text
                        }),
                        isActive: $isShowingDetails
                    ) {
                        EmptyView() // No actual button here, automatic navigation
                    }
                    .onChange(of: recognizedText) { newText in
                        if newText != nil {
                            isShowingDetails = true // Automatically navigate once recognizedText is available
                        }
                    }
                    
                    Spacer()  // This ensures the content expands to fill the screen
                }
            }
        }
    }
}

struct ScanButton: View {
    var title: String
    var textColor: Color
    var backgroundColor: Color
    var body: some View {
        Text(title)
            .frame(width: 100, height: 50)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .font(.system(size: 20, weight: .bold, design: .default))
            .cornerRadius(20)
    }
}

struct ProjectName: View {
    var name: String
    var body: some View {
        Text(name)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundStyle(.white)
            .padding()
    }
}

struct ResultView: View {
    var recognizedText: String

    var body: some View {
        VStack {
            Text("Recognized Text:")
                .font(.title)
                .padding()

            Text(recognizedText)
                .padding()
                .font(.body)

            Spacer()  // This ensures the content expands to fill the screen
        }
        .ignoresSafeArea(edges: .all)  // Ensure the view ignores safe areas if needed
        .navigationTitle("Scan Result")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
