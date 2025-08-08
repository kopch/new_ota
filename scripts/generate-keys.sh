#!/bin/bash

# Generate Supabase keys and secrets
echo "Generating Supabase keys and secrets..."

# Generate JWT secret
JWT_SECRET=$(openssl rand -base64 32)
echo "SUPABASE_JWT_SECRET=$JWT_SECRET"

# Generate anon key
ANON_KEY=$(openssl rand -base64 32)
echo "SUPABASE_ANON_KEY=$ANON_KEY"

# Generate service role key
SERVICE_ROLE_KEY=$(openssl rand -base64 32)
echo "SUPABASE_SERVICE_ROLE_KEY=$SERVICE_ROLE_KEY"

# Generate database password
DB_PASSWORD=$(openssl rand -base64 32)
echo "POSTGRES_PASSWORD=$DB_PASSWORD"

echo ""
echo "Copy these values to your .env file:"
echo "====================================="
echo "SUPABASE_JWT_SECRET=$JWT_SECRET"
echo "SUPABASE_ANON_KEY=$ANON_KEY"
echo "SUPABASE_SERVICE_ROLE_KEY=$SERVICE_ROLE_KEY"
echo "POSTGRES_PASSWORD=$DB_PASSWORD"
echo ""
echo "Remember to also configure:"
echo "- MANUS_API_KEY (from Manus AI)"
echo "- STRIPE_API_KEY and STRIPE_PUBLISHABLE_KEY (from Stripe)"
echo "- AUTH_GOOGLE_CLIENT_ID and AUTH_GOOGLE_CLIENT_SECRET (optional)"
