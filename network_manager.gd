extends Node3D

const ADDRESS = "127.0.0.1"
const PORT = 3234
const MAX_PEERS = 3

var network = ENetMultiplayerPeer.new()

var local_player : Player
var players = {}
var peer_ids = []

func create_server():
	network.create_server(PORT, MAX_PEERS)
	multiplayer.multiplayer_peer = network
	add_player(1)
	network.peer_connected.connect(
		func(new_peer_id):
			print(str(multiplayer.get_unique_id()), ": client connected")
			await get_tree().create_timer(1).timeout
			#add_player(new_peer_id)
			rpc("add_newly_connected_player", new_peer_id)
			rpc_id(new_peer_id, "add_previously_connected_players", peer_ids)
	)
	network.peer_disconnected.connect(
		func(peer_id):
			peer_ids.erase(peer_id)
			for id in peer_ids:
				rpc_id(id, "remove_player", peer_id)
			print(str(multiplayer.get_unique_id()), ": client disconnected: ", peer_id)
			#print("peer ids :", peer_ids)
			#print("players: ", players)
	)

func create_client():
	network.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = network
	await get_tree().create_timer(5).timeout
	if network.get_connection_status() != 2:
		print(str(multiplayer.get_unique_id()), ": connection error code: " , str(network.get_connection_status()))
		await get_tree().create_timer(1).timeout
		get_tree().quit()

func add_player(peer_id):
	peer_ids.append(peer_id)
	var player : Player = preload("res://Scenes/player.tscn").instantiate()
	players[peer_id] = player
	player.set_multiplayer_authority(peer_id)
	player.set_name(str(peer_id))
	get_node("/root/Main").add_child(player)
	print(str(multiplayer.get_unique_id()),": player add function used")
	if peer_id == multiplayer.get_unique_id():
		player = local_player

@rpc("call_local")
func remove_player(peer_id):
	peer_ids.erase(peer_id)
	players[peer_id].queue_free()

@rpc("call_local")
func add_newly_connected_player(new_peer_id):
	add_player(new_peer_id)
	print(str(multiplayer.get_unique_id()), ": added newly connected player: ", new_peer_id)

@rpc
func add_previously_connected_players(ids):
	for peer_id in ids:
		add_player(peer_id)
		print(str(multiplayer.get_unique_id()), ": added previously connected players: ", peer_id)

