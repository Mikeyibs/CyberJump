extends Sprite

var collect = false

func _on_Area2D_body_entered(body):
	if body.get("TYPE") == "player" && collect == false:
		body.JUMPFORCE = 800
		collect = true
		$AnimationPlayer.play("collect")
		$Timer.start()
		
func _on_Timer_timeout():
	get_parent().get_node("Player").JUMPFORCE = 400
	queue_free()
		
