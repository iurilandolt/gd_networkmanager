extends Control

const MAX_ITEMS = 5
var has_typed = false

func _on_send_button_pressed():
	var message = str(multiplayer.get_unique_id()) + ": " + $Text_Input.text
	rpc("update_chat", message)
	$Text_Input.clear()
	$Text_Input.release_focus()
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		if $Text_Input.text == "" && has_typed == false:
			$Text_Input.grab_focus()
			$Chat_History.show()
			$Text_Input.show()
			has_typed = true
		elif $Text_Input.text == "" && has_typed == true:
			$Text_Input.release_focus()
			has_typed = false
			hide_countdown()
		else:
			_on_send_button_pressed()
		
@rpc("any_peer", "call_local")
func update_chat(message):
	$Chat_History.add_item(message)
	$Chat_History.show()
	$Text_Input.show()
	if $Chat_History.get_v_scroll_bar() && $Chat_History.get_item_count() > MAX_ITEMS :
		$Chat_History.remove_item(0)
	hide_countdown()
		
@rpc("any_peer", "call_local")
func hide_countdown():
	$Timer.start()
	$Timer.timeout.connect(
		func hide_chat():
			$Chat_History.visible = false
			$Text_Input.visible = false
	)
