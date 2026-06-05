class_name AbilityHelper
extends Node

var sm: TopStateMachine

const NO_ABILITY: int = 0
const BLUE_VIPER: int = 1

func trigger_ability(ind: int) -> void:
	match ind:
		NO_ABILITY:
			return
		BLUE_VIPER:
			## Lock camera?
			## Maybe bring up some ui for the selection?
			## Make it so you can't end turn while selecting?
			var chosen_drink: Drink = await sm.hand_manager.ability_helper.choose_drink()
			sm.hand_manager.ability_helper.slide_drink_back(chosen_drink)
			sm.deck_manager.return_to_drawpile(chosen_drink)
		pass
