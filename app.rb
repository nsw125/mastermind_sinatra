class MastermindApp < Sinatra::Base

    configure :development do 
        register Sinatra::Reloader
        enable :sessions
    end

    not_found do
        erb :error
    end

    get '/' do
        erb :mastermind
    end

    get '/game' do
        @game = CodeBreaker.new
        session["game"] = @game
        session["code"] = @game.code
        @session = session
        session["guess_list"] = []
        code = @game.code
        erb :game, :locals => { :turn_counter => @game.turn_counter, :message => "Make a guess using the dropdown menus!", :guess_list => session["guess_list"]}
    end

    post '/game' do
        guess = []
        guess << params["color1"]
        guess << params["color2"]
        guess << params["color3"]
        guess << params["color4"]
        session["guess_list"] << guess
        message = session["game"].compare_code(guess)
        code = session["code"]
        turn_counter = session["game"].turn_counter
        if turn_counter == 8 or session["game"].positions_correct == 4
            redirect '/game_over' 
        else
            erb :game, :locals => { :secret_code => code, :turn_counter => turn_counter, :message => message, :guess_list => session["guess_list"] }
        end
    end

    get '/game_over' do
        erb :game_over, :locals => { :message => session["game"].message }
    end

    class CodeBreaker

        attr_reader :code, :turn_counter, :positions_correct, :message
        def initialize
            @code = create_code
            @winner = false
            @turn_counter = 0
        end
    
        def compare_code(guess)
            @colors_correct = 0
            @positions_correct = 0
    
            guess.each_with_index do |color, index|
                if color == @code[index]
                    @positions_correct += 1
                end
            end
            if @positions_correct == 4
                @winner = true
                @message = game_over
            else
                colors_correct = guess.select { |color| @code.any? { |secret_color| secret_color == color }}
                @turn_counter += 1
                @message = "Correct Position: #{@positions_correct} Correct Colors: #{colors_correct.length}"
                if @turn_counter == 8
                    @message = game_over
                end
                @message
            end
        end
    
        def game_over
            if @winner == true
                @message = "You win! The code was #{@code}"
            else
                @message = "Oh no, you lose! The code was #{code}"
            end
            @message
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
end