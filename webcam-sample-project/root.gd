extends Control

var _potentialSources : Array = []

var _error : int 

func update_webcam_view_size(webCamWidth, webCamHeight) -> void:
	var _tmp_windowSize = OS.get_window_size()
	var _tmp_viewWidth = webCamWidth
	var _tmp_viewHeight = webCamHeight
	
	var _tmp_aspect_ratio = webCamWidth/webCamHeight
	
	if webCamWidth > _tmp_windowSize.x:
		_tmp_viewWidth = _tmp_windowSize.x
		_tmp_viewHeight = _tmp_windowSize.y/_tmp_aspect_ratio
	
	var _tmp_viewSize : Vector2 = Vector2(_tmp_viewWidth, _tmp_viewHeight)
	$webcamView.rect_min_size = _tmp_viewSize
	$webcamView.rect_size = _tmp_viewSize
#	$webcamView.set_anchors_preset(PRESET_CENTER)
	$webcamView.rect_min_size = _tmp_viewSize
	$webcamView.rect_size = _tmp_viewSize
	print("New Webcam View Size: ", $webcamView.rect_min_size)
	
func _on_source_selected(index : int) -> void:
	$webcam.stop()
	
	$webcam.device = self._potentialSources[index]["paths"][0]
	$webcam.width = 1920
	$webcam.height = 1080
	$webcam.rotation = 0
	self.update_webcam_view_size($webcam.width, $webcam.height)
	
	$webcam.start()
	
	$webcamView.texture = $webcam.get_texture()

func _ready() -> void:
	$webcam.stop()
	
	# find potential sources 
	_potentialSources = $webcam.find_sources()
	
	for _potentialSource in _potentialSources:
		$OptionButton.add_item(_potentialSource["description"])
		
	self._error = $OptionButton.connect("item_selected", self, "_on_source_selected")
	
#	$webcam.device = "/dev/video2"
##	$webcam.width = 1920
##	$webcam.height = 1080
#	$webcam.width = 1920
#	$webcam.height = 1080
#	$webcam.rotation = 0
#	self.update_webcam_view_size($webcam.width, $webcam.height)
##	$webcamView.rect_min_size = Vector2(1920,1080)
#
#	$webcam.start()
#	$webcamView.texture = $webcam.get_texture()


func _on_saveBtn_pressed() -> void:
	$webcam.get_image().save_png("user://godot-webcam-screenshot.png")
