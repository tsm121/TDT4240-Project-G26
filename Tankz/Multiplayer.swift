import Foundation
import MultipeerConnectivity
/* Player */
struct TankzPlayer {
    var peerID: MCPeerID
    var isReady: Bool
}

/* Message Structure */
struct Message : Codable{
    var type: String
}

/**
 * Handles all the functionality related to multiplayer.
 * Debug using $(dns-sd -B _services._dns-sd._udp).
 */
class Multiplayer : NSObject {
    
    /* Singleton */
    static let shared: Multiplayer = Multiplayer()
    
    /* Multipeer Connectivity Variables */
    private let type = "tankz"
    private let peerID = MCPeerID(displayName: UIDevice.current.name)
    private let browser : MCNearbyServiceBrowser
    private let advertiser : MCNearbyServiceAdvertiser
    
    /* Listeners for events */
    private var listener : (Message) -> () = Multiplayer.noop;
    
    func addEventListener(listener: @escaping (Message) -> ()) {
        self.listener = listener;
    }
    
    func removeEventListener(listener: @escaping (Message) -> ()) {
        self.listener = Multiplayer.noop;
    }
    
    /* todo(mike): No operation for replacing event listener with Void. */
    static func noop(message: Message) {
        
    }
 
    func notifyAllEventListeners(message: Message) {
        self.listener(message);
    }
    
    /* Game Variables */
    let player: TankzPlayer
    var opponent: TankzPlayer?
    var ishost = false

    /* Join Game  Variables*/
    var games = [MCPeerID]() // Available Games
    
    /* Lobby Variables*/
    var isReady = false
    
    override init () {
        self.player = TankzPlayer(peerID: self.peerID, isReady: false)
        self.browser = MCNearbyServiceBrowser(peer: self.peerID, serviceType: self.type)
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.peerID, discoveryInfo: nil, serviceType: self.type)
        super.init()
    }
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        session.delegate = self
        return session
    }()
    
    /* Advertise this client as a host for other clients. */
    func advertiseAsHost() {
        self.ishost = true
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
        self.ishost = false;
        self.isReady = true;
        self.browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 5)
    }
    
    /* Encoder */
    func encodeMessage(message: Message) -> Data{
        let encodedData = try? JSONEncoder().encode(message);
        // TODO: Optional! Add error handling if time
        return encodedData!
    }
    
    /* Decoder */
    func decodeMessage(data: Data) -> Message {
        let decodedMessage = try? JSONDecoder().decode(Message.self, from: data)
        // TODO: Optional! Add error handling if time
        return decodedMessage!
    }
    
    /* Send Data */
    func send(message: Message){
        let message = self.encodeMessage(message: message)
        try? self.session.send(message, toPeers: self.session.connectedPeers, with: .reliable)
    }
    
    /* Message: Start Game */
    func messageStartGame(){
        self.send(message: Message(type: "startgame"))
    }
    
    /* Message: Is Ready */
    func messageIsReady(){
        self.send(message: Message(type: "isready"))
    }
    
    /* Message: Not Ready */
    func messageNotReady(){
        self.send(message: Message(type: "notready"))
    }
    
    /* Message Handlers */
    func handleMessage(message: Message){
        switch message.type {
        case "startgame":
            handleStartGame()
            self.notifyAllEventListeners(message: message)
            NSLog("%@", "startgameMessage: \(message)")
        case "isReady":
            handleIsReady()
            NSLog("%@", "isReadyMessage: \(message)")
        case "notReady":
            handleNotReady()
            NSLog("%@", "notReadyMessage: \(message)")
        default:
            NSLog("%@", "invalidMessage: \(message)")
        }
    }
    
    func handleStartGame(){
        // TODO: Handle start game message
    }
    
    func handleIsReady(){
        // TODO: Handle is ready message
    }
    
    func handleNotReady(){
        // TODO: Handle not ready
    }
    
    /* TODO: Mark as ready to play. */
    
    /* TODO: Check if ready to play */
    
    /* TODO: Implement Heartbeat or fix disconnected error
        /* todo(thurs): Handle leaving a game. */

        /* todo(thurs): Handle host disconnecting. */
    */
}

extension Multiplayer : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        handleMessage(message: decodeMessage(data: data))
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
