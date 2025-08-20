#!/bin/bash

echo "🚀 PixaBeam Events Setup Script"
echo "================================"
echo ""

# Check if .env.local exists
if [ -f "pixabeam-events/.env.local" ]; then
    echo "✅ Environment file already exists"
else
    echo "📝 Creating environment file..."
    cp pixabeam-events/.env.local.example pixabeam-events/.env.local
fi

echo ""
echo "🔑 Please provide your Supabase credentials:"
echo ""

# Get Supabase URL
read -p "Enter your Supabase Project URL: " supabase_url
if [ ! -z "$supabase_url" ]; then
    sed -i '' "s|your-supabase-url|$supabase_url|g" pixabeam-events/.env.local
    echo "✅ Supabase URL updated"
fi

# Get Supabase anon key
read -p "Enter your Supabase anon key: " supabase_key
if [ ! -z "$supabase_key" ]; then
    sed -i '' "s|your-anon-key|$supabase_key|g" pixabeam-events/.env.local
    echo "✅ Supabase anon key updated"
fi

echo ""
echo "🎉 Environment setup complete!"
echo "You can now run: cd pixabeam-events && npm run dev"
echo ""
