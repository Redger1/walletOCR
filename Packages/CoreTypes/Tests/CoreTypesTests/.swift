//
//  DateIntervalExTests.swift
//  CoreTypes
//
//  Created by Артем on 01.10.2025.
//
import XCTest
@testable import DateIntervalEx

final class DateIntervalExTest: XCTestCase {
    func testContains() {
        let example = DateIntervalEx(start: Date.now, end: Date.now + 1000)
        let containsResult = example.contains(.now + 500)
        XCTAssertTrue(containsResult)
    }
}
