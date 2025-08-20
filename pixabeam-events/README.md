# PixaBeam Events — Next.js + Supabase Demo

Minimal demo showing how the database powers a simple app:
- Lists upcoming events
- RSVP to an event (Yes/No/Maybe) by email

## Setup

1) Create a Supabase project and run the SQL in `../supabase/schema.sql` (from repo root) or paste it into the Supabase SQL editor.

2) Copy `.env.local.example` to `.env.local` and fill in values from your Supabase project:

```
NEXT_PUBLIC_SUPABASE_URL=...
NEXT_PUBLIC_SUPABASE_ANON_KEY=...
```

3) Install and run locally:

```
npm install
npm run dev
```

Open `http://localhost:3000`.

## Deploy to Vercel

1) Push this project to GitHub
2) Import to Vercel
3) Add env vars `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`
4) Deploy

## Notes

- No auth required; users are created on-the-fly by email to keep the demo minimal.
- RLS is disabled in SQL seed for speed. Enable RLS with policies for production.

This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.
