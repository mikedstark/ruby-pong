require 'gosu'

class Pong < Gosu::Window
	def initialize width=800, height=600, fullscreen=true
		super
		self.caption = 'Pong'
		@score1 = 0
		@score2 = 0
		@paddle_length = 100
		@paddle_width = 10
		@distance_from_wall = 15
		
		@y = self.height/2 - @paddle_length
		@y2 = self.height/2 - @paddle_length

		@font1 = Gosu::Font.new(50)
		@font2 = Gosu::Font.new(50)

		@ball = Gosu::Image.new("ball.png")
		
		@xBall = self.width/2 - @ball.width/2
		@yBall = self.height/2 - @ball.height/2
		@velocity_x = 3
		@velocity_y = 3
	end

	def button_down id
		close if id == Gosu::KbEscape
		#@score1 += 1 if id == Gosu::Kb5
		#@score2 += 1 if id == Gosu::Kb6
	end

	def update
		@xBall += @velocity_x	
		@yBall += @velocity_y

		#p1 scores
		if @xBall > self.width + @ball.width 
			@velocity_x *= -1
			@score1 += 1
			@xBall = self.width/2 - @ball.width/2
			@yBall = self.height/2 - @ball.height/2
		end

		#p2 scores
		if @xBall < 0 - @ball.width
			@velocity_x *= -1
			@score2 += 1
			@xBall = self.width/2 - @ball.width/2
			@yBall = self.height/2 - @ball.height/2
		end

		#bounce off top or bottom
		if @yBall > self.height - @ball.height || @yBall < 0
			@velocity_y *= -1
		end

		#Bounce off P1 paddle
		if 	@yBall >= @y - @ball.height && @yBall <= @y + @paddle_length  &&
			@xBall < @distance_from_wall + @paddle_width/2 &&
			@xBall > @distance_from_wall

			@velocity_x *= -1
			#@velocity_y *= -1
		end

		#Bounce off P2 paddle
		if 	@yBall >= @y2 - @ball.height && @yBall <= @y2 + @paddle_length  &&
			@xBall + @ball.width > self.width - @distance_from_wall - @paddle_width/2 &&
			@xBall + @ball.width < self.width - @distance_from_wall
			@velocity_x *= -1
			#@velocity_y *= -1
		end

		#paddle 1 going down
		if button_down?(Gosu::KbDown)
			if @y < self.height - @paddle_length
				@y += 5
			end
		end
		
		#paddle 1 going up
		if button_down?(Gosu::KbUp)
			if @y > 0
				@y -= 5
			end
		end

		#paddle 2 going down
		if button_down?(Gosu::KbV)
			if @y2 < self.height - @paddle_length
				@y2 += 5
			end
		end

		#paddle 2 going up
		if button_down?(Gosu::KbS)
			if @y2 > 0	
				@y2 -= 5
			end
		end
	end

	def draw
		draw_net()
		draw_player_1()
		draw_player_2()
		draw_score()
		draw_ball()
	end

	def draw_ball
		@ball.draw @xBall,@yBall,0
	end

	def draw_score
		@font1.draw @score1.to_s, self.width/4, 10, 1
		@font2.draw @score2.to_s, self.width/1.5, 10, 1
	end

	def draw_net
		x = self.width/2
		y1 = 10
		y2 = 20
		size = 5
		dist_between = 30

		for i in 0..19
			draw_quad(x-size,y1 + i*dist_between,0xffffffff,
					  x+size,y1 + i*dist_between,0xffffffff,
					  x-size,y2 + i*dist_between,0xffffffff,
					  x+size,y2 + i*dist_between,0xffffffff)
		end
	end

	def draw_player_1
		x1 = @distance_from_wall
		x2 = x1 + @paddle_width
		y1 = @y
		y2 = @y + @paddle_length
		draw_quad(x1,y1,0xffffffff,
				  x2,y1,0xffffffff,
				  x1,y2,0xffffffff,
				  x2,y2,0xffffffff)
	end

	def draw_player_2
		x1 = self.width - @distance_from_wall - @paddle_width
		x2 = x1 + @paddle_width
		y1 = @y2
		y2 = @y2 + @paddle_length
		draw_quad(x1,y1,0xffffffff,
				  x2,y1,0xffffffff,
				  x1,y2,0xffffffff,
				  x2,y2,0xffffffff)
	end

end ##Pong

Pong.new.show
