require 'rack/request'
require 'rack/response'
require 'haml'
require 'thin'
require 'rack'
  
module RockPaperScissors
	class RPS 
 		def initialize(app = nil)
			@app = app
			@content_type = :html
			@defeat = {'Piedra' => 'Tijeras', 'Papel' => 'Piedra', 'Tijeras' => 'Papel'}
			@throws = @defeat.keys
			@ganadas=0
			@perdidas=0
			@empatadas=0
		end #Ende del def initialize
  
		def call(env)
			req = Rack::Request.new(env)
			computer_throw = @throws.sample
			player_throw = req.GET["jugada"]
			ganadas=0
			perdidas=0
			empatadas=0
			anwser =
				if !@throws.include?(player_throw)
					"Realiza tu jugada."
				elsif player_throw == computer_throw
					@empatadas = @empatadas + 1
					"Estas salvado, #{player_throw} contra #{computer_throw} es un empate."
					
				elsif computer_throw == @defeat[player_throw]
					@ganadas = @ganadas + 1
					"Muy bien, #{player_throw} gana a #{computer_throw}. ¿Te atreves a seguir jugando?"
					
				else
					@perdidas = @perdidas + 1
					"Oh has perdido, #{computer_throw} gana a #{player_throw}. Sigue intentandolo, ¡Suerte!"
					
				end
			engine = Haml::Engine.new File.open("views/rps.html.haml").read
			res = Rack::Response.new
			res.write engine.render({},
				:anwser => anwser,
				:throws => @throws,
				:computer_throw => computer_throw,
				:ganadas => @ganadas,
				:perdidas => @perdidas,
				:empatadas => @empatadas,
				:player_throw => player_throw)

			res.finish





		end # End del def call
	end #End de class
end #End del module
