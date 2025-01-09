import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/ianzhang/Desktop/Personal Coding Projects/Healthy1/Healthy1/InputDetails.swift", line: 1)
import SwiftUI

struct InputDetails: View {
    var recognizedText: String
    var imageTaken: UIImage  // You may want to handle this image passed in

    var body: some View {
        NavigationView {
            VStack {
                // Navigation to Medicine Detail Page
                NavigationLink(destination: MedicineDetailView(
                    medicineName: __designTimeString("#6362_0", fallback: "Aspirin"),
                    imageName: __designTimeString("#6362_1", fallback: "catimg"),  // Replace with the actual image name in your assets
                    description: __designTimeString("#6362_2", fallback: "Aspirin is used to reduce fever and relieve mild to moderate pain from conditions such as muscle aches, toothaches, common cold, and headaches."),
                    dosage: __designTimeString("#6362_3", fallback: "Take 1 tablet (500mg) every 4-6 hours as needed. Do not exceed 4 tablets in a 24-hour period."),
                    sideEffects: __designTimeString("#6362_4", fallback: "Common side effects include nausea, vomiting, stomach pain, or heartburn. Consult your doctor if any severe reactions occur.")
                )) {
                    Text(__designTimeString("#6362_5", fallback: "View Aspirin Details"))
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(__designTimeInteger("#6362_6", fallback: 10))
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle(__designTimeString("#6362_7", fallback: "Medicine Information"))
        }
    }
}

struct MedicineDetailView: View {
    var medicineName: String
    var imageName: String
    var description: String
    var dosage: String
    var sideEffects: String

    var body: some View {
        ScrollView {
            VStack(spacing: __designTimeInteger("#6362_8", fallback: 20)) {
                // Medicine Image
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: __designTimeInteger("#6362_9", fallback: 200), height: __designTimeInteger("#6362_10", fallback: 200))
                    .clipShape(RoundedRectangle(cornerRadius: __designTimeInteger("#6362_11", fallback: 20)))
                    .shadow(radius: __designTimeInteger("#6362_12", fallback: 10))

                // Medicine Name
                Text(medicineName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, __designTimeInteger("#6362_13", fallback: 10))

                // Description Section
                VStack(alignment: .leading, spacing: __designTimeInteger("#6362_14", fallback: 15)) {
                    Text(__designTimeString("#6362_15", fallback: "Description"))
                        .font(.headline)
                        .padding(.bottom, __designTimeInteger("#6362_16", fallback: 5))
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)

                    // Dosage Section
                    Text(__designTimeString("#6362_17", fallback: "Dosage"))
                        .font(.headline)
                        .padding(.bottom, __designTimeInteger("#6362_18", fallback: 5))
                    Text(dosage)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)

                    // Side Effects Section
                    Text(__designTimeString("#6362_19", fallback: "Side Effects"))
                        .font(.headline)
                        .padding(.bottom, __designTimeInteger("#6362_20", fallback: 5))
                    Text(sideEffects)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(__designTimeInteger("#6362_21", fallback: 10))
                .shadow(radius: __designTimeInteger("#6362_22", fallback: 5))

                Spacer()
            }
            .padding()
        }
        .navigationTitle(__designTimeString("#6362_23", fallback: "Medicine Details"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
