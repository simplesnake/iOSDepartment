//
//  BlueToothManager.swift
//  iOSDepartment
//
//  Created by 7winds on 06.03.2022.
//  Copyright © 2022 Stroev. All rights reserved.
//

//import Foundation
//import SwiftyBluetooth
//import CoreBluetooth
//
//struct Characteristic {
//    let id: CharacteristicIds
//    let type: BluetoothDeviceType
//}
//
//class TempickDevice: BLEDevice {
//    
//}
//
//class BLEDevice {
//    
//    var autoReconnect: Bool
//    let peripheral: Peripheral
//
//    var identifier: UUID { peripheral.identifier }
//    var characteristics: [BLECharacteristic] = []
//    
//    init(peripheral: Peripheral, autoReconnect: Bool = true) {
//        self.peripheral = peripheral
//        self.autoReconnect = autoReconnect
//    }
//    
//    func discoverServices(value: BLECharacteristic){
//        peripheral.setNotifyValue(toEnabled: true, forCharacWithUUID: CBUUID(string: value.id.rawValue), ofServiceWithUUID: CBUUID(string: value.serviceId.rawValue)) { [weak self] result in
//            print(result)
//            
//            switch result {
//            
//            case .success(_):
//                self?.characteristics.append(value)
//            case .failure(_):
//                print("discoverServices \(value) failed")
//            }
//        }
//    }
//    
//    
//    
//}
//
//struct BLECharacteristic {
//    let id: CharacteristicIds
//    let serviceId: ServiceIds
//}
//
//class BlueToothManager {
//    
//    typealias ObserverClosure = ((Notification, SBError?)->())
//    typealias EventClosure = ((BLEDevice, Notification, SBError?)->())
////    typealias OnDisconnect = (()->())
//    
//    var observedDevices: [UUID] = []
//    static var shared: BlueToothManager = BlueToothManager()
//    
//    
//    //Подключение девайса
//    
//    typealias DeviceConnected = ((BLEDevice) -> ())?
//    typealias DeviceConnectionFailed = ((BLEDevice, Error) -> ())?
////    var deviceConnected: ((BLEDevice) -> ())?
////    var deviceConnectionFailed: ((BLEDevice) -> ())?
//    
////    var connectedDevices: [BLEDevice] = []
//    
////    var onValueChanged: (BLEDevice, Charat)?
//    var onValueUpdate: [String : EventClosure] = [:]
//    var onServiceModify: [EventClosure] = []
//    var onDeviceNameUpdated: [EventClosure] = []
//    var onDisconnect: [EventClosure] = []
//    
//    
//    func scan(types: [BluetoothDeviceType] = [], duration: TimeInterval, onScanStarted: (() -> ())? = nil, onScanResult: ((Peripheral, [String: Any], Int?) -> ())? = nil, onScanStopped: (([Peripheral], SBError?) -> ())? = nil) {
//        SwiftyBluetooth.scanForPeripherals(withServiceUUIDs: types.map({ CBUUID(string: $0.rawValue) }), timeoutAfter: duration) {
//            [weak self] scanResult in
//            guard let self = self else { return }
//            
//            switch scanResult {
//                case .scanStarted:
//                    print("scanStarted")
//                    onScanStarted?()
//                case .scanResult(let peripheral, let advertisementData, let RSSI):
//                    print("scanResult")
//                    onScanResult?(peripheral, advertisementData, RSSI)
//                case .scanStopped(let peripherals, let error):
//                    print("scanStopped")
//                    onScanStopped?(peripherals, error)
//            }
//        }
//    }
//    
//    func connectTo(bleDevice: BLEDevice, timeout: TimeInterval = .infinity, onSucces: DeviceConnected, onFail: DeviceConnectionFailed) {
//        
//        bleDevice.peripheral.connect(withTimeout: timeout) {
//            [weak self] result in
//            guard let self = self else { return }
//        
//            switch result {
//                case .success:
//                    print("connect success")
//                    onSucces?(bleDevice)
//
//                    
//                        print("Ble create observer")
//                        self.createObserver(for: bleDevice, event:   .updateValues) {
//                            notification, error in
//                            self.onValueUpdate.forEach({ $0.value(bleDevice, notification, error) })
//                        }
//                        
//                        
//                        
//                        self.createObserver(for: bleDevice, event:   .modifedServices) {
//                            notification, error in
//                            self.onServiceModify.forEach({ $0(bleDevice, notification, error) })
//                        }
//                        
//                        self.createObserver(for: bleDevice, event:   .deviceNameUpdated) {
//                            notification, error in
//                            self.onDeviceNameUpdated.forEach({ $0(bleDevice, notification,  error) })
//                        }
//                    
//                    if !self.observedDevices.contains(where: {$0 == bleDevice.identifier}) {
//                        self.createObserver(for: bleDevice, event:   .disconnect) {
//                            [weak self] notification, error in
//                            self?.onDisconnect.forEach({ $0(bleDevice, notification, error) })
//                        
//                            bleDevice.characteristics = []
//                        }
//                        self.observedDevices.append(bleDevice.identifier)
//                    }
//                       
//                        
//                        
//                    
//                case .failure(let error):
//                    
//                    print("connect failed")
//                    onFail?(bleDevice, error)
//            }
//        }
//    }
//    
//    func createObserver(for bleDevice: BLEDevice, event: BLEEvent, _ closure: @escaping ObserverClosure) {
//        NotificationCenter.default.addObserver(forName: event.get,
//                                               object: bleDevice.peripheral,
//                                                queue: nil) { notification in
//            closure(notification, notification.userInfo?["error"] as? SBError)
//        }
//    }
//    
//}
//
//enum BluetoothDeviceType: String {
//    case termo = "0x1809"
//    
//}
//
//enum CharacteristicIds: String {
//    case delayTemperature = "0x2A1C"
//    case fastTemperature = "0x2A1E"
//    case battery = "0x2A19"
//}
//
//enum ServiceIds: String {
//    case batterySevice = "180F"
//    case temperatureService = "1809"
//}
//
//enum BLEEvent: String {
//    case updateValues = "SwiftyBluetooth_PharacteristicValueUpdate"
//    case disconnect = "SwiftyBluetooth_PeripheralDisconnected"
//    case modifedServices = "SwiftyBluetooth_PeripheralModifedServices"
//    case deviceNameUpdated = "SwiftyBluetooth_PeripheralNameUpdate"
//    
//    var get: Notification.Name { Notification.Name(rawValue: self.rawValue) }
//}
