import Foundation


class Player {
    
    let ID:String
    var readyStatus: Bool = false
    
    init(ID: String) {
        self.ID = ID
    }
    
    public func getPlayerName() -> String {
        return self.ID
    }
    
    public func setReadyStatus() {
        if self.readyStatus {
            self.readyStatus = false
        } else {
            self.readyStatus = true
        }
    }
    
    public func getReadyStatus() -> Bool {
        return self.readyStatus
    }
    
}

