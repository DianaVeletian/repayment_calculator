# app/models/loan_math.rb
class LoanMath
  include ActiveModel::Model

  attr_accessor :amount, :rate, :years, :monthly_overpayment

  def calculate
    # Convert inputs to numbers
    principal = amount.to_f
    monthly_rate = (rate.to_f / 100) / 12
    months = years.to_i * 12
    extra = monthly_overpayment.to_f

    # Standard Monthly Payment Formula
    standard_payment = principal * (monthly_rate * (1 + monthly_rate)**months) / ((1 + monthly_rate)**months - 1)

    # Calculate both scenarios
    normal_results = run_amortisation(principal, monthly_rate, standard_payment, 0)
    faster_results = run_amortisation(principal, monthly_rate, standard_payment, extra)

    {
      standard_payment: standard_payment,
      normal_total_interest: normal_results[:total_interest],
      faster_total_interest: faster_results[:total_interest],
      months_saved: normal_results[:months] - faster_results[:months],
      money_saved: normal_results[:total_interest] - faster_results[:total_interest]
    }
  end

  private

  def run_amortisation(balance, rate, payment, extra)
    total_interest = 0
    months = 0

    while balance > 0
      interest = balance * rate
      total_interest += interest
      principal_paid = (payment + extra) - interest

      # Handle the final month logic
      if balance < principal_paid
        principal_paid = balance
      end

      balance -= principal_paid
      months += 1

      # Preventing infinite loops
      break if months > 1200
    end

    { total_interest: total_interest, months: months }
  end
end
