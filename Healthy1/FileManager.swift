// FileManager.swift
import Foundation

func loadMedicineDetailsFromFile(fileName: String) -> [MedicineDetails]? {
    let fileManager = FileManager.default
    
    if let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                let jsonData = try Data(contentsOf: fileURL)

                // Convert jsonData to a String and print it
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("JSON Data as String: \(jsonString)")
                } else {
                    print("Failed to convert jsonData to String")
                }

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                // Decode the JSON as a TableData object
                let tableData = try decoder.decode(TableData.self, from: jsonData)
                
                return tableData.rows // Return the array of medicine details
            } catch {
                print("Error reading or decoding JSON file: \(error)")
            }
        }
    }
    return nil
}
