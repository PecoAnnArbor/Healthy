import SwiftUI
import Foundation

struct TableData: Codable {
    var tableName: String
    var rows: [MedicineDetails]
    
    enum CodingKeys: String, CodingKey {
        case tableName = "table_name"
        case rows
    }
}

struct MedicineDetails: Codable {
    var recognizedText: String
    var selectedType: String
    var quantity: String
    var updatedDate: Date
    var imageLocation: String?
    
    enum CodingKeys: String, CodingKey {
        case recognizedText = "MedName"
        case selectedType = "MedType"
        case quantity = "Quantity"
        case updatedDate = "UpdateDate"
        case imageLocation = "ImageLocation"
    }
}





struct InputDetails: View {
    @State var recognizedText: String
    var imageTaken: UIImage  // Handle this image passed in
    let onDisappearAction: () -> Void
    
    @State private var selectedType = "Capsules" // Default type
    @State private var quantity: String = "1" // Quantity input
    @State private var updatedDate: Date = Date() // Current date
    @Environment(\.presentationMode) var presentationMode // For dismissing the view

    var body: some View {
        VStack {
            // Medicine Detail Page Content
            MedicineDetailView(
                medicineName: $recognizedText,
                imageName: imageTaken,  // Replace with actual image name
                selectedType: $selectedType,
                quantity: $quantity,
                updatedDate: $updatedDate
            )

            // Submit Button
            Button(action: submitData) {
                Text("Submit")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .onDisappear {
            // Reset the state when this view disappears
            onDisappearAction()
        }
    }

    private func submitData() {
        // Create a MedicineDetails object
        let medicineDetails = MedicineDetails(
            recognizedText: recognizedText,
            selectedType: selectedType,
            quantity: quantity,
            updatedDate: updatedDate
        )

        // Append the new MedicineDetails object to the JSON file
        do {
            try appendMedicineDetailsToJSONFile(medicineDetails: medicineDetails, fileName: "medicineDetails.json")
            print("Data appended to JSON file.")
        } catch {
            print("Error appending data to JSON: \(error)")
        }

        // Dismiss the current view to go back to the home page
        presentationMode.wrappedValue.dismiss()
    }
    private func appendMedicineDetailsToJSONFile(medicineDetails: MedicineDetails, fileName: String) throws {
        let fileManager = FileManager.default

        // Get the document directory path
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)

            var existingMedicineDetails: [MedicineDetails] = []
            
            // Check if the file already exists
            if fileManager.fileExists(atPath: fileURL.path) {
                // If the file exists, read the existing data
                do {
                    let jsonData = try Data(contentsOf: fileURL)
                    // Decode the existing JSON data into a TableData object
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let existingTableData = try decoder.decode(TableData.self, from: jsonData)
                    existingMedicineDetails = existingTableData.rows
                } catch {
                    print("Error reading existing JSON data: \(error)")
                }
            }

            // Append the new medicine details to the existing array
            existingMedicineDetails.append(medicineDetails)

            // Wrap it in the TableData structure
            let tableData = TableData(tableName: "abc", rows: existingMedicineDetails)

            // Convert the updated structure back to JSON
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            encoder.dateEncodingStrategy = .iso8601
            let updatedJsonData = try encoder.encode(tableData)

            // Write the updated JSON data back to the file
            try updatedJsonData.write(to: fileURL)
            print("JSON file updated with new data: \(fileURL)")

            // Optional: Print the updated file contents
            printJSONFileContents(fileName: fileName)
        }
    }



    private func printJSONFileContents(fileName: String) {
        let fileManager = FileManager.default
        
        // Get the document directory path
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            do {
                // Read the JSON data from the file
                let jsonData = try Data(contentsOf: fileURL)
                
                // Convert JSON data to a string for printing
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("JSON File Contents:\n\(jsonString)")
                }
            } catch {
                print("Error reading JSON file: \(error)")
            }
        }
    }
    
    func loadMedicineDetailsFromFile(fileName: String) -> [MedicineDetails]? {
        let fileManager = FileManager.default
        
        // Get the document directory path
        if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            
            // Check if the file exists
            if fileManager.fileExists(atPath: fileURL.path) {
                do {
                    // Read the JSON data from the file
                    let jsonData = try Data(contentsOf: fileURL)
                    
                    // Decode the JSON data into an array of MedicineDetails
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601 // Ensure date is decoded properly
                    let medicineDetailsArray = try decoder.decode([MedicineDetails].self, from: jsonData)
                    
                    return medicineDetailsArray // Return the decoded data
                } catch {
                    print("Error reading or decoding JSON file: \(error)")
                }
            }
        }
        return nil
    }

}

struct MedicineDetailView: View {
    @Binding var medicineName: String
    var imageName: UIImage
    @Binding var selectedType: String // Bind to InputDetails state
    @Binding var quantity: String // Bind to InputDetails state
    @Binding var updatedDate: Date // Bind to InputDetails state
    

    let types = ["Capsules", "Pills", "Liquids", "Ointments", "Drops", "Equipments", "Others"] // Medication types

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Medicine Image
                Image(uiImage: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)

                // Medicine Name
                VStack(alignment: .leading) {
                
                    Text("Medicine Name")
                        .font(.headline)
                        .padding(.bottom, 5)
                    TextField("",text: $medicineName)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    hideKeyboard()
                                }
                            }
                        }
                }.padding(.vertical)


                // Type Picker
                VStack(alignment: .leading) {
                    Text("Type")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Picker("Select Type", selection: $selectedType) {
                        ForEach(types, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // or .wheel or .segmented
                    .frame(maxWidth:.infinity)
                    .frame(height:20)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }

                // Quantity Input
                VStack(alignment: .leading) {
                    Text("Quantity")
                        .font(.headline)
                        .padding(.bottom, 5)
                    TextField("Enter quantity", text: $quantity)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
//                        .toolbar {
//                            ToolbarItemGroup(placement: .keyboard) {
//                                Spacer()
//                                Button("Done") {
//                                    hideKeyboard()
//                                }
//                            }
//                        }
                }
                .padding(.vertical)

                // Updated Date Picker
                VStack(alignment: .leading) {
                    Text("Date Updated")
                        .font(.headline)
                        .padding(.bottom, 5)
                    DatePicker("Select date", selection: $updatedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Medicine Details")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InputDetails(recognizedText: "Sample Text", imageTaken: UIImage(), onDisappearAction: {})
    }
}



extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
