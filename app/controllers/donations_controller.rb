class DonationsController < ApplicationController

  def new
  end

  def create
    # Amount in cents
    @pretty_amount = params[:amount]
    @amount = (params[:amount].to_f * 100).to_i

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'Rekrei Donation',
      :currency    => 'eur'
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to donate_path
  end

end
