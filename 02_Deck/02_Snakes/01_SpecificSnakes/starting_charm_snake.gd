extends Snake

# What is the best way to do this? Do we make this a scene so that we can just use export vars?
func _init() -> void:
	snake_name = "Green Viper"
	cost = 0
	# attached_drink -- what's the best way to do this? 
	description = ""
	flavour_text = "The Green Viper is known for its charming allure. Those that it charms are often not heard from again."
