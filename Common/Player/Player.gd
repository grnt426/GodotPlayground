extends Node

class_name Player

var username := ""
var id := -1
var connId := -1
var online := false

func init(username, id, connId):
	self.username = username
	self.id = id
	self.connId = connId
