import Foundation
import MultipeerConnectivity
/* Player */
struct TankzPlayer {
    var peerID: MCPeerID
    var isReady: Bool
    var isHost: Bool
    var tank: Int
}

/* Message Structure */
struct Message : Codable{
    var type: String
    var index: Int
    var power: Float
    var angle: Float
    
    init(type: String){
        self.type = type
        self.index = 0
        self.power = 0.0
        self.angle = 0.0
    }
    
    init(type: String, angle: Float){
        self.type = type
        self.index = 0
        self.power = 0.0
        self.angle = angle
    }
    
    init(type: String, index: Int){
        self.type = type
        self.index = index
        self.power = 0.0
        self.angle = 0.0
    }
    
    init(type: String, power: Float, angle: Float){
        self.type = type
        self.index = 0
        self.power = power
        self.angle = angle
    }
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
    private var isDisconnecting = false
    private var map = 0
    
    /* Game Variables */
    var player: TankzPlayer
    var opponent: TankzPlayer?

    /* Join Game  Variables*/
    var games = [MCPeerID]() // Available Games
    override init () {
        self.player = TankzPlayer(peerID: self.peerID, isReady: false, isHost: false, tank: 0)
        self.browser = MCNearbyServiceBrowser(peer: self.peerID, serviceType: self.type)
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.peerID, discoveryInfo: nil, serviceType: self.type)
        super.init()
    }
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.peerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        session.delegate = self
        return session
    }()
    
    /* Listeners for events */
    private var listener : (Message) -> () = Multiplayer.noop;
    
    func addEventListener(listener: @escaping (Message) -> ()) {
        self.listener = listener;
    }
    
    func removeEventListener(listener: @escaping (Message) -> ()) {
        /* Attach multiplayerListener */
        NSLog("%@", "Removing Event Listener")
        self.listener = Multiplayer.noop;
    }
    
    /* todo(mike): No operation for replacing event listener with Void. */
    static func noop(message: Message) {
        
    }
    
    func notifyAllEventListeners(message: Message) {
        self.listener(message);
    }
    
    /* Advertise this client as a host for other clients. */
    func advertiseAsHost() {
        self.player.isHost = true
        self.advertiser.delegate = self
        self.advertiser.startAdvertisingPeer()
    }
    
    /* Cease advertising this host to other clients. */
    func ceaseAdvertisingAsHost() {
        self.advertiser.stopAdvertisingPeer()
    }
    
    func disconnect() {
        self.isDisconnecting = true;
        self.session.disconnect()
        self.player.isHost = false
        self.player.isReady = false
        self.player.tank = 0
        self.games.removeAll()
        self.map = 0
        ceaseAdvertisingAsHost()
        ceaseLookingForGames()
        self.isDisconnecting = false;
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
        self.player.isHost = false;
        self.player.isReady = false;
        self.browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 5)
        self.opponent = TankzPlayer(peerID: peerID, isReady: false, isHost: true, tank: 0)
    }
    
    func playerJoinedGame(peerID : MCPeerID){
        self.opponent = TankzPlayer(peerID: peerID, isReady: false, isHost: false, tank: 0)
        self.ceaseAdvertisingAsHost()
    }
    
    func getCurrentMap() -> Int{
        return self.map
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
    
    /* Message: Is Ready */
    func messageIsReady(){
        self.player.isReady = true
        if (self.opponent != nil) {
            self.send(message: Message(type: "isready"))
            /* Todo: Crashes on self.oppenent?.isReady if there is no opponent */
            if (self.opponent?.isReady)! {
                self.notifyAllEventListeners(message: Message(type: "startgame"))
            }
        }
    }
    
    /* Message: Not Ready */
    func messageNotReady(){
        self.player.isReady = false
        self.send(message: Message(type: "notready"))
    }
    /* TODO: Message Fire/"End Turn" */
    func messageFire(power: Float, angle: Float){
        self.send(message: Message(type: "fire", power: power, angle: angle))
    }
    /* TODO: Message Move Left */
    func messageMoveLeft(){
        self.send(message: Message(type: "moveleft"))
    }
    /* TODO: Message Move Right */
    func messageMoveRight(){
        self.send(message: Message(type: "moveright"))
    }
    
    func messageAngleCanon(angle: Float){
        self.send(message: Message(type: "anglecanon", angle: angle))
    }
    
    func messageSelectTank(index: Int){
        self.player.tank = index
        self.send(message: Message(type: "selecttank", index: index))
    }
    
    func messageSelectMap(index: Int){
        self.map = index
        self.send(message: Message(type: "selectmap", index: index))
    }
    /* --- Message Handlers --- */
    func handleMessage(message: Message){
        NSLog("%@", "message \(message.type)")
        switch message.type {
        case "isready":
            handleIsReady(message: message)
            NSLog("%@", "isReadyMessage: \(message)")
        case "notready":
            handleNotReady(message: message)
            NSLog("%@", "notReadyMessage: \(message)")
        case "fire":
            handleFire(message: message)
            NSLog("%@", "fireMessage \(message)")
        case "moveleft":
            handleMoveLeft(message: message)
            NSLog("%@", "moveleftmessage \(message)")
        case "moveright":
            handleMoveRight(message: message)
            NSLog("%@", "moverightmessage \(message)")
        case "anglecanon":
            handleAngleCanon(message: message)
        case "selecttank":
            handleSelectTank(message: message)
        case "selectmap":
            handleSelectMap(message: message)
        default:
            NSLog("%@", "invalidMessage: \(message)")
        }
    }
    
    func handleIsReady(message: Message){
        // TODO: Handle is ready message
        self.opponent?.isReady = true
        self.notifyAllEventListeners(message: message)
        if self.player.isReady {
            self.notifyAllEventListeners(message: Message(type: "startgame"))
        }
    }
    
    func handleNotReady(message: Message){
        // TODO: Handle not ready
        self.opponent?.isReady = false
        self.notifyAllEventListeners(message: message)
    }
    func handleFire(message: Message){
        self.notifyAllEventListeners(message: message)
    }
    
    func handleMoveLeft(message: Message){
        self.notifyAllEventListeners(message: message)
    }
    
    func handleMoveRight(message: Message){
        self.notifyAllEventListeners(message: message)
    }
    
    func handleAngleCanon(message: Message){
        self.notifyAllEventListeners(message: message)
    }
    func handleSelectTank(message: Message){
        self.opponent?.tank = message.index
        self.notifyAllEventListeners(message: message)
    }
    func handleSelectMap(message: Message){
        self.map = message.index
        self.notifyAllEventListeners(message: message)
    }
    /* TODO: Implement Heartbeat or fix disconnected error
        /* todo(thurs): Handle leaving a game. */

        /* todo(thurs): Handle host disconnecting. */
    */
}

extension Multiplayer : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        if (state == MCSessionState.connected && self.player.isHost){
            if (self.player.isReady){
                self.messageIsReady()
            }
            self.messageSelectMap(index: self.map)
            self.messageSelectTank(index: self.player.tank)
        }
        else if (state == MCSessionState.notConnected && self.isDisconnecting){
            self.isDisconnecting = false
        }
        else if (state == MCSessionState.notConnected && !self.isDisconnecting){
            notifyAllEventListeners(message: Message(type: "opponentdisconnected"))
        }
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
        playerJoinedGame(peerID: peerID)
    }
    
}
/* Alert CODE
static func alertHelper(){
    let alert = UIAlertController(title: "My Alert", message: string, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
        NSLog("The \"OK\" alert occured.")
    }))
    self.present(alert, animated: true, completion: nil)
}
 */
