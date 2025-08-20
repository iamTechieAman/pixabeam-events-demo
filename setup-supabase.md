# Setup Supabase Cloud Project

## Step 1: Create Supabase Project
1. Go to https://supabase.com
2. Click "Start your project" or "Sign In"
3. Sign in with GitHub (create account if needed)
4. Click "New Project"
5. Choose your organization
6. Project name: `pixabeam-events-demo`
7. Database password: `pixabeam123` (or choose your own)
8. Region: Choose closest to you
9. Click "Create new project"

## Step 2: Get Project Credentials
1. Wait for project to be ready (green status)
2. Go to Settings → API
3. Copy these values:
   - Project URL (starts with https://)
   - anon/public key (starts with eyJ...)

## Step 3: Run Database Schema
1. Go to SQL Editor
2. Copy the entire content of `supabase/schema.sql`
3. Paste and click "Run"
4. Verify tables are created in Database → Tables

## Step 4: Update App Environment
1. Copy `.env.local.example` to `.env.local` in `pixabeam-events/`
2. Fill in your Supabase URL and anon key
3. Save the file

## Step 5: Test Locally
```bash
cd pixabeam-events
npm run dev
```
Open http://localhost:3000

## Step 6: Deploy to Vercel
1. Push to GitHub (I'll help with this)
2. Import to Vercel
3. Add environment variables
4. Deploy
