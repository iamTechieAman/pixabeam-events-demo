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
insert into public.events (title, description, date, city, created_by) values
    (
        'PixaBeam Launch Party',
        'Celebrate the launch of PixaBeam with the team and community.',
        now() + interval '7 days',
        'San Francisco',
        (select id from public.users where email = 'alice.johnson@example.com')
    ),
    (
        'Next.js + Supabase Workshop',
        'Hands-on session building full-stack apps with Next.js and Supabase.',
        now() + interval '14 days',
        'New York',
        (select id from public.users where email = 'bob.smith@example.com')
    ),
    (
        'Design Systems Meetup',
        'Share best practices for scalable design systems.',
        now() + interval '21 days',
        'London',
        (select id from public.users where email = 'diana.prince@example.com')
    ),
    (
        'Data Engineering Roundtable',
        'Deep dive into modern data pipelines and tooling.',
        now() + interval '28 days',
        'Berlin',
        (select id from public.users where email = 'charlie.lee@example.com')
    ),
    (
        'Community Hack Night',
        'Open hacking session on community-contributed ideas.',
        now() + interval '35 days',
        'Remote',
        (select id from public.users where email = 'fiona.patel@example.com')
    )
on conflict do nothing;

-- 20 RSVPs across different users and events
-- Helper CTEs for readability
with u as (
    select email, id from public.users
), e as (
    select title, id from public.events
)
insert into public.rsvps (user_id, event_id, status)
values
    ((select id from u where email='alice.johnson@example.com'), (select id from e where title='PixaBeam Launch Party'), 'Yes'),
    ((select id from u where email='bob.smith@example.com'), (select id from e where title='PixaBeam Launch Party'), 'Maybe'),
    ((select id from u where email='charlie.lee@example.com'), (select id from e where title='PixaBeam Launch Party'), 'No'),
    ((select id from u where email='diana.prince@example.com'), (select id from e where title='PixaBeam Launch Party'), 'Yes'),
    ((select id from u where email='ethan.clark@example.com'), (select id from e where title='PixaBeam Launch Party'), 'Yes'),

    ((select id from u where email='fiona.patel@example.com'), (select id from e where title='Next.js + Supabase Workshop'), 'Yes'),
    ((select id from u where email='george.kim@example.com'), (select id from e where title='Next.js + Supabase Workshop'), 'Maybe'),
    ((select id from u where email='hannah.davis@example.com'), (select id from e where title='Next.js + Supabase Workshop'), 'No'),
    ((select id from u where email='ivan.martinez@example.com'), (select id from e where title='Next.js + Supabase Workshop'), 'Yes'),
    ((select id from u where email='julia.roberts@example.com'), (select id from e where title='Next.js + Supabase Workshop'), 'Yes'),

    ((select id from u where email='alice.johnson@example.com'), (select id from e where title='Design Systems Meetup'), 'Maybe'),
    ((select id from u where email='bob.smith@example.com'), (select id from e where title='Design Systems Meetup'), 'Yes'),
    ((select id from u where email='charlie.lee@example.com'), (select id from e where title='Design Systems Meetup'), 'Yes'),
    ((select id from u where email='diana.prince@example.com'), (select id from e where title='Design Systems Meetup'), 'No'),
    ((select id from u where email='ethan.clark@example.com'), (select id from e where title='Design Systems Meetup'), 'Maybe'),

    ((select id from u where email='fiona.patel@example.com'), (select id from e where title='Data Engineering Roundtable'), 'Yes'),
    ((select id from u where email='george.kim@example.com'), (select id from e where title='Data Engineering Roundtable'), 'Yes'),
    ((select id from u where email='hannah.davis@example.com'), (select id from e where title='Data Engineering Roundtable'), 'Maybe'),
    ((select id from u where email='ivan.martinez@example.com'), (select id from e where title='Community Hack Night'), 'No'),
    ((select id from u where email='julia.roberts@example.com'), (select id from e where title='Community Hack Night'), 'Yes')
on conflict do nothing;

-- Done


