import Foundation

/*
 Player class;
 Contains player ID and ready status.
 */

class Player {
    
    let ID:String
    var readyStatus: Bool = false
    
    init(ID: String) {
        self.ID = ID
    }
    
    /* Getters */
    public func getPlayerName() -> String {
        return self.ID
    }
    
    public func getReadyStatus() -> Bool {
        return self.readyStatus
    }
    
    /* Setters */
    public func setReadyStatus() {
        if self.readyStatus {
            self.readyStatus = false
        } else {
            self.readyStatus = true
        }
    }
    
}

