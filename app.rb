class App
  def self.process(params = {})
    up_to = params[:up_to].to_i
    iterations = params[:iterations].to_i

    data = []
    iterations.times do
      data << BigMath.PI(up_to)
    end
  end
end
