module Api
  module V1
    class InsightsController < ApplicationController
      def index
        result = Insights::SalarySummaryService.new(
          country: params[:country],
          job_title: params[:job_title]
        ).call

        render json: result
      rescue ArgumentError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
  end
end