//
//  StateMachine.swift
//  TeapotTanks
//
//
//  The purpose of this file is to inform what all of the States are for the AI
//  and then to specify what valid state transitions are between those states.
//
//  Created by Joshua Smith on 8/19/16.
//  Copyright © 2016 Joshua Smith. All rights reserved.
//

import GameplayKit


/// The State when the Battle Teapot is hunting
class Hunting: GKState {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        guard stateClass != Destroyed.self else {
            return true
        }
        
        return stateClass == Targeting.self || stateClass == Destroyed.self
    }

}

/// The State when the Battle Teapot is targeting
class Targeting: GKState {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        guard stateClass != Destroyed.self else {
            return true
        }
        
        return stateClass == Hunting.self || stateClass == Reloading.self
    }

}

/// The State when the Battle Teapot is firing
class Firing : GKState {

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        guard stateClass != Destroyed.self else {
            return true
        }
        
        return stateClass == Reloading.self
    }

}

class Reloading: GKState {
    let reloadTime = 1.0
    var reloadRemaingingTime = 0.0
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        guard stateClass != Destroyed.self else {
            return true
        }
        return stateClass == Firing.self
    }
    
    override func didEnter(from previousState: GKState?) {
        reloadRemaingingTime = reloadTime
    }
    
    override func willExit(to nextState: GKState) {
        reloadRemaingingTime = 0.0
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        reloadRemaingingTime = reloadRemaingingTime - seconds
        if reloadRemaingingTime < 0 {
            stateMachine?.enter(Targeting.self)
        }
    }
}
class Destroyed: GKState { }
