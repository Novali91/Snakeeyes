extends Snake

# What is the best way to do this? Do we make this a scene so that we can just use export vars?
func _init() -> void:
	snake_name = "Red Viper"
	cost = 0
	# attached_drink -- what's the best way to do this? 
	description = ""
	flavour_text = "The vicious Red Viper doesn't give its prey much time before it strikes."
