//
//  String+Clean.swift
//  FetchChallenge
//
//  Created by Jannis Grimm on 8/28/24.
//

import Foundation

extension String {
    /// Returns a cleaned version of the string, or nil if the string is empty, or "null"
    var cleaned: String? {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed.lowercased() != "null" else {
            return nil
        }
        return trimmed
    }
}
