//
//  LocalFileManager.swift
//  Crypto_info
//
//  Created by gikwegbu on 08/08/2024.
//

import Foundation
import SwiftUI

// Later, try making the save, get a little more robust, to carter for any file at all, all you need do is to include an enum of the file type you wanna save... .image, .video, .mp3, .doc etc, so that you will handle the folderName and file creation properly...

class LocalFileManager {
	
	static let instance = LocalFileManager()
	
	private init() {}
	
	func saveImage(image: UIImage, imageName: String, folderName: String) {
		
		// Create folder if it doesn't exist firstly...
		createFolderIfNeeded(folderName: folderName)
		
		// At this point, if the folder doesn't exist initially, it must have been created with the above call,
		// Now we get the image full url and then  write to the FileManager.
		guard
			let data = image.pngData(),
			let url = getURLForImage(imageName: imageName, folderName: folderName)
		else { return }
		
		do{
			try data.write(to: url)
		} catch let error {
			print("Error saving \(imageName) image at Folder:\(folderName):::: \(error)")
		}
	}
	
	func getImage(imageName: String, folderName: String) -> UIImage? {
		guard 
			let url = getURLForImage(imageName: imageName, folderName: folderName),
			FileManager.default.fileExists(atPath: url.path)
			else { return nil }
			
		return UIImage(contentsOfFile: url.path)
	}
	
	private func createFolderIfNeeded(folderName: String) {
		guard let url = getURLForFoldder(folderName: folderName)  else  { return }
		if !FileManager.default.fileExists(atPath: url.path) {
			do {
				try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
			} catch let error {
				print("Error creating Folder: \(folderName):::: \(error)")
			}
		}
	}
	
	private func getURLForFoldder(folderName: String) -> URL? {
		guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first 
		else { return nil}
		
		return url.appendingPathComponent(folderName)
	}
	
	private func getURLForImage(imageName: String, folderName: String) -> URL? {
		guard let folderURL = getURLForFoldder(folderName: folderName) 
		else { return nil}
		
		return folderURL.appendingPathComponent(imageName + ".png")
	}
}
