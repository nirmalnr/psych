class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    private
    def room_exists(roomname)
        if !roomname #return true if called without name
            return true
        end
        room = Room.where(name: roomname).first 
    end

    def user_in_room(room_id,user_id)
        Scorecard.where(room_id:room_id,user_id:user_id).first
    end

    def get_question_and_answer
        response = JSON.parse HTTP.get("https://opentdb.com/api.php?amount=1&type=multiple").to_s
        question = response['results'][0]['question']
        answer   = response['results'][0]['correct_answer']
        return question, answer
    end

    def calculate_score(room)
        scorecards = Scorecard.where(room_id:room.id)
        scorecards.each do |curr|
            rounds = curr.rounds
            curr.update(rounds:rounds+1)
            scorecards.each do |card|
                score = curr.score
                if card.selected_answer == curr.user_answer
                    score = score +1
                end
                curr.update(score:score)
            end
        end
    end

    def clear_scorecard(room_id)
        scorecards = Scorecard.where(room_id:room_id)
        scorecards.update(selected_answer:nil,user_answer:nil,status:'playing')
    end

end
