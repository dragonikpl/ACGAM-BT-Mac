//
//  BluetoothManager.swift
//  TreadmillBT
//
//  Created by Lukasz Domaradzki on 21/05/2021.
//

import Foundation
import CoreBluetooth
import Combine

class BluetoothService: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, TreadmillValuesProvider {
    static let treadmillName = "RZ_TreadMill"
    private var peripheral: CBPeripheral? = nil
    private var manager: CBCentralManager? = nil
    
    private(set) var publisher = CurrentValueSubject<[Int], Never>([])
    
    override init() {
        super.init()
        
        manager = CBCentralManager(delegate: self, queue: .main)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        connect(central)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.peripheral = nil
        connect(central)
    }
    
    func connect(_ central: CBCentralManager) {
        guard central.state == CBManagerState.poweredOn else { return }
        let found = central.retrieveConnectedPeripherals(withServices: [])
            .first { $0.name == BluetoothService.treadmillName }
        
        if let found = found {
            self.peripheral = found
            central.connect(found, options: nil)
        } else {
            central.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == BluetoothService.treadmillName {
            self.peripheral = peripheral
            central.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        peripheral.services?.forEach { peripheral.discoverCharacteristics(nil, for: $0) }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics ?? [] {
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else {
            return
        }
        
        let points: [Int] = data.map { Int($0) }
        
        publisher.send(points)
    }
    
}
