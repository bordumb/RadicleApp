//
//  Icon.swift
//  RadicleApp
//
//  Created by bordumb on 26/02/2025.
//

import SwiftUI

struct Icon: View {
    
    var name: IconName
    var size: CGFloat = 16
    var color: Color = .customWhite  // Default color set to your custom white
    var action: (() -> Void)? = nil
    
    enum IconName: String {
        case arrowLeft = "arrow-left"
        case arrowRight = "arrow-right"
        case arrowRightHollow = "arrow-right-hollow"
        case attachment = "attachment"
        case branch = "branch"
        case broom = "broom"
        case broomDouble = "broom-double"
        case checkmark = "checkmark"
        case chevronDown = "chevronDown"
        case chevronRight = "chevronRight"
        case clock = "clock"
        case collapse = "collapse"
        case collapsePanel = "collapse-panel"
        case comment = "comment"
        case commentCheckmark = "comment-checkmark"
        case commentCross = "comment-cross"
        case commit = "commit"
        case copy = "copy"
        case copyLink = "copy-link"
        case cross = "cross"
        case dashboard = "dashboard"
        case delegate = "delegate"
        case diff = "diff"
        case ellipsis = "ellipsis"
        case expand = "expand"
        case expandPanel = "expand-panel"
        case eye = "eye"
        case face = "face"
        case file = "file"
        case home = "home"
        case inbox = "inbox"
        case issue = "issue"
        case issueClosed = "issue-closed"
        case label = "label"
        case lock = "lock"
        case markdown = "markdown"
        case moon = "moon"
        case moreVertical = "more-vertical"
        case none = "none"
        case offline = "offline"
        case online = "online"
        case patch = "patch"
        case patchArchived = "patch-archived"
        case patchDraft = "patch-draft"
        case patchMerged = "patch-merged"
        case pen = "pen"
        case plus = "plus"
        case radicleSeed = "radicleSeed"
        case reply = "reply"
        case repo = "repo"
        case revision = "revision"
        case seedling = "seedling"
        case seedlingFilled = "seedling-filled"
        case settings = "settings"
        case sun = "sun"
        case user = "user"
        case warning = "warning"
    }
    
    var body: some View {
        Image(name.rawValue) // Uses your custom SVGs
            .renderingMode(.template)  // Forces SwiftUI to overwrite svg's existing color
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundColor(.customWhite)  // Apply default custom color
    }
}
