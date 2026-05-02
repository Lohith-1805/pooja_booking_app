// @ts-nocheck
// ↑ This file runs on Deno (Supabase Edge Functions), not Node.js.
//   VS Code's built-in TypeScript server doesn't know Deno globals (like Deno.env).
//   @ts-nocheck tells it to skip type-checking this file — the code is correct for Deno.
// Supabase Edge Function: create-razorpay-order
// Deploy with: supabase functions deploy create-razorpay-order
// Set secret:  supabase secrets set RAZORPAY_SECRET=your_secret_key_here

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { amount, currency = "INR", receipt, notes } = await req.json();

    if (!amount || amount <= 0) {
      return new Response(
        JSON.stringify({ error: "Invalid amount" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Secret key is read from Supabase environment secrets — never exposed to client
    const razorpayKeyId = Deno.env.get("RAZORPAY_KEY_ID");
    const razorpaySecretKey = Deno.env.get("RAZORPAY_SECRET");

    if (!razorpayKeyId || !razorpaySecretKey) {
      console.error("Razorpay credentials not configured in Supabase secrets");
      return new Response(
        JSON.stringify({ error: "Payment service not configured" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    // Create Razorpay order via their REST API
    const credentials = btoa(`${razorpayKeyId}:${razorpaySecretKey}`);

    const orderPayload = {
      amount: amount, // already in paise (multiply by 100 in Flutter before calling)
      currency,
      receipt: receipt ?? `rcpt_${Date.now()}`,
      notes: notes ?? {},
    };

    const razorpayResponse = await fetch("https://api.razorpay.com/v1/orders", {
      method: "POST",
      headers: {
        "Authorization": `Basic ${credentials}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(orderPayload),
    });

    if (!razorpayResponse.ok) {
      const errorBody = await razorpayResponse.text();
      console.error("Razorpay API error:", errorBody);
      return new Response(
        JSON.stringify({ error: "Failed to create payment order", details: errorBody }),
        { status: razorpayResponse.status, headers: { ...corsHeaders, "Content-Type": "application/json" } }
      );
    }

    const order = await razorpayResponse.json();

    return new Response(
      JSON.stringify({
        order_id: order.id,
        amount: order.amount,
        currency: order.currency,
        receipt: order.receipt,
      }),
      { headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );

  } catch (err) {
    console.error("Edge function error:", err);
    return new Response(
      JSON.stringify({ error: "Internal server error" }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } }
    );
  }
});
