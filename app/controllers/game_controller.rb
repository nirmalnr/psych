class GameController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, except: [:home, :create_room, :join_room, :get_joined_users, :get_bs_stat, :get_answer_stat, :get_ready_stat]

  def home
  end

  def create_room
    if request.post?
      room_name = ('A'..'Z').to_a.shuffle[0,4].join while room_exists(room_name)
      @room = Room.create(name:room_name)
      session[:room_id] = @room.id
      Scorecard.create(room_id:@room.id, user_id:current_user.id, status:'ready')
    else #get
      @room = Room.where(id:session[:room_id]).first
      if !@room 
        redirect_to root_path
      end
    end
  end

  def get_joined_users #async renderer
    @joined = Scorecard.where(room_id:session[:room_id])
    render partial: 'joined_users'
  end

  def join_room
    if request.post?
      room_name = params[:room_name]
      @room = Room.where(name:room_name).first
      if @room 
        session[:room_id] = @room.id
        if !user_in_room(@room.id,current_user.id)
          Scorecard.create(room_id:@room.id, user_id:current_user.id, status:'ready')
        end
      else 
        redirect_to root_path, notice: "Room not found"
      end
    else #get
      @room = Room.where(id:session[:room_id]).first
      if !@room 
        redirect_to root_path
      end
    end
  end

  def get_bs
    if request.post?
      if @room.status == "waiting_for_players"
        question, answer = get_question_and_answer
        @room.update(status:"waiting_for_bs",question:question,answer:answer)
        clear_scorecard(session[:room_id])
      end
    else #get
      if @room.status != "waiting_for_bs"
        redirect_to game_join_room_path
      end
    end
  end

  def collect_bs
    if request.post?
      scorecard = Scorecard.where(room_id:@room.id,user_id:current_user.id).first
      scorecard.update(user_answer:params[:bs])
    end
  end 

  def get_bs_stat #async renderer
    scorecards = Scorecard.where(room_id:session[:room_id])
    @stats = {}
    @path = '/game/quiz'
    scorecards.each do |card|
      @stats[card.user_id] = card.user_answer ? true : false
    end
    render partial: 'answer_stats'
  end

  def quiz
    if request.post?
      if @room.status == "waiting_for_bs"
        @room.update(status:"waiting_for_answer")
      end
    end
    scorecards = Scorecard.where("room_id = ? and user_id != ?",@room.id,current_user.id)
    @question = @room.question
    @options = []
    @options.append(@room.answer)
    scorecards.each do |card|
      @options.append(card.user_answer)
    end
    @options.shuffle!
  end

  def collect_answer
    if request.post?
      scorecard = Scorecard.where(room_id:@room.id,user_id:current_user.id).first
      scorecard.update(selected_answer:params['answer'],status:'answered')
    end
  end 

  def get_answer_stat #async renderer
    scorecards = Scorecard.where(room_id:session[:room_id])
    @stats = {}
    @path = '/game/score'
    scorecards.each do |card|
      @stats[card.user_id] = card.selected_answer ? true : false
    end
    render partial: 'answer_stats'
  end

  def score
    if request.post?
      if @room.status == "waiting_for_answer"
        @room.update(status:"show_score")
        calculate_score(@room)
      end
    end
    @scorecards = Scorecard.where(room_id:@room.id)
  end

  def wait_for_next
    scorecard = Scorecard.where(room_id:@room.id,user_id:current_user.id).first
    scorecard.update(status:'ready')
    if @room.status == "show_score"
      @room.update(status:"waiting_for_players")
    end
  end

  def get_ready_stat #async renderer
    scorecards = Scorecard.where(room_id:session[:room_id])
    @stats = {}
    @path = '/game/get_bs'
    scorecards.each do |card|
      @stats[card.user_id] = card.status.in?(['ready','playing']) ? true : false
    end
    render partial: 'answer_stats'
  end

  private
  def set_room
    @room = Room.where(id:session[:room_id]).first
    if !@room 
      redirect_to root_path
    end
  end

end
