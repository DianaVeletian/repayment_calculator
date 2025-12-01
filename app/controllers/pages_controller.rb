class PagesController < ApplicationController
  def home
    puts "DEBUG: Amount is #{params[:amount].inspect}" # <--- New Line

    if params[:amount].present?
      puts "DEBUG: Entering calculation..." # <--- New Line

      @calculator = LoanMath.new(
        amount: params[:amount],
        rate: params[:rate],
        years: params[:years],
        monthly_overpayment: params[:monthly_overpayment]
      )
      @results = @calculator.calculate

      puts "DEBUG: Results are: #{@results.inspect}" # <--- New Line
    else
      puts "❌ DEBUG: Amount was empty, skipping calculation." # <--- New Line
    end
  end
end
