extends Node
class_name Database

var db = PostgreSQLClient.new()

const USER = "postgres"
const PASSWORD = "whatever"
const HOST = "127.0.0.1"
const PORT = 5432 # Default postgres port
const DATABASE = "postgres" # Database name
var connected = false

func _init() -> void:
	print("Init called!")
	var _error = db.connect("connection_established", self, "_executer")
	_error = db.connect("authentication_error", self, "_authentication_error")
	_error = db.connect("connection_closed", self, "_close")
	
	#Connection to the database
	_error = db.connect_to_host("postgresql://%s:%s@%s:%d/%s" % [USER, PASSWORD, HOST, PORT, DATABASE])
	print("Init called!")
	
func _authentication_error(error_object: Dictionary) -> void:
	print("Error connection to database:", error_object["message"])

func _executer() -> void:
	connected = true
	print("Connected to DB")
	print("Database Status %s" % db.parameter_status)

func _close(clean_closure := true) -> void:
	print("DB CLOSE,", "Clean closure:", clean_closure)

func _exit_tree() -> void:
	db.close()

func isConnected() -> bool:
	return connected

func _process(delta):
	db.poll()
