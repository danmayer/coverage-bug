class AppProxy
  def self.process(app, params = {})
    coverage = params.delete(:coverage)
    enhanced_coverage = params.delete(:enhanced_coverage)
    Coverage.resume if enhanced_coverage
    app.process(params)

    results = {}
    results = Coverage.result if coverage
    if enhanced_coverage
      Coverage.pause
      results = Coverage.peek_result
    end
    results
  end
end
