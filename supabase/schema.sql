-- Supabase Schema and Seed for PixaBeam Events Platform
-- Safe to run in a new Supabase project. Re-running may fail on existing objects; drop first if needed.

-- Enable useful extensions if available
create extension if not exists "uuid-ossp";

-- RSVP status enum
do $$
begin
    if not exists (select 1 from pg_type where typname = 'rsvp_status') then
        create type rsvp_status as enum ('Yes', 'No', 'Maybe');
    end if;
end$$;

-- Users table
create table if not exists public.users (
    id uuid primary key default uuid_generate_v4(),
    name text not null,
    email text not null unique,
    created_at timestamptz not null default now()
);

-- Events table
create table if not exists public.events (
    id uuid primary key default uuid_generate_v4(),
    title text not null,
    description text,
    date timestamptz not null,
    city text not null,
    created_by uuid null references public.users(id) on delete set null,
    created_at timestamptz not null default now()
);

-- RSVPs table
create table if not exists public.rsvps (
    id uuid primary key default uuid_generate_v4(),
    user_id uuid not null references public.users(id) on delete cascade,
    event_id uuid not null references public.events(id) on delete cascade,
    status rsvp_status not null,
    created_at timestamptz not null default now(),
    constraint rsvps_unique_user_event unique (user_id, event_id)
);

-- Helpful indexes
create index if not exists idx_events_date on public.events(date);
create index if not exists idx_rsvps_event on public.rsvps(event_id);
create index if not exists idx_rsvps_user on public.rsvps(user_id);

-- Optional: keep RLS off for quick demo. For production, enable RLS and add policies.
-- alter table public.users enable row level security;
-- alter table public.events enable row level security;
-- alter table public.rsvps enable row level security;

-- ------------------------------------------------------------
-- Seed data
-- ------------------------------------------------------------

-- 10 users
insert into public.users (name, email) values
    ('Alice Johnson', 'alice.johnson@example.com'),
    ('Bob Smith', 'bob.smith@example.com'),
    ('Charlie Lee', 'charlie.lee@example.com'),
    ('Diana Prince', 'diana.prince@example.com'),
    ('Ethan Clark', 'ethan.clark@example.com'),
    ('Fiona Patel', 'fiona.patel@example.com'),
    ('George Kim', 'george.kim@example.com'),
    ('Hannah Davis', 'hannah.davis@example.com'),
    ('Ivan Martinez', 'ivan.martinez@example.com'),
    ('Julia Roberts', 'julia.roberts@example.com')
on conflict (email) do nothing;

-- 5 events (scheduled relative to now so they remain upcoming)
-- First, get the user IDs we need
do $$
declare
    alice_id uuid;
    bob_id uuid;
    diana_id uuid;
    charlie_id uuid;
    fiona_id uuid;
begin
    -- Get user IDs
    select id into alice_id from public.users where email = 'alice.johnson@example.com';
    select id into bob_id from public.users where email = 'bob.smith@example.com';
    select id into diana_id from public.users where email = 'diana.prince@example.com';
    select id into charlie_id from public.users where email = 'charlie.lee@example.com';
    select id into fiona_id from public.users where email = 'fiona.patel@example.com';
    
    -- Insert events
    insert into public.events (title, description, date, city, created_by) values
        (
            'PixaBeam Launch Party',
            'Celebrate the launch of PixaBeam with the team and community.',
            now() + interval '7 days',
            'San Francisco',
            alice_id
        ),
        (
            'Next.js + Supabase Workshop',
            'Hands-on session building full-stack apps with Next.js and Supabase.',
            now() + interval '14 days',
            'New York',
            bob_id
        ),
        (
            'Design Systems Meetup',
            'Share best practices for scalable design systems.',
            now() + interval '21 days',
            'London',
            diana_id
        ),
        (
            'Data Engineering Roundtable',
            'Deep dive into modern data pipelines and tooling.',
            now() + interval '28 days',
            'Berlin',
            charlie_id
        ),
        (
            'Community Hack Night',
            'Open hacking session on community-contributed ideas.',
            now() + interval '35 days',
            'Remote',
            fiona_id
        )
    on conflict do nothing;
end$$;

-- 20 RSVPs across different users and events
do $$
declare
    alice_id uuid;
    bob_id uuid;
    charlie_id uuid;
    diana_id uuid;
    ethan_id uuid;
    fiona_id uuid;
    george_id uuid;
    hannah_id uuid;
    ivan_id uuid;
    julia_id uuid;
    launch_party_id uuid;
    workshop_id uuid;
    meetup_id uuid;
    roundtable_id uuid;
    hack_night_id uuid;
begin
    -- Get user IDs
    select id into alice_id from public.users where email = 'alice.johnson@example.com';
    select id into bob_id from public.users where email = 'bob.smith@example.com';
    select id into charlie_id from public.users where email = 'charlie.lee@example.com';
    select id into diana_id from public.users where email = 'diana.prince@example.com';
    select id into ethan_id from public.users where email = 'ethan.clark@example.com';
    select id into fiona_id from public.users where email = 'fiona.patel@example.com';
    select id into george_id from public.users where email = 'george.kim@example.com';
    select id into hannah_id from public.users where email = 'hannah.davis@example.com';
    select id into ivan_id from public.users where email = 'ivan.martinez@example.com';
    select id into julia_id from public.users where email = 'julia.roberts@example.com';
    
    -- Get event IDs
    select id into launch_party_id from public.events where title = 'PixaBeam Launch Party';
    select id into workshop_id from public.events where title = 'Next.js + Supabase Workshop';
    select id into meetup_id from public.events where title = 'Design Systems Meetup';
    select id into roundtable_id from public.events where title = 'Data Engineering Roundtable';
    select id into hack_night_id from public.events where title = 'Community Hack Night';
    
    -- Insert RSVPs
    insert into public.rsvps (user_id, event_id, status) values
        (alice_id, launch_party_id, 'Yes'),
        (bob_id, launch_party_id, 'Maybe'),
        (charlie_id, launch_party_id, 'No'),
        (diana_id, launch_party_id, 'Yes'),
        (ethan_id, launch_party_id, 'Yes'),
        
        (fiona_id, workshop_id, 'Yes'),
        (george_id, workshop_id, 'Maybe'),
        (hannah_id, workshop_id, 'No'),
        (ivan_id, workshop_id, 'Yes'),
        (julia_id, workshop_id, 'Yes'),
        
        (alice_id, meetup_id, 'Maybe'),
        (bob_id, meetup_id, 'Yes'),
        (charlie_id, meetup_id, 'Yes'),
        (diana_id, meetup_id, 'No'),
        (ethan_id, meetup_id, 'Maybe'),
        
        (fiona_id, roundtable_id, 'Yes'),
        (george_id, roundtable_id, 'Yes'),
        (hannah_id, roundtable_id, 'Maybe'),
        (ivan_id, hack_night_id, 'No'),
        (julia_id, hack_night_id, 'Yes')
    on conflict do nothing;
end$$;

-- Done


