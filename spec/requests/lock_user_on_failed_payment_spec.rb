require 'spec_helper'

describe "lock user when payment fails" do

  let (:event_data) do
    {"id"=>"evt_157XFrKNKSixVn3yfs8Sy0Ue", 
      "created"=>1418067191, 
      "livemode"=>false, 
      "type"=>"charge.failed", 
      "data"=>
        {"object"=>
          {"id"=>"ch_157XFrKNKSixVn3ySaw16ETJ", 
            "object"=>"charge", 
            "created"=>1418067191, 
            "livemode"=>false, 
            "paid"=>false, 
            "amount"=>1400, 
            "currency"=>"usd", 
            "refunded"=>false, 
            "captured"=>false, 
            "refunds"=>{"object"=>"list", "total_count"=>0, "has_more"=>false, "url"=>"/v1/charges/ch_157XFrKNKSixVn3ySaw16ETJ/refunds", "data"=>nil}, 
            "card"=>{"id"=>"card_157WgXKNKSixVn3ypgqAOJMF", 
              "object"=>"card", "last4"=>"0341", "brand"=>"Visa", "funding"=>"credit", "exp_month"=>12, "exp_year"=>2015, "fingerprint"=>"nuwlhtUBUv7w5UHX", "country"=>"US", "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "cvc_check"=>nil, "address_line1_check"=>nil, "address_zip_check"=>nil, "dynamic_last4"=>nil, "customer"=>"cus_5HiBOWmoS1qF7N"}, "balance_transaction"=>nil, "failure_message"=>"Your card was declined.", "failure_code"=>"card_declined", "amount_refunded"=>0, "customer"=>"cus_5HiBOWmoS1qF7N", "invoice"=>nil, "description"=>"adfafd", "dispute"=>nil, "metadata"=>{}, "statement_description"=>"adfadfaf", "fraud_details"=>{"stripe_report"=>"unavailable", "user_report"=>nil}, "receipt_email"=>nil, "receipt_number"=>nil, "shipping"=>nil}}, "object"=>"event", "pending_webhooks"=>1, "request"=>"iar_5I7U1MJ7aqDdzf", "api_version"=>"2014-11-05", "webhook"=>{"id"=>"evt_157XFrKNKSixVn3yfs8Sy0Ue", "created"=>1418067191, "livemode"=>false, "type"=>"charge.failed", "data"=>{"object"=>{"id"=>"ch_157XFrKNKSixVn3ySaw16ETJ", "object"=>"charge", "created"=>1418067191, "livemode"=>false, "paid"=>false, "amount"=>1400, "currency"=>"usd", "refunded"=>false, "captured"=>false, "refunds"=>{"object"=>"list", "total_count"=>0, "has_more"=>false, "url"=>"/v1/charges/ch_157XFrKNKSixVn3ySaw16ETJ/refunds", "data"=>nil}, "card"=>{"id"=>"card_157WgXKNKSixVn3ypgqAOJMF", "object"=>"card", "last4"=>"0341", "brand"=>"Visa", "funding"=>"credit", "exp_month"=>12, "exp_year"=>2015, "fingerprint"=>"nuwlhtUBUv7w5UHX", "country"=>"US", "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "cvc_check"=>nil, "address_line1_check"=>nil, "address_zip_check"=>nil, "dynamic_last4"=>nil, "customer"=>"cus_5HiBOWmoS1qF7N"}, "balance_transaction"=>nil, "failure_message"=>"Your card was declined.", "failure_code"=>"card_declined", "amount_refunded"=>0, 
              "customer"=>"cus_5HiBOWmoS1qF7N", "invoice"=>nil, "description"=>"adfafd", "dispute"=>nil, "metadata"=>{}, "statement_description"=>"adfadfaf", "fraud_details"=>{"stripe_report"=>"unavailable", "user_report"=>nil}, "receipt_email"=>nil, "receipt_number"=>nil, "shipping"=>nil}}, 
              "object"=>"event", "pending_webhooks"=>1, "request"=>"iar_5I7U1MJ7aqDdzf", "api_version"=>"2014-11-05"}}
  end

  it "locks user if failed payment", :vcr do
    hank = Fabricate(:user, customer_token: "cus_5HiBOWmoS1qF7N")
    post  "/stripe_events", event_data
    expect(User.first.locked).to eq(true)
  end

end
