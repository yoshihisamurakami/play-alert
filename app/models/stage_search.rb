class StageSearch
  include ActiveModel::Model
  
  attr_accessor :word
  
  def self.search(params)
    word = params[:word]
    if !word.present?
      return false
    end
    Stage.search(word)
  end
end