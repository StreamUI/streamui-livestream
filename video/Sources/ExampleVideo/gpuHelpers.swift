//
//  File.swift
//
//
//  Created by Jordan Howlett on 6/29/24.
//

import IOKit
import IOKit.graphics

func getGPUUtilization() -> [String: Double]? {
    var iterator: io_iterator_t = 0
    var utilizationInfo: [String: Double] = [:]
    
    // Get a list of all GPUs
    let result = IOServiceGetMatchingServices(kIOMainPortDefault, IOServiceMatching("IOAccelerator"), &iterator)
    if result != KERN_SUCCESS {
        print("Error: Unable to get GPU services.")
        return nil
    }
    
    // Iterate through each GPU service
    var service: io_object_t = IOIteratorNext(iterator)
    while service != 0 {
        // Get GPU properties
        var properties: Unmanaged<CFMutableDictionary>?
        if IORegistryEntryCreateCFProperties(service, &properties, kCFAllocatorDefault, 0) == KERN_SUCCESS,
           let properties = properties?.takeRetainedValue() as? [String: Any]
        {
            if let statistics = properties["PerformanceStatistics"] as? [String: Any] {
                // Read GPU utilization
                if let busy = statistics["Device Utilization %"] as? Double {
                    utilizationInfo["GPU Utilization"] = busy
                }
            }
        }
        IOObjectRelease(service)
        service = IOIteratorNext(iterator)
    }
    
    IOObjectRelease(iterator)
    
    if utilizationInfo.isEmpty {
        print("Error: Unable to retrieve GPU utilization.")
        return nil
    }
    
    return utilizationInfo
}
