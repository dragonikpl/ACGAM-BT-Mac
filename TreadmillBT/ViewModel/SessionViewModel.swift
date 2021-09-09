//
//  TreadmillSession.swift
//  TreadmillBT
//
//  Created by Lukasz Domaradzki on 24/05/2021.
//

import Foundation
import Combine
import CoreData

class SessionViewModel: ObservableObject {
    private let treadmillValuesProvider: TreadmillValuesProvider
    private let context: NSManagedObjectContext
    private var bag = Set<AnyCancellable>()
    private var currentRun: Run?
    
    @Published var currentState: TreadmillState = .unknown
    @Published private var hoursOffset: Double = 0
    
    init(treadmillValuesProvider: TreadmillValuesProvider = BluetoothService(),
         context: NSManagedObjectContext = PersistenceService.shared.viewContext) {
        self.treadmillValuesProvider = treadmillValuesProvider
        self.context = context
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        let sharedValuesProvider = treadmillValuesProvider.publisher.share()
        let sharedState = $currentState.share()
        
        // Receive, parse and update current state
        Publishers.CombineLatest(sharedValuesProvider, $hoursOffset)
            .map { TreadmillParser.parse(values: $0.0, hoursOffset: $0.1) }
            .assign(to: &$currentState)
        
        // Detect hours offset
        sharedState
            .sink { [weak self] state in
                if case let .running(run) = state,
                   run.duration.converted(to: .seconds).value == 5999 { // 99 minutes and 59 seconds
                    self?.hoursOffset += 1
                }
            }
            .store(in: &bag)
        
        sharedState
            .sink { [weak self] state in
                switch state {
                case let .countdown(secondsLeft):
                    if secondsLeft == 5 {
                        self?.hoursOffset = 0
                        self?.startRun()
                    }
                case let .running(run):
                    self?.updateRun(run)
                case .stopping:
                    self?.saveRun()
                default: break
                }
            }
            .store(in: &bag)
    }
    
    func startRun() {
        if currentRun != nil {
            currentRun = nil
        }
                
        currentRun = Run(context: context)
        currentRun?.start = Date()
    }
    
    func updateRun(_ data: TreadmillRun) {
        if currentRun?.logs == nil {
            currentRun?.logs = []
        }
        
        currentRun?.logs?.append(data.raw)
    }
    
    func saveRun() {
        currentRun?.end = Date()
        
        do {
            try context.save()
        } catch let error {
            print(error)
        }
        
        currentRun = nil
    }
}
