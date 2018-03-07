Requirements for components:

MainMenuViewController:

- UI: Button with access JoinGameViewController (DONE)
- UI: Button with access LobbyGameViewController (DONE)
- UI: Button with access to ScoreboardViewController
- UI: Button with access to information/how-to popup

JoinGameViewController:

- Network: Ask/find availiable games and store in array
- Network: Search again for availibale games
- Network: Connect client to host
- Network: When connected to host, send user to LobbyGameViewController
- UI: Show list of availiable games. UI
- UI: Button to refresh availiable games


LobbyGameViewController:

- Function: When both players are ready, send users to GameViewController
- Network: Advertise as host with availiable spots
- Network: Host and client stores each other MPCID (user-id)
- Network: When user presses "Back", disconnect connection between host and client
- UI: List of players in lobby with ready-status
- UI: Button to set ready-status to ready/not-ready

GameViewController:

-
