//
//  DefaultActivities.swift
//  LogCentral
//
//  Created by Henrik Akesson on 13/12/16.
//  Copyright © 2016 Henrik Akesson. All rights reserved.
//

import Foundation

/**
 Activities are a low volume way of grouping logging statements. They are similar
 to breadcrumbs. There are typically three types of activities:
 
 - user: A user initiated activity (button click etc)
 - external: An external event (triggered by the os)
 - internal: An internal activity which helps divide the logs into logical parts
 */
public enum DefaultActivities: ActivitySpec {
    /// A user initiated activity (button click etc.). Starts a new
    /// top level activity.
    case user
    
    /// An externally triggered event (CoreData change, Photos change) typically
    /// originating from the OS. Starts a new top level activity.
    case external
    
    /// An internal activity, used for splitting the work into logical segments
    /// like "searching database", "filtering results", "updating ui".
    case `internal`
    
    public var isTopLevel: Bool { return self != .internal }
}
