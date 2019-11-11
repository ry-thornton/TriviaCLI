require_relative '../config/environment'
require 'pry'
ActiveRecord::Base.logger.level = 1
system("clear")
require 'colorize'


def welcome
    
    puts "Hello, Welcome to Streak Trivia. Please enter: (1) to" + " LOGIN".colorize(:green).bold
    puts "                                               (2) to see" + " CURRENT BEST STREAK".colorize(:blue).bold
    puts "                                               (ctrl-z) to" + " QUIT".colorize(:red).bold
    input = gets.chomp.downcase
    if input == "1"
        page_break
        puts "Please enter username:"
        username = gets.chomp.downcase
        page_break
        save_user(username)
    elsif input == "2"
        page_break
        find_highest_score
        restart_welcome
    else
        page_break
        puts "Sorry, that isn't a valid entry. Gimme 20 push ups!  Then try again."
        restart_welcome
    end
end

def restart_welcome
    page_break
    puts "Please enter: (1) to" + " LOGIN".colorize(:green).bold
    puts "              (2) to see" + " CURRENT BEST STREAK".colorize(:blue).bold
    puts "              (ctrl-z) to" + " QUIT".colorize(:red).bold
    input = gets.chomp.downcase
        if input == "1"
            page_break
            puts "Please enter a username to start!"
            username = gets.chomp.downcase
            save_user(username)
        elsif input == "2"
            page_break
            find_highest_score
        else
            page_break
            puts "Sorry, that isn't a valid entry. Please try again."
            restart_welcome
        end
end

def game_start(username)
    page_break
    puts "Welcome #{username.colorize(:blue).bold}, you will be asked questions 
        until you get one incorrect. Answer each question by typing
        out the correct answer. Please enter proper capitilization and punctuation
        to move on to the next question. If question is unanswerable, please type
        in 'pass'. Get ready to play. (Press 'ctrl-z' at any time to quit the game)"
    run_game(username, count = 0)
end


def run_game(username, count = 0)
    page_break
    answers_array = []
    random_question = Question.all.sample
    exact_question = random_question.question_text
    exact_question_incorrect_choice_1 = random_question.incorrect_answer1
    exact_question_incorrect_choice_2 = random_question.incorrect_answer2
    exact_question_incorrect_choice_3 = random_question.incorrect_answer3
    exact_question_correct_answer = random_question.correct_answer
    answers_array << exact_question_correct_answer
    answers_array << exact_question_incorrect_choice_1
    answers_array << exact_question_incorrect_choice_2
    answers_array << exact_question_incorrect_choice_3
    puts exact_question.colorize(:blue)
    puts ""
    puts answers_array.shuffle
    page_break

    answer = gets.chomp.downcase
        if answer.to_s.downcase == (random_question.correct_answer.downcase)
            pid = fork{ exec 'afplay', 'chaching.mp3' }
            new_count = (count += 1)
            run_game(username, new_count)
        elsif answer.to_s.downcase == "pass"
            new_count = count
            run_game(username, new_count)
        else
            page_break
            pid = fork{ exec 'afplay', 'perfect-fart.mp3' }

            new_count = count
            puts "Sorry! That was not the correct answer :( You finished with a streak of #{count}!".colorize(:red)
            play_again_prompt(username)
        end
    
    user = User.all.find do |user|
        user.name == username
    end

    Game.create(user_id: user.id, score: new_count)
end


def save_user(username)
    usernames = User.all.map do |user|
        user.name
    end

        if usernames.include?(username)
            puts "Welcome back #{username.colorize(:blue).bold}! Please enter: (1) to" + " PLAY".colorize(:green).bold
            puts "                                 (2) to" + " SEE YOUR HIGHEST STREAK".colorize(:blue).bold
            puts "                                 (3) to" + " CHANGE USERNAME".colorize(:cyan)
            puts "                                 (4) to" + " DELETE YOUR ACCOUNT (...obviously we advise against this)".colorize(:red).bold
            page_break
            
            input = gets.chomp.downcase
                if input == "1"
                    game_logo
                    run_game(username, count = 0)
                elsif input == "2"
                    page_break
                    my_highest_score(username)
                elsif input == "3"
                    page_break
                    puts "Please enter new username"
                    new_name = gets.chomp.downcase
                    change_username(new_name, username)

                elsif input == "4"
                    User.find_by(name: username).delete
                    puts "We're sorry to see you go :("
                    puts "Your account has been deleted.".colorize(:red)
                    welcome
                else
                    puts "Sorry, that isn't a valid entry. Please try again."
                    go_to_menu(username)

                end
        else
            new_user = User.create(name: username)
            game_start(username)
        end 
end

def find_highest_score
    highest_score = Game.order(score: :desc).first.score
    # highest_score_id = Game.all.where(score: highest_score).user_id
    # name = Game.all.where(user_id: highest_score_id).name
    puts "The current longest streak is..." + " #{highest_score}".colorize(:green)
end

def my_highest_score(username)
    my_user = User.all.find_by(name: username)
    my_user_id = my_user.id
    highest_score = Game.all.where(user_id: my_user_id).order(score: :desc).first.score
        if highest_score >= 3
        puts "Your highest score is #{highest_score}!!! Want to try and beat this score? Please enter:
                                                                                            (y) for 'yes'
                                                                                            (n) for 'no'"
            input = gets.chomp.downcase
                if input == "y"
                    
                    game_logo

                    run_game(username, count = 0)
                elsif input == "n"
                    go_to_menu(username)
                end
        
        else 
            puts "Your highest score is #{highest_score}!!! This is nothing to brag about. Find a new hobby cause Streak Trivia ain't it"
            go_to_menu(username)
        end
end

def change_username(new_name, username)
    page_break
    usernames = User.all.map do |user|
        user.name
    end
    if usernames.include?(new_name)
        page_break
        puts "Sorry, that username is already taken. Please choose another one."
        new_name = gets.chomp.downcase
        change_username(new_name, username)

    else
        User.find_by(name: username).update(name: new_name)
        puts "Your username is now #{new_name}!".colorize(:green)
        go_to_menu(username)
    end
end

def page_break
    puts "----------------------------------------------------------------------------------------------"
end

def play_again_prompt(username)
    page_break
    puts "Would you like to play again? Press y for 'yes' and n for 'no'"
    input = gets.chomp.downcase
        if input == "y"
            
            game_logo 
    
            run_game(username, count = 0)
        elsif input == "n"
            page_break
            puts "Have a nice day!"
        else
            puts "Sorry, that was not a valid entry. Please try again"
            play_again_prompt(username)
        end
end

def game_logo
    system("clear")
    puts "
    ███████╗████████╗██████╗ ███████╗ █████╗ ██╗  ██╗    ████████╗██████╗ ██╗██╗   ██╗██╗ █████╗ 
    ██╔════╝╚══██╔══╝██╔══██╗██╔════╝██╔══██╗██║ ██╔╝    ╚══██╔══╝██╔══██╗██║██║   ██║██║██╔══██╗
    ███████╗   ██║   ██████╔╝█████╗  ███████║█████╔╝        ██║   ██████╔╝██║██║   ██║██║███████║
    ╚════██║   ██║   ██╔══██╗██╔══╝  ██╔══██║██╔═██╗        ██║   ██╔══██╗██║╚██╗ ██╔╝██║██╔══██║
    ███████║   ██║   ██║  ██║███████╗██║  ██║██║  ██╗       ██║   ██║  ██║██║ ╚████╔╝ ██║██║  ██║
    ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝       ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═╝╚═╝  ╚═╝                                                                                             
    ".colorize(:blue)

end

def go_to_menu(username)
    page_break
    puts "Please enter: (1) to" + " PLAY".colorize(:green).bold
    puts "              (2) to" + " SEE YOUR HIGHEST STREAK".colorize(:blue).bold
    puts "              (3) to" + " CHANGE USERNAME".colorize(:cyan)
    puts "              (4) to" + " DELETE YOUR ACCOUNT (...obviously we advise against this)".colorize(:red).bold
                page_break
                
                input = gets.chomp.downcase
                    if input == "1"
                        game_logo
                        run_game(username, count = 0)
                    elsif input == "2"
                        page_break
                        my_highest_score(username)
                    elsif input == "3"
                        page_break
                        puts "Please enter new username"
                        new_name = gets.chomp.downcase
                        change_username(new_name, username)

                    elsif input == "4"
                        User.find_by(name: username).delete
                        puts "We're sorry to see you go :("
                        puts "Your account has been deleted.".colorize(:red)
                        welcome
                    else
                        puts "Sorry, that isn't a valid entry. Please try again."
                        go_to_menu(username)

                    end
end

def space
    puts ""
end


game_logo
welcome

