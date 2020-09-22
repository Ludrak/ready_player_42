extends Node2D

export (PackedScene) var	player = preload("res://Scenes/Game Objects/Player/Player.tscn")

func	_ready():
	var p = player.instance()

	p.global_position = $SpawnPoint.global_position
	p.set_name("Player")
	add_child(p)
	$CameraFollow.target = p
	p.bullet_collector = $BulletCollector.get_path()
