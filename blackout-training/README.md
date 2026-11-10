# BLACKOUT TRAINING — App starter v1.0

A responsive, installable Progressive Web App starter for basketball and football athletes. Includes a local demo experience and optional Supabase authentication/cloud persistence.

## Included now

- Responsive desktop and mobile layouts with BLACKOUT black / blood-red identity
- Demo sign-in and locally saved profile/workout data
- Optional Supabase email/password sign-up and sign-in
- Dashboard, basketball and football workout catalog, custom workout logging
- AI Coach interface with a local starter response guide (not a live AI model)
- Performance stats, measurements, XP, streaks, challenge demo and badges
- Video library placeholders, recovery center, athlete profile
- Free / proposed Pro membership screens (demo toggle only; no real billing)
- PWA manifest and service worker for installability/offline shell

## Run locally

You need a current Node.js installation.

```bash
npx serve .
```

Then open the local URL printed by the command. You can also use another static web server. Do not open `index.html` as a `file://` URL because ES modules and service workers need HTTP.

## Enable real accounts and cloud storage

1. Create a Supabase project.
2. In Supabase SQL Editor, run `supabase/schema.sql`.
3. In Authentication settings, enable Email provider and configure your allowed redirect URLs.
4. Copy the Project URL and anon/publishable key into `config.js`.
5. Deploy the folder to an HTTPS static host (for example, Vercel, Netlify, or Cloudflare Pages).

The browser app uses the public anon key only. Row Level Security policies restrict private records to their owner. Never put a Supabase service-role key in frontend code.

## What still needs production integration

This is a runnable MVP starter, not a deployed production service. The following require provider accounts, credentials, implementation, and testing:

- Live AI coach: add a server-side Edge Function/API route that calls your chosen model. Keep AI secrets server-side, enforce rate limits, age-appropriate behavior, and safety checks.
- Payments: integrate Stripe or another supported billing provider with server-side webhook verification and entitlement checks. The $9.99/month figure is illustrative only.
- Video lessons: add licensed video URLs or your own hosted coaching content.
- Live leaderboards: implement a privacy-safe Supabase RPC/view that exposes only intended public ranking fields.
- Push notifications, parental/guardian workflows for minors, moderation, analytics, backups, and account deletion.
- Native App Store / Google Play packaging: wrap the PWA or build native clients, then complete store compliance and review.

## Important

The app is designed for athletes of different ages. Before serving minors, add appropriate guardian consent, privacy disclosures, age-appropriate defaults, and jurisdiction-specific compliance. The training content is general education and not medical advice. Have qualified coaches review all programs before launch.
