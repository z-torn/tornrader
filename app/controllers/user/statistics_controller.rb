class User::StatisticsController < ApplicationController
  before_action :confirm_subscription
  before_action :authenticate_user!

  def index
    @all_trades ||= current_user.trades.group_by_day(:created_at).count
    @all_profit ||= current_user.trades.group_by_day { |u| u.created_at }.map { |k, v| [k, v.map{|t| t.profit}.sum] }.to_h

    @all_trades_count ||= current_user.trades_count
    @sellers ||= current_user.trades.all.pluck(:seller)

    @top_seller ||= @sellers.group_by{|i| i}.max{|x,y| x[1].length <=> y[1].length}[0]
    
    @total ||= current_user.trades.pluck(:total).sum
    
    @traders_data ||= @sellers.group_by(&:itself).map do |k, v| 
      next if v == 0
      {name: k, count: v.length}
    end.sort_by { |hsh| hsh[:count] }.reverse![0...5]

    @total_items = current_user.trades.map { |t| t.line_items.pluck(:quantity) }.flatten.sum
  end
end
