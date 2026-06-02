extends Drink

# What is the best way to do this? Do we make this a scene so that we can just use export vars?
func _init() -> void:
	drink_name = "Red Viper Venom"
	poison = 1
	charm = 0
	strength = 1
	description = ""
	flavour_text = "The vicious Red Viper doesn't give its prey much time before it strikes."
