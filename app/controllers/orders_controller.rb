class OrdersController < ApplicationController
    before_action :authenticate_user!

    def new
        @amount = 5000 #amount in cents
    end

    def create
        byebug
        begin
            customer = if current_user.stripe_customer_id.blank?
                            Stripe::Customer.create(email: current_user.email)
                       else
                            Stripe::Customer.retrieve(current_user.stripe_customer_id)
                       end
                       
            customer.sources.create(source: 'tok_1OzGozSAYMjwg6v5Z4CVIAi5')

            charge = Stripe::Charge.create(
                customer: customer.id,
                amount: params[:amount],
                description: 'Rails Stripe Customer',
                currency: 'usd'
            )

            @order = current_user.orders.create(amount: params[:amount], stripe_charge_id: charge.id)

            current_user.update(stripe_customer_id: customer.id) if current_user.stripe_customer_id.blank?

            redirect_to order_success_path(@order), notice: "Payment was successful!"

        rescue Stripe::CardError => e
            flash[:error] = e.message
            redirect_to order_failure_path
        rescue => e
            flash[:error] = "There was an error processing your payment: #{e.message}"
            redirect_to new_order_path
        end
    end

    def success
        @order = Order.find(params[:id])
        @order.update(status: :paid)
    end
    
    def failure
        render :failure
    end

    private

    def order_params
        params.require(:order).permit(:amount)
    end
end
