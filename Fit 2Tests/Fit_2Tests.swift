//
//  Fit_2Tests.swift
//  Fit 2Tests
//
//  Created by Gopal Patel on 1/30/25.
//

import Testing
@testable import Fit_2

struct Fit_2Tests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let number = 1
        let number2 = 2
        #expect(number + number2 == 3)
    }

}
