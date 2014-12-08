require 'spec_helper'

describe "create payment" do

  let (:event_data) do
    { 
    "id" =>  "evt_156OrlKNKSixVn3yIv6eg0Wt",
    "created" =>  1417796617,
    "livemode" =>  false,
    "type" =>  "charge.succeeded",
    "data" =>  {
      "object" =>  {
        "id" =>  "ch_156OrlKNKSixVn3yPilOJqSE",
        "object" =>  "charge",
        "created" =>  1417796617,
        "livemode" =>  false,
        "paid" =>  true,
        "amount" =>  1099,
        "currency" =>  "usd",
        "refunded" =>  false,
        "captured" =>  true,
        "refunds" =>  {
          "object" =>  "list",
          "total_count" =>  0,
          "has_more" =>  false,
          "url" =>  "/v1/charges/ch_156OrlKNKSixVn3yPilOJqSE/refunds",
          "data" =>  [

          ]
        },
        "card" =>  {
          "id" =>  "card_156OrjKNKSixVn3yPgoSi7xv",
          "object" =>  "card",
          "last4" =>  "4242",
          "brand" =>  "Visa",
          "funding" =>  "credit",
          "exp_month" =>  12,
          "exp_year" =>  2017,
          "fingerprint" =>  "DXmUPAK2cpKWhqzM",
          "country" =>  "US",
          "name" =>  nil,
          "address_line1" =>  nil,
          "address_line2" =>  nil,
          "address_city" =>  nil,
          "address_state" =>  nil,
          "address_zip" =>  nil,
          "address_country" =>  nil,
          "cvc_check" =>  "pass",
          "address_line1_check" =>  nil,
          "address_zip_check" =>  nil,
          "dynamic_last4" =>  nil,
          "customer" =>  "cus_5Gwl9BbUfeu7Z6"
        },
        "balance_transaction" =>  "txn_156OrlKNKSixVn3yGBPbNZpU",
        "failure_message" =>  nil,
        "failure_code" =>  nil,
        "amount_refunded" =>  0,
        "customer" =>  "cus_5Gwl9BbUfeu7Z6",
        "invoice" =>  "in_156OrkKNKSixVn3yl7ZRmqrS",
        "description" =>  nil,
        "dispute" =>  nil,
        "metadata" =>  {
        },
        "statement_description" =>  "RickFlix Charge",
        "fraud_details" =>  {
          "stripe_report" =>  "unavailable",
          "user_report" =>  nil
        },
        "receipt_email" =>  nil,
        "receipt_number" =>  nil,
        "shipping" =>  nil
      }
    },
    "object" =>  "event",
    "pending_webhooks" =>  1,
    "request" =>  "iar_5GwlSwnOMerEpL",
    "api_version" =>  "2014-11-05"
    }
  end
  it "creates a payment with a web hook from stripe", :vcr do
    post  "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end
  it "associates the payment with the user", :vcr do
    hank = Fabricate(:user, customer_token: "cus_5Gwl9BbUfeu7Z6")
    post  "/stripe_events", event_data
    expect(Payment.first.user).to eq(hank)
  end
  it "saves the payment amount", :vcr do
    post  "/stripe_events", event_data
    expect(Payment.first.amount).to eq(1099)
  end
  it "saves the payment reference", :vcr do
    post  "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_156OrlKNKSixVn3yPilOJqSE")
  end
end


