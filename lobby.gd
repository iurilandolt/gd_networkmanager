extends Node3D

func _ready():
	pass

func _on_host_pressed():
	NetworkManager.create_server()
	$Networkinfo/NetworkSideDisplay.text = "Server"
	$Networkinfo/UniquePeerID.text = str(multiplayer.get_unique_id())
	$Menu.visible = false
	$Chat_box.show()
	
func _on_join_pressed():
	NetworkManager.create_client()
	$Networkinfo/NetworkSideDisplay.text = "Client"
	$Networkinfo/UniquePeerID.text = str(multiplayer.get_unique_id())
	$Menu.visible = false
	$Chat_box.show()
	
