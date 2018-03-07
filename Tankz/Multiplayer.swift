import Foundation
import MultipeerConnectivity

/**
 * Handles all the functionality related to multiplayer.
 * Debug using $(dns-sd -B _services._dns-sd._udp).
 */
class Multiplayer : NSObject {
    
    private let type = "tankz"
    private let peerID = MCPeerID(displayName: UIDevice.current.name)
    private let browser : MCNearbyServiceBrowser
    private let advertiser : MCNearbyServiceAdvertiser
    var games = [MCPeerID]()
    
    override init () {
        self.browser = MCNearbyServiceBrowser(peer: self.peerID, serviceType: self.type)
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.peerID, discoveryInfo: nil, serviceType: self.type)
        super.init()
    }
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self as? MCSessionDelegate
        return session
    }()
    
    /* Advertise this client as a host for other clients. */
    func advertiseAsHost() {
        self.advertiser.delegate = self
        self.advertiser.startAdvertisingPeer()
    }
    
    /* Cease advertising this host to other clients. */
    func ceaseAdvertisingAsHost() {
        self.advertiser.stopAdvertisingPeer()
    }
    
    /* Look for games. */
    func lookForGames() {
        self.browser.startBrowsingForPeers()
    }
    
    /* Cease looking for games. */
    func ceaseLookingForGames() {
        self.browser.stopBrowsingForPeers()
    }
    
    /* Get found games. */
    func getGames() -> [MCPeerID] {
        return games
    }
    
    /* Join existing game. */
    
    /* Mark as ready to play. */
}

extension Multiplayer : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        self.games.append(peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
        let index = self.games.index(of: peerID)
        self.games.remove(at: index!)
    }
    
}

extension Multiplayer : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
    }
    
}
