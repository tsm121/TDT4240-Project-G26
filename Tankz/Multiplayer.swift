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
    static let shared: Multiplayer = Multiplayer()
    var games = [MCPeerID]()
    
    override init () {
        self.browser = MCNearbyServiceBrowser(peer: self.peerID, serviceType: self.type)
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.peerID, discoveryInfo: nil, serviceType: self.type)
        super.init()
    }
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
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
        self.games = [MCPeerID]()
        self.browser.delegate = self
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
    func joinGame(peerID: MCPeerID){
        self.browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 5)
    }
    
    /* todo(thurs): Send some data to the host and vice verca. */
    func send() {
        do {
            try self.session.send("herp".data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            NSLog("didSend")
        }
        catch let error {
            NSLog("%@", "didReceiveError: \(error)")
        }
    }
        
    /* todo(thurs): Mark as ready to play. */
    
    /* todo(thurs): Handle leaving a game. */
    
    /* todo(thurs): Handle host disconnecting. */
}

extension Multiplayer : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        
        /* Wait 5 seconds and then try to send. */
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            Multiplayer.shared.send();
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
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
        invitationHandler(true, self.session)
    }
    
}
