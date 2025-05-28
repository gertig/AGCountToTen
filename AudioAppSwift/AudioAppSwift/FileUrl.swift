import Foundation

class FileUrl {
    let fileName: String
    let time: String // Not actively used in the RubyMotion code, but included for consistency

    init(fileName: String, time: String = "") {
        self.fileName = fileName
        self.time = time
    }

    var documentsDirectoryURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    var recorderFileURL: URL {
        // Files are stored with a .caf extension, similar to the RubyMotion app
        return documentsDirectoryURL.appendingPathComponent(fileName).appendingPathExtension("caf")
    }

    var defaultFileURL: URL? {
        // Assuming default files are also .caf and located in the main bundle
        // The fileName for default files might not need a .caf extension initially,
        // as Bundle.main.url(forResource:withExtension:) handles it.
        // If fileName already contains an extension, it might cause issues.
        // For now, assuming fileName is the base name without extension for default files.
        return Bundle.main.url(forResource: fileName, withExtension: "caf")
    }

    func renamedFileURL(newName: String) -> URL {
        return documentsDirectoryURL.appendingPathComponent(newName).appendingPathExtension("caf")
    }

    func deleteFile() -> Bool {
        do {
            try FileManager.default.removeItem(at: recorderFileURL)
            return true
        } catch {
            print("Error deleting file \(recorderFileURL.lastPathComponent): \(error)")
            return false
        }
    }

    func exists() -> Bool {
        return FileManager.default.fileExists(atPath: recorderFileURL.path)
    }

    func renameFile(to newName: String) -> Bool {
        guard exists() else {
            print("File \(recorderFileURL.lastPathComponent) does not exist, cannot rename.")
            return false
        }
        let newURL = renamedFileURL(newName: newName)
        do {
            try FileManager.default.moveItem(at: recorderFileURL, to: newURL)
            // Update the fileName property if the class instance is to be reused
            // self.fileName = newName // This would require fileName to be a var
            print("File renamed to \(newURL.lastPathComponent)")
            return true
        } catch {
            print("Error renaming file \(recorderFileURL.lastPathComponent) to \(newURL.lastPathComponent): \(error)")
            return false
        }
    }
}
