import SwiftUI

struct MedicineListView: View {
    @State private var medicineDetails: [MedicineDetails] = []

    var body: some View {
        ZStack {
            VStack {
                if medicineDetails.isEmpty {
                    Text("No medicine details available")
                        .font(.headline)
                        .padding()
                } else {
                    List {
                        ForEach($medicineDetails, id: \.recognizedText) { $detail in
                            VStack(alignment: .leading) {
                                Text("Medicine Name: \(detail.recognizedText)")
                                Text("Type: \(detail.selectedType)")
                                Text("Date: \(detail.updatedDate, style: .date)")
                                
                                HStack {
                                    // Stepper to increase or decrease quantity
                                    Stepper(value: Binding(
                                        get: { Int(detail.quantity) ?? 0 },
                                        set: { newValue in
                                            detail.quantity = "\(newValue)"
                                        }), in: 0...100) {
                                        Text("Quantity: \(detail.quantity)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                if let loadedData = loadMedicineDetailsFromFile(fileName: "medicineDetails.json") {
                    medicineDetails = loadedData
                }
            }
            .navigationTitle("Medicine List")
            
            // Buttons overlay
            VStack {
                Spacer() // Push the buttons to the bottom
                HStack {
                    Spacer() // Push the buttons to the right
                    
                    // Merge Button
                    Button(action: {
                        sendPostRequest(with: medicineDetails)
                    }) {
                        Text("Merge")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                    }
                    .padding() // Add padding to keep it away from the edges
                    
                    // Save Button
                    Button(action: {
                        saveMedicineDetailsToFile(medicineDetails: medicineDetails, fileName: "medicineDetails.json")
                    }) {
                        Text("Save")
                            .font(.headline)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                    }
                    .padding()
                }
            }
        }
    }
    
    // Function to save the updated medicine details to the JSON file
    func saveMedicineDetailsToFile(medicineDetails: [MedicineDetails], fileName: String) {
        do {
            let fileManager = FileManager.default
            if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                
                let tableData = TableData(tableName: "abc", rows: medicineDetails)
                
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                encoder.dateEncodingStrategy = .iso8601
                let jsonData = try encoder.encode(tableData)
                
                try jsonData.write(to: fileURL)
                print("Successfully saved updated medicine details to \(fileName).")
            }
        } catch {
            print("Error saving medicine details to file: \(error)")
        }
    }
    
    
    func sendPostRequest(with details: [MedicineDetails]) {
        // Ensure that the URL is valid
        guard let url = URL(string: "http://34.45.71.72/add_rows") else {
            print("Invalid URL")
            return
        }

        // Create the URLRequest object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Wrap the medicine details array in a TableData structure
        let tableData = TableData(tableName: "abc", rows: details)
        
        // Convert the TableData object to JSON data
        do {
            let jsonData = try JSONEncoder().encode(tableData)
            request.httpBody = jsonData
        } catch {
            print("Failed to encode table data: \(error)")
            return
        }
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending POST request: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }
            
            // Handle the response data
            if let data = data {
                print("Response data: \(String(decoding: data, as: UTF8.self))")
                
                // Overwrite the JSON file with the response data
                do {
                    let fileManager = FileManager.default
                    if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let fileURL = documentsDirectory.appendingPathComponent("medicineDetails.json")
                        
                        // Decode the response into the TableData structure
                        var updatedTableData = try JSONDecoder().decode(TableData.self, from: data)
                        
                        // Set the updated date for all medicine details to the current date
                        updatedTableData.rows = updatedTableData.rows.map { medicineDetail in
                            var updatedDetail = medicineDetail
                            updatedDetail.updatedDate = Date() // Set to current date
                            return updatedDetail
                        }
                        
                        // Encode and save the updated data back to the file
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = .prettyPrinted
                        encoder.dateEncodingStrategy = .iso8601
                        let updatedJsonData = try encoder.encode(updatedTableData)
                        
                        try updatedJsonData.write(to: fileURL)
                        print("Successfully updated the local JSON file with current time.")
                    }
                } catch {
                    print("Error saving the response data to JSON file: \(error)")
                }
            }
        }
        
        task.resume() // Start the task
    }

}
