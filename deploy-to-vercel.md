# Deploy to Vercel

## Step 1: Create GitHub Repository
1. Go to https://github.com/new
2. Repository name: `pixabeam-events-demo`
3. Make it Public
4. Don't initialize with README (we already have one)
5. Click "Create repository"

## Step 2: Push Code to GitHub
```bash
# In your terminal, run these commands:
cd "/Users/amankumar/Desktop/Intern Project"
git remote set-url origin https://github.com/YOUR_USERNAME/pixabeam-events-demo.git
git push -u origin main
```

## Step 3: Deploy to Vercel
1. Go to https://vercel.com
2. Sign in with GitHub
3. Click "New Project"
4. Import your `pixabeam-events-demo` repository
5. Framework Preset: Next.js
6. Root Directory: `pixabeam-events`
7. Click "Deploy"

## Step 4: Add Environment Variables
1. In your Vercel project dashboard
2. Go to Settings → Environment Variables
3. Add these variables:
   - `NEXT_PUBLIC_SUPABASE_URL` = your Supabase project URL
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY` = your Supabase anon key
4. Redeploy the project

## Step 5: Test Live App
1. Your app will be available at: `https://pixabeam-events-demo.vercel.app`
2. Test the events list and RSVP functionality
3. Verify data is being saved to Supabase

## Troubleshooting
- If you get build errors, check that all environment variables are set
- Make sure Supabase project is running and accessible
- Check Vercel build logs for any issues
