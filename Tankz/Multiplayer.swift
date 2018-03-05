import Foundation
import MultipeerConnectivity

/**
 * Handles all the functionality related to multiplayer.
 * Debug using $(dns-sd -B _services._dns-sd._udp).
 */
class Multiplayer {
    
    private let type = "tankz"
    private let peerID = MCPeerID(displayName: UIDevice.current.name)
    private let browser : MCNearbyServiceBrowser
    private let advertiser : MCNearbyServiceAdvertiser
    
    init () {
        self.browser = MCNearbyServiceBrowser(peer: self.peerID, serviceType: self.type)
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.peerID, discoveryInfo: nil, serviceType: self.type)
    }
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self as? MCSessionDelegate
        return session
    }()
    
    /* Advertise this client as a host for other clients. */
    func advertiseAsHost() {
        self.advertiser.delegate = self as? MCNearbyServiceAdvertiserDelegate
        self.advertiser.startAdvertisingPeer()
    }
    
    /* Cease advertising this host to other clients. */
    func ceaseAdvertisingAsHost() {
        self.advertiser.stopAdvertisingPeer()
    }
    
    /* Look for other hosts. */
    func lookForHosts() {
        self.browser.startBrowsingForPeers()
    }
    
    /* Cease looking for peers. */
    func ceaseLookingForPeers() {
        self.browser.stopBrowsingForPeers()
    }
    
    /* Join existing game. */
    
    /* Mark as ready to play. */
}
