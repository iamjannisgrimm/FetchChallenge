//
//  String+Clean.swift
//  FetchChallenge
//
//  Created by Jannis Grimm on 8/28/24.
//

import Foundation

extension String {
    /// Returns a cleaned version of the string, or nil if the string is empty, "empty", or "null"
    var cleaned: String? {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed.lowercased() != "empty", trimmed.lowercased() != "null" else { //Only if you have proof
            return nil
        }
        return trimmed
    }
}
