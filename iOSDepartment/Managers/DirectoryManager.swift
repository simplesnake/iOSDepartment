//
//  DirectoryManager.swift
//  iOSDepartment
//
//  Created by Aleksandr Stroev on 16.08.2024.
//  Copyright © 2024 7Winds. All rights reserved.
//

import Foundation

class DirectoryManager {
    
    ///Папка приложения
    let appDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    ///Папка текущего  экземпляра
    let directory: URL
    
    init(directory: URL? = nil) {
        self.directory = directory ?? appDirectory
        self.directory.createIfNeed()
    }
    
    ///Новый экземпляр относительно appDirectory
    init?(path: String) {
        directory = appDirectory.appendingPathComponent(path, isDirectory: true)
        if !directory.create() && !directory.isExist {
            return nil
        }
    }
    
    /**
    Создаст папку с указанным именем или вернёт существующую. По умолчанию папка создается в appDirectory
    **Parameters:**
        - name: имя папки
        - path: путь относительно appDirectory
    */
    func folder(name: String, path: String = "") -> URL {
        let folderUrl: URL = directory.appendingPathComponent(path + "/" + name, isDirectory: true)
        folderUrl.createIfNeed()
        return folderUrl
    }
    
    /**
     Вернёт папку с указанным именем или если папка не существует
    **Parameters:**
        - name: имя папки
        - path: путь относительно appDirectory
    */
    func getFolder(name: String, path: String = "") -> URL? {
        let folderUrl: URL = directory.appendingPathComponent(path + "/" + name, isDirectory: true)
        return folderUrl.isExist ? folderUrl : nil
    }
    
    /**
     Вернёт DirectoryManager для указанного пути относительно appDirectory
    **Parameters:**
        - path: путь относительно appDirectory
    */
    @discardableResult
    func add(_ path: String) -> DirectoryManager {
        let directoryUrl: URL = directory.appendingPathComponent(path, isDirectory: true)
        return DirectoryManager(directory: directoryUrl)
    }
    
    /**
    Запишет Data в файл или вернёт nil в случае неудачи
    **Parameters:**
        - data: данные
        - name: имя файла
        - ext: расширение(с . в начале)
    */
    @discardableResult
    func writeToFile(_ data: Data, name: String, ext: String) -> URL? {
        let fileUrl: URL = directory.appendingPathComponent(name + ext, isDirectory: false)
        do {
            try data.write(to: fileUrl, options: .atomic)
            return fileUrl
        } catch {
            return nil
        }
    }
    
    /**
    Прочитает Data или вернёт nil в случае неудачи
    **Parameters:**
        - name: имя файла
        - ext: расширение(с . в начале)
    */
    func read(name: String, ext: String) -> Data? {
        let fileUrl: URL = directory.appendingPathComponent(name + ext, isDirectory: false)
        return try? Data(contentsOf: fileUrl.standardizedFileURL)
    }
    
    /**
    Очистка директории от файлов. Вернёт true в случае успеха
    */
    @discardableResult
    func deleteAllFilesFromDirectory() -> Bool {
        let fileManager = FileManager.default
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: directory.absoluteString)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: filePath)
            }
            return true
        } catch let error as NSError {
            print("Could not clear directory: \(error.debugDescription)")
            return false
        }
    }
    
    /**
    Удалит файл с указанным именем в текущей директории. Вернёт true в случае успеха
    **Parameters:**
        - name: имя файла
        - ext: расширение(с . в начале)
    */
    @discardableResult
    func delete(name: String, ext: String) -> Bool {
        let fileUrl: URL = directory.appendingPathComponent(name + ext, isDirectory: false)
        do {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: fileUrl.absoluteString) {
                try fileManager.removeItem(atPath: fileUrl.absoluteString)
                return true
            } else {
                print("File does not exist")
                return false
            }
        }
        catch let error as NSError {
            print("An error took place: \(error)")
            return false
        }
    }
    
    /**
    Удалит файл с указанным URL в текущей директории. Вернёт true в случае успеха
    **Parameters:**
        - url: URL файла
    */
    @discardableResult
    func delete(url: URL) -> Bool {
        guard let fileName: String = url.getLast() else { return false }
        //В данном случае имя файла и расширение может быть указано в name
        return delete(name: fileName , ext: "")
    }
    
    /**
    Удалит все файлы с указанным расширением в текущей директории. Вернёт true в случае успеха
    **Parameters:**
        - ext: расширение(с . в начале)
    */
    @discardableResult
    func deleteAll(where ext: String) -> Bool {
        do {
            let fileManager = FileManager.default
            let filePaths = try fileManager.contentsOfDirectory(atPath: directory.absoluteString)
            for filePath in filePaths {
                if let url: URL = URL(string: filePath) {
                    if url.pathExtension == ext {
                        try fileManager.removeItem(atPath: filePath)
                    }
                }
            }
            return true
        } catch let error as NSError {
            print("Could not clear directory: \(error.debugDescription)")
            return false
        }
    }
    
    /**
    Удалит текущую директорию. Вернёт true в случае успеха
    */
    @discardableResult
    func delete() -> Bool {
        do {
            let fileManager = FileManager.default
            try fileManager.removeItem(at: directory)
            return true
        } catch let error as NSError {
            print("Could not delete directory: \(error.debugDescription)")
            return false
        }
    }
    
}

extension URL {
    var isExist: Bool { FileManager.default.fileExists(atPath: path) }
    
    func createIfNeed() { if !isExist { create() } }
    
    @discardableResult
    func create() -> Bool {
        do {
            try FileManager.default.createDirectory(at: self, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            return false
        }
    }
    
    func getLast(count: Int = 1) -> String? {
        let parts: [String] = pathComponents.reversed()
        var string: String = ""
        let divider: String = "/"
        for i in 0..<count {
            if i >= parts.count { return string }
            string = parts[i] + divider + string
        }
        
        return String(string.dropLast())
    }
}

//MARK: - Пример использования
import UIKit
func example() {
    //Получаем корневой каталог
    let rootDirectory: DirectoryManager = DirectoryManager()
    //Получаем папку с (допустим)аватарками
    let avatarsDirectory: DirectoryManager = rootDirectory.add("avatars")
    
    //Сохраняем изображение в папку с аватарками
    let testImage: UIImage = UIImage()
    if let testImageData: Data = testImage.pngData() {
        avatarsDirectory.writeToFile(testImageData, name: "avatar", ext: ".png")
    }
    //Достаём изображение
    if let testImageData: Data = avatarsDirectory.read(name: "avatar", ext: ".png") {
        let image: UIImage = UIImage(data: testImageData) ?? UIImage()
    }
}
