--[[
------------------------------Basic Table of Contents------------------------------
Line 17, Atlas ---------------- Explains the parts of the atlas.
Line 29, Joker 2 -------------- Explains the basic structure of a joker
Line 88, Runner 2 ------------- Uses a bit more complex contexts, and shows how to scale a value.
Line 127, Golden Joker 2 ------ Shows off a specific function that's used to add money at the end of a round.
Line 163, Merry Andy 2 -------- Shows how to use add_to_deck and remove_from_deck.
Line 207, Sock and Buskin 2 --- Shows how you can retrigger cards and check for faces
Line 240, Perkeo 2 ------------ Shows how to use the event manager, eval_status_text, randomness, and soul_pos.
Line 310, Walkie Talkie 2 ----- Shows how to look for multiple specific ranks, and explains returning multiple values
Line 344, Gros Michel 2 ------- Shows the no_pool_flag, sets a pool flag, another way to use randomness, and end of round stuff.
Line 418, Cavendish 2 --------- Shows yes_pool_flag, has X Mult, mainly to go with Gros Michel 2.
Line 482, Castle 2 ------------ Shows the use of reset_game_globals and colour variables in loc_vars, as well as what a hook is and how to use it.
--]]

--Creates an atlas for cards to use
SMODS.Atlas {
	-- Key for code to find it with
	key = "ModdedVanilla",
	-- The name of the file, for the code to pull the atlas from
	path = "ModdedVanilla.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

SMODS.Atlas {
	-- Key for code to find it with
	key = "Kaiju",
	-- The name of the file, for the code to pull the atlas from
	path = "Kaiju.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

SMODS.Joker {
	-- How the code refers to the joker.
	key = 'rainmaker',
	-- loc_text is the actual name and description that show in-game for the card.
	loc_txt = {
		name = 'Rainmaker',
		text = {
			--[[
			The #1# is a variable that's stored in config, and is put into loc_vars.
			The {C:} is a color modifier, and uses the color "mult" for the "+#1# " part, and then the empty {} is to reset all formatting, so that Mult remains uncolored.
				There's {X:}, which sets the background, usually used for XMult.
				There's {s:}, which is scale, and multiplies the text size by the value, like 0.8
				There's one more, {V:1}, but is more advanced, and is used in Castle and Ancient Jokers. It allows for a variable to dynamically change the color. You can find an example in the Castle joker if needed.
				Multiple variables can be used in one space, as long as you separate them with a comma. {C:attention, X:chips, s:1.3} would be the yellow attention color, with a blue chips-colored background,, and 1.3 times the scale of other text.
				You can find the vanilla joker descriptions and names as well as several other things in the localization files.
				]]
			--"{C:mult}+#1# {} Mult"
			"{C:mult}+#1#{} Mult for each {C:money}$1{} you have",
			"{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
		}
	},
	--[[
		Config sets all the variables for your card, you want to put all numbers here.
		This is really useful for scaling numbers, but should be done with static numbers -
		If you want to change the static value, you'd only change this number, instead
		of going through all your code to change each instance individually.
		]]
	config = {extra = 2},
	-- loc_vars gives your loc_text variables to work with, in the format of #n#, n being the variable in order.
	-- #1# is the first variable in vars, #2# the second, #3# the third, and so on.
	-- It's also where you'd add to the info_queue, which is where things like the negative tooltip are.
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra, card.ability.extra*math.max(0,G.GAME.dollars) or 0 } }
	end,
	-- Sets rarity. 1 common, 2 uncommon, 3 rare, 4 legendary.
	rarity = 3,
	-- Which atlas key to pull from.
	atlas = 'Kaiju',
	-- This card's position on the atlas, starting at {x=0,y=0} for the very top left.
	pos = { x = 4, y = 0 },
	-- Cost of card in shop.
	cost = 10,
	unlocked = true, --is joker unlocked by default.
    discovered = true,
	-- The functioning part of the joker, looks at context to decide what step of scoring the game is on, and then gives a 'return' value if something activates.
	calculate = function(self, card, context)
		if context.joker_main then
			-- Tells the joker what to do. In this case, it pulls the value of mult from the config, and tells the joker to use that variable as the "mult_mod".
			return {
				
				-- This is a localize function. Localize looks through the localization files, and translates it. It ensures your mod is able to be translated. I've left it out in most cases for clarity reasons, but this one is required, because it has a variable.
				-- This specifically looks in the localization table for the 'variable' category, specifically under 'v_dictionary' in 'localization/en-us.lua', and searches that table for 'a_mult', which is short for add mult.
				-- In the localization file, a_mult = "+#1#". Like with loc_vars, the vars in this message variable replace the #1#.
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra*math.max(0,G.GAME.dollars) } },
				-- Without this, the mult will stil be added, but it'll just show as a blank red square that doesn't have any text.
				
				mult_mod = (card.ability.extra*math.max(0,G.GAME.dollars)), --make the +mult activates ingame. -> for others see chip_mod, Xmult_mod all should be in the return section.
				colour = G.C.MULT --IDK what this does.
			}
		end
	end
}

SMODS.Joker{
	key = 'cyberman',
	loc_txt = {
		name = 'Cyberman',
		text = {
			"{X:mult,C:white} X#1# {} Mult"
		}
	},
	config = { extra = {Xmult = 3}},
	rarity = 4,
	atlas = 'Kaiju',
	pos = { x = 2, y = 0 },
	cost = 20,
	unlocked = true,
	discovered = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult,
			}
		end
	end

}

SMODS.Joker{
	key = 'oldhermit',
	loc_txt = {
		name = 'Old Hermit',
		text = {
			"{X:mult,C:white} X#1# {} Mult"
		}
	},
	config = { extra = {Xmult = 3}},
	rarity = 4,
	atlas = 'Kaiju',
	pos = { x = 3, y = 0 },
	cost = 20,
	unlocked = true,
	discovered = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult,
			}
		end
	end

}

SMODS.Joker{
	key = 'blackmass',
	loc_txt = {
		name = 'Black Mass',
		text = {
			"{X:mult,C:white} X#1# {} Mult"
		}
	},
	config = { extra = {Xmult = 3}},
	rarity = 4,
	atlas = 'Kaiju',
	pos = { x = 0, y = 0 },
	cost = 20,
	unlocked = true,
	discovered = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult,
			}
		end
	end

}

SMODS.Joker{
	key = 'chicken',
	loc_txt = {
		name = 'Le Cockatrice',
		text = {
			"{X:mult,C:white} X#1# {} Mult"
		}
	},
	config = { extra = {Xmult = 3}},
	rarity = 4,
	atlas = 'Kaiju',
	pos = { x = 1, y = 0 },
	cost = 20,
	unlocked = true,
	discovered = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.Xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
				Xmult_mod = card.ability.extra.Xmult,
			}
		end
	end

}


----------------------------------------------
------------MOD CODE END----------------------
