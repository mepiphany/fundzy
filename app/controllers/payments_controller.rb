class PaymentsController < ApplicationController
  before_action :authenticate_user
  before_action :find_pledge

  def new
  end

  def create
    stripe_customer = Stripe::Customer.create(
                        description: "Customer for #{current_user.email}",
                        source: params[:stripe_token]
                      )

    current_user.stripe_customer_id       = stripe_customer.id
    current_user.stripe_last_4            = stripe_customer.sources.data[0].last4
    current_user.stripe_card_type         = stripe_customer.sources.data[0].brand
    current_user.stripe_card_expiry_month = stripe_customer.sources.data[0].exp_month
    current_user.stripe_card_expiry_year  = stripe_customer.sources.data[0].exp_year

    current_user.save

    charge = Stripe::Charge.create(
                amount:      @pledge.amount * 100,
                currency:    "cad",
                customer:    current_user.stripe_customer_id,
                description: "Charge for pledge id: #{@pledge.id}"
              )

    @pledge.stripe_txn_id = charge.id
    @pledge.save

    redirect_to @pledge.campaign, notice: "Thanks for completing the payment"
  end

  private

  def find_pledge
    @pledge = current_user.pledges.find params[:pledge_id]
  end

end
