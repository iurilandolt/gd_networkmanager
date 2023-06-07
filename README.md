#gd_networkmanager
	gdscript multiplayer lobby with chat and asset sincronization for Godot game-engine WIP
	server ran on host player side, not currently a standalone server.


#networkmanager.gd
	starts godot multiplayer API
	sets ip/port/max peers

#current functionality
	#funcs
		create_server()
		host creates/starts server and listens to connected/disconnected signals
		host creates player asset for himself (player 1)
		create_client()
	local instance uses multiplayer API to connect to set IP and PORT
		waits for connection status/if return signal is not "2"(connection established)
			gives user feedback
			closes instance
		add_player()
			creates new peer_id in peer_ids array
			instanciates new player object and adds it to dictionary
			name new player object with peer_id
			set player as multiplayer authority
			check if new player is local_player
		@rpc("call local")
			add_newly_connected_player()
			remove_player()
		@rpc_id
			add_previously_connected_player()

#signals
	on connected signal
		generates unique id(peer id) from signal, adds peer_id to peer_id array/list.
		generates player object(scene) and assigns it to a dictionary.
		host uses @RPC to add new player to server and all connected peers.
		host uses @RPC_ID to add all previously existing players in the server to the connected peers' instance.(newly connected peer)
	on disconnected signal
		host uses @RPC("call local") to remove player object and peer_id localy and in all peers.
#lobby/chat.gd
	lobby calls either create_server() or create_client()
	lobby starts chat
	chat displays and grabs focus on enter key press.
		if text input is empty and enter is pressed chat releases focus and enters visibility countdown.
		if text input is not empty and enter is pressed, send button is pressed.
	on send button pressed add input_box content to chat item_list. clear input_box content, release focus and enter visibility countodwn.
	chat hides after Xs countdown
	countdown is restarted on enter pressed, send button pressed or if chat item_list is updated
