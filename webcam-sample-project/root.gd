extends Control

var _detectedSources : Array = []
var _currentSource : String
var _selectedSource : String

var _error : int 

onready var _webcam : Node = $webcam
onready var _webcamView : TextureRect = $VBoxContainer/CenterContainer/webcamView

onready var _startSourceButton : Button = $VBoxContainer/VBoxContainer2/GridContainer/startSourceButton
onready var _stopSourceButton : Button = $VBoxContainer/VBoxContainer2/GridContainer/stopSourceButton
onready var _refreshSourceListButton : Button = $VBoxContainer/VBoxContainer2/GridContainer/refreshSourceListButton
onready var _sourceSelectionOptionButton : OptionButton = $VBoxContainer/VBoxContainer2/OptionButton
onready var _saveStillImageButton : Button = $VBoxContainer/VBoxContainer2/saveBtn

func add_entries_to_source_list() -> void:
	for _potentialSource in self._detectedSources:
		self._sourceSelectionOptionButton.add_item(_potentialSource["description"])

func refresh_source_list() -> void:
	var _tmp_isPreviousDetectedSourcesEmpty : bool = (self._detectedSources == [])
	self._detectedSources = self._webcam.find_sources()
	
	if not _tmp_isPreviousDetectedSourcesEmpty:
		self._sourceSelectionOptionButton.clear()
		
	self.add_entries_to_source_list()
	
	if self._detectedSources != []:
		self._sourceSelectionOptionButton.emit_signal("item_selected", 0)

func select_source(index : int) -> void:
	# DESCRIPTION: Select only valid device path (which is normally the 
	# even number and the first entry of the paths array)
	# REMARK: Has to be seen as hardcoded and could lead to problems
	self._selectedSource = self._detectedSources[index]["paths"][0]
	
func start_selected_source() -> void:
	self._webcam.stop()
	
	self._currentSource = self._selectedSource
	
	self._webcam.device = self._currentSource
	self._webcam.width = 1920
	self._webcam.height = 1080
	self._webcam.rotation = 0
	self.update_webcam_view_size(self._webcam.width, self._webcam.height)
	
	self._webcam.start()
	
	self._webcamView.texture = self._webcam.get_texture()

func update_webcam_view_size(webCamWidth, webCamHeight) -> void:
	var _tmp_windowSize = OS.get_window_size()
	var _tmp_viewWidth = webCamWidth
	var _tmp_viewHeight = webCamHeight
	
	var _tmp_aspect_ratio = webCamWidth/webCamHeight
	
	if webCamWidth > _tmp_windowSize.x:
		_tmp_viewWidth = _tmp_windowSize.x
		_tmp_viewHeight = _tmp_windowSize.y/_tmp_aspect_ratio
	
	var _tmp_viewSize : Vector2 = Vector2(_tmp_viewWidth, _tmp_viewHeight)
	self._webcamView.rect_min_size = _tmp_viewSize
	self._webcamView.rect_size = _tmp_viewSize
	self._webcamView.set_anchors_preset(PRESET_CENTER)
	self._webcamView.rect_min_size = _tmp_viewSize
	self._webcamView.rect_size = _tmp_viewSize
	print("New Webcam View Size: ", self._webcamView.rect_min_size)
	
func _on_source_selected(index : int) -> void:
	self.select_source(index)
	
func _on_source_start_pressed() -> void:
	self.start_selected_source()
	
func _on_source_stop_pressed() -> void:
	self._webcam.stop()
	
func _on_source_list_refresh_pressed() -> void:
	self.refresh_source_list()
	
func _on_saveBtn_pressed() -> void:
	self._webcam.get_image().save_png("user://godot-webcam-screenshot.png")

func _ready() -> void:
	self._webcam.stop()
	
	# DESCRIPTION: Find potential sources and add the results to the source selection
	# option button
	self._detectedSources = self._webcam.find_sources()
	
	self.add_entries_to_source_list()
	
	# DESCRIPTION: Connect all the relevant signals to the methods
	self._error = self._startSourceButton.connect("pressed", self, "_on_source_start_pressed")
	self._error = self._sourceSelectionOptionButton.connect("item_selected", self, "_on_source_selected")
	self._error = self._saveStillImageButton.connect("pressed", self, "_on_saveBtn_pressed")
	self._error = self._stopSourceButton.connect("pressed", self, "_on_source_stop_pressed")
	self._error = self._refreshSourceListButton.connect("pressed", self, "_on_source_list_refresh_pressed")

	self._sourceSelectionOptionButton.emit_signal("item_selected", 0)
	

