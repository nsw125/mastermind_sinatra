require "sinatra"
require "erb"

class CodeBreaker

    def initialize
        @code = create_code
        @winner = false
    end

    def code
        @code
    end

    def compare_code(guess)
        @guess = guess
        @colors_correct = 0
        @positions_correct = 0

        @guess.each_with_index do |color|
            if color == @code[index]
                @positions_correct += 1
            end
        end
        if @positions_correct == 4
            @winner = true
            game_over
        end
        @colors_correct = @guess.select { |color| @code.any? { |secret_color| secret_color == color }}
        @turn_counter += 1
        if @turn_counter == 8
            game_over
        end
    end

    def game_over
        if @winner == true
            "You win! The code was #{@code}"
        else
            "Oh no, you lose! The code was #{code}"
        end
    end

    def create_code
        code_string = []
        4.times do 
            color = rand(1..6)
            case color
            when 1
                color =  'red'
            when 2
                color = 'orange'
            when 3
                color = 'yellow'
            when 4
                color = 'green'
            when 5
                color = 'blue'
            when 6
                color = 'purple'
            end
            code_string << color
        end
        code_string
    end

end